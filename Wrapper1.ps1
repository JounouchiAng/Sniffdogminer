﻿$PowerShell.Streams.Verbose.ReadAll() | ForEach-Object {
        $Line = $_

        if ($Line -like "*total speed:*" -or $Line -like "*accepted:*") {
            $Words = $Line -split " "
            $HashRate = [Decimal]$Words[$Words.IndexOf(($Words -like "*/s" | Select-Object -Last 1)) - 1]

            switch ($Words[$Words.IndexOf(($Words -like "*/s" | Select-Object -Last 1))]) {
                "kh/s" {$HashRate *= [Math]::Pow(1000, 1)}
                "mh/s" {$HashRate *= [Math]::Pow(1000, 2)}
                "gh/s" {$HashRate *= [Math]::Pow(1000, 3)}
                "th/s" {$HashRate *= [Math]::Pow(1000, 4)}
                "ph/s" {$HashRate *= [Math]::Pow(1000, 5)}
            }

            $HashRate | Set-Content ".\Wrapper_$Id.txt"
        } elseif ($Line -like "*overall speed is*") {
            $Words = $Line -split " "
            $HashRate = [Decimal]($Words -like "*H/s*" -replace ',', '' -replace "[^0-9.]",'' | Select-Object -Last 1)

            switch ($Words -like "*H/s*" -replace "[0-9.,]",'' | Select-Object -Last 1) {
                "KH/s" {$HashRate *= [Math]::Pow(1000, 1)}
                "mH/s" {$HashRate *= [Math]::Pow(1000, 2)}
                "MH/s" {$HashRate *= [Math]::Pow(1000, 2)}
            }

            $HashRate | Set-Content ".\Wrapper_$Id.txt"
        }

        $Line
    }