/* Service worker for offline support */
const CACHE_VERSION = 'rpm-downlink-v4';
const PRECACHE_URLS = [
    './',
    './index.html',
    './manifest.webmanifest',
    './icon.svg',
    './icon-180.png',
    './icon-192.png',
    './icon-512.png',
    './beep_regular.wav',
    './beep_final.wav'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_VERSION)
            .then((cache) => cache.addAll(PRECACHE_URLS))
            .then(() => self.skipWaiting())
    );
});

self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((keys) =>
            Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k)))
        ).then(() => self.clients.claim())
    );
});

self.addEventListener('fetch', (event) => {
    const req = event.request;
    if (req.method !== 'GET') return;

    // For navigation requests, always try cache first and fall back to the
    // cached index.html so deep links / refreshes work offline.
    if (req.mode === 'navigate') {
        event.respondWith(
            caches.match(req).then((cached) =>
                cached ||
                fetch(req).catch(() =>
                    caches.match('./index.html').then((idx) => idx ||
                        new Response('Offline', { status: 503, statusText: 'Offline' }))
                )
            )
        );
        return;
    }

    // For other GETs: cache-first, then network (and update cache on success).
    event.respondWith(
        caches.match(req).then((cached) => {
            const networkFetch = fetch(req).then((resp) => {
                if (resp && resp.status === 200 && resp.type === 'basic') {
                    const copy = resp.clone();
                    caches.open(CACHE_VERSION).then((cache) => cache.put(req, copy)).catch(() => {});
                }
                return resp;
            }).catch(() => cached);
            return cached || networkFetch;
        })
    );
});
