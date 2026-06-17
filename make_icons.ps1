Add-Type -AssemblyName System.Drawing

function Make-Icon {
    param([int]$size, [string]$path)

    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $bg = [System.Drawing.Color]::FromArgb(11, 18, 32)
    $g.Clear($bg)

    $accent = [System.Drawing.Color]::FromArgb(79, 140, 255)
    $pen = New-Object System.Drawing.Pen $accent, ([float]($size * 0.045))
    $pen.LineJoin  = [System.Drawing.Drawing2D.LineJoin]::Round
    $pen.StartCap  = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap    = [System.Drawing.Drawing2D.LineCap]::Round

    $pts = @(
        (New-Object System.Drawing.PointF ([float]($size*0.10)), ([float]($size*0.58))),
        (New-Object System.Drawing.PointF ([float]($size*0.24)), ([float]($size*0.58))),
        (New-Object System.Drawing.PointF ([float]($size*0.24)), ([float]($size*0.34))),
        (New-Object System.Drawing.PointF ([float]($size*0.40)), ([float]($size*0.34))),
        (New-Object System.Drawing.PointF ([float]($size*0.40)), ([float]($size*0.58))),
        (New-Object System.Drawing.PointF ([float]($size*0.55)), ([float]($size*0.58))),
        (New-Object System.Drawing.PointF ([float]($size*0.55)), ([float]($size*0.34))),
        (New-Object System.Drawing.PointF ([float]($size*0.71)), ([float]($size*0.34))),
        (New-Object System.Drawing.PointF ([float]($size*0.71)), ([float]($size*0.58))),
        (New-Object System.Drawing.PointF ([float]($size*0.90)), ([float]($size*0.58)))
    )
    $g.DrawLines($pen, $pts)

    $fontSize = [int]($size * 0.20)
    $font = New-Object System.Drawing.Font 'Segoe UI', $fontSize, ([System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(231, 236, 245))
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $textRect = New-Object System.Drawing.RectangleF 0, ([float]($size*0.66)), $size, ([float]($size*0.30))
    $g.DrawString('RPM', $font, $brush, $textRect, $sf)

    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

Make-Icon 192 (Join-Path $PSScriptRoot 'icon-192.png')
Make-Icon 512 (Join-Path $PSScriptRoot 'icon-512.png')
Make-Icon 180 (Join-Path $PSScriptRoot 'icon-180.png')

Get-ChildItem (Join-Path $PSScriptRoot 'icon-*.png') | Format-Table Name, Length
