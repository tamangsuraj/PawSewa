#!/usr/bin/env powershell
# Google Sign-In Configuration Checker for PawSewa

Write-Host "`n🔍 Checking Google Sign-In Configuration...`n" -ForegroundColor Cyan

$errorFound = $false

# Check 1: google-services.json exists
Write-Host "✓ Checking google-services.json..." -NoNewline
$googleServicesPath = "android/app/google-services.json"
if (Test-Path $googleServicesPath) {
    Write-Host " EXISTS" -ForegroundColor Green
    
    # Read and parse JSON
    $googleServices = Get-Content $googleServicesPath -Raw | ConvertFrom-Json
    
    # Check package name
    $packageName = $googleServices.client[0].client_info.android_client_info.package_name
    Write-Host "  Package: $packageName" -ForegroundColor Gray
    
    # Check OAuth clients
    $oauthClients = $googleServices.client[0].oauth_client
    if ($oauthClients.Count -eq 0 -or $null -eq $oauthClients) {
        Write-Host "  ❌ OAuth clients: EMPTY (This is the problem!)" -ForegroundColor Red
        Write-Host "     You need to add SHA keys to Firebase and re-download this file." -ForegroundColor Yellow
        $errorFound = $true
    } else {
        Write-Host "  ✅ OAuth clients: $($oauthClients.Count) configured" -ForegroundColor Green
        foreach ($client in $oauthClients) {
            $clientType = switch ($client.client_type) {
                1 { "Web" }
                2 { "iOS" }
                3 { "Android" }
                default { "Unknown" }
            }
            Write-Host "     - $clientType Client: $($client.client_id.Substring(0, 20))..." -ForegroundColor Gray
        }
    }
} else {
    Write-Host " NOT FOUND" -ForegroundColor Red
    $errorFound = $true
}

# Check 2: build.gradle.kts package name
Write-Host "`n✓ Checking build.gradle.kts..." -NoNewline
$buildGradlePath = "android/app/build.gradle.kts"
if (Test-Path $buildGradlePath) {
    Write-Host " EXISTS" -ForegroundColor Green
    $buildGradleContent = Get-Content $buildGradlePath -Raw
    if ($buildGradleContent -match 'applicationId\s*=\s*"([^"]+)"') {
        $appId = $matches[1]
        Write-Host "  Application ID: $appId" -ForegroundColor Gray
        
        if ($null -ne $packageName -and $appId -ne $packageName) {
            Write-Host "  ⚠️  WARNING: Application ID doesn't match google-services.json!" -ForegroundColor Yellow
            $errorFound = $true
        }
    }
} else {
    Write-Host " NOT FOUND" -ForegroundColor Red
    $errorFound = $true
}

# Check 3: pubspec.yaml dependencies
Write-Host "`n✓ Checking pubspec.yaml dependencies..." -NoNewline
$pubspecPath = "pubspec.yaml"
if (Test-Path $pubspecPath) {
    Write-Host " EXISTS" -ForegroundColor Green
    $pubspecContent = Get-Content $pubspecPath -Raw
    
    if ($pubspecContent -match 'google_sign_in:\s*\^?(\d+\.\d+\.\d+)') {
        Write-Host "  google_sign_in: ^$($matches[1])" -ForegroundColor Gray
    } else {
        Write-Host "  ❌ google_sign_in: NOT FOUND" -ForegroundColor Red
        $errorFound = $true
    }
    
    if ($pubspecContent -match 'firebase_auth:\s*\^?(\d+\.\d+\.\d+)') {
        Write-Host "  firebase_auth: ^$($matches[1])" -ForegroundColor Gray
    } else {
        Write-Host "  ❌ firebase_auth: NOT FOUND" -ForegroundColor Red
        $errorFound = $true
    }
    
    if ($pubspecContent -match 'firebase_core:\s*\^?(\d+\.\d+\.\d+)') {
        Write-Host "  firebase_core: ^$($matches[1])" -ForegroundColor Gray
    } else {
        Write-Host "  ❌ firebase_core: NOT FOUND" -ForegroundColor Red
        $errorFound = $true
    }
} else {
    Write-Host " NOT FOUND" -ForegroundColor Red
    $errorFound = $true
}

# Check 4: Debug keystore exists
Write-Host "`n✓ Checking debug keystore..." -NoNewline
$debugKeystorePath = "$env:USERPROFILE\.android\debug.keystore"
if (Test-Path $debugKeystorePath) {
    Write-Host " EXISTS" -ForegroundColor Green
    Write-Host "  Location: $debugKeystorePath" -ForegroundColor Gray
} else {
    Write-Host " NOT FOUND" -ForegroundColor Yellow
    Write-Host "  Run 'flutter run' once to generate it." -ForegroundColor Gray
}

# Summary
Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
if ($errorFound) {
    Write-Host "❌ CONFIGURATION ISSUES FOUND" -ForegroundColor Red
    Write-Host "`nNext Steps:" -ForegroundColor Yellow
    Write-Host "1. Read GOOGLE_SIGNIN_FIX_GUIDE.md for detailed instructions"
    Write-Host "2. Add SHA-1 and SHA-256 to Firebase Project Settings"
    Write-Host "3. Create OAuth Client IDs in Google Cloud Console"
    Write-Host "4. Re-download google-services.json and replace the old one"
    Write-Host "5. Run: flutter clean && flutter pub get"
} else {
    Write-Host "✅ BASIC CONFIGURATION LOOKS GOOD" -ForegroundColor Green
    Write-Host "`nIf still getting errors, verify:" -ForegroundColor Yellow
    Write-Host "• SHA-1 and SHA-256 are added to Firebase"
    Write-Host "• Web Client ID is configured in Firebase Authentication"
    Write-Host "• google-services.json was downloaded AFTER adding SHA keys"
}
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""
