<div align="center">
  <img src="assets/icon/icon.png" height="128" alt="Bitscoper Cyber ToolBox" />
</div>
<div align="center">

# Bitscoper Cyber ToolBox

A Flutter application consisting of TCP Port Scanner, Route Tracer, Pinger, File Hash Calculator, String Hash Calculator, Base Encoder, Morse Code Translator, Open Graph Protocol Data Extractor, Series URI Crawler, DNS Record Retriever, and WHOIS Retriever.

[![Build and Release](https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/actions/workflows/Build%20and%20Release.yaml/badge.svg)](https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/actions/workflows/Build%20and%20Release.yaml)

</div>

## Stores and Repositories

<div align="center">
    <a href="https://apps.microsoft.com/detail/9n6r5lxczxl6"><img
            src="https://get.microsoft.com/images/en-us%20dark.svg" height="48" alt="Microsoft Store" /></a>
    <a href="https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyber_toolbox"><img
            src="https://raw.githubusercontent.com/bitscoper/bitscoper/main/External_Files/Google_Play.png" height="48"
            alt="Google Play" /></a>
    <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/pkgs/container/bitscoper_cyber_toolbox/"><img
            src="https://raw.githubusercontent.com/bitscoper/bitscoper/main/External_Files/Docker.png" height="48"
            alt="Docker Images" /></a>
</div>

## [Releases](https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/)

<div align="center">

```mermaid
flowchart LR

Code[Code] --> Linux{Linux}
Linux --> Linux_x64_Executable(x64 Executable)
Linux_x64_Executable --> Linux_x64_AppImage(x64 AppImage)

Code --> Android{Android}
Android --> |Signing| Android_appbundle(appbundle)
Android --> |Signing| Android_x86_64_APK(x86_64 APK)
Android --> |Signing| Android_ARM64_V8A_APK(ARM64 V8A APK)
Android --> |Signing| Android_ARMEABI_V7A_APK(ARMEABI V7A APK)

Code --> macOS{macOS}
macOS --> macOS_Executable(Executable)

Code --> |Coming Soon| iOS{iOS}

Code --> Windows{Windows}
Windows --> Windows_x64_Executable(x64 Executable)
Windows_x64_Executable --> |Signing| Windows_x64_MSIX_Package(MSIX Package)

Code --> |Not Recommended| Web{Web}

Linux_x64_Executable --> Release[Release]
Linux_x64_AppImage --> Release[Release]
Android_appbundle --> Release[Release]
Android_x86_64_APK --> Release[Release]
Android_ARM64_V8A_APK --> Release[Release]
Android_ARMEABI_V7A_APK --> Release[Release]
macOS_Executable --> Release[Release]
Windows_x64_Executable --> Release[Release]
Windows_x64_MSIX_Package --> Release[Release]
Web --> Release[Release]

Android_appbundle --> |Manual Update| Google_Play[Google Play]
Windows_x64_MSIX_Package --> |Manual Update| Microsoft_Store[Microsoft Store]

Linux_x64_Executable --> Docker_Image(Docker Image) --> GHCR[GHCR]
```

Respective debug symbols are also uploaded for release.

</div>

## Tools

### 1. TCP Port Scanner

Scans ports from 0 to 65535 on a target server and reports the open ports.

### 2. Route Tracer

Traces the route to a target server, showing each hop along the route with its corresponding IP address.

### 3. Pinger

Pings a target server and reports the IP address, TTL, and time.

### 4. File Hash Calculator

Calculates MD5, SHA1, SHA224, SHA256, SHA384, and SHA512 hashes of files.

### 5. String Hash Calculator

Calculates MD5, SHA1, SHA224, SHA256, SHA384, and SHA512 hashes of a string.

### 6. Base Encoder

Encodes a string into binary (Base2), ternary (Base3), quaternary (Base4), quinary (Base5), senary (Base6), octal (Base8), decimal (Base10), duodecimal (Base12), hexadecimal (Base16), Base32, Base32Hex, Base36, Base58, Base62, Base64, and Base64 URL.

### 7. Morse Code Translator

Translates English to Morse code and vice versa.

### 8. Open Graph Protocol Data Extractor

Extracts Open Graph Protocol (OGP) data of an webpage.

### 9. Series URI Crawler

Crawls the available webpages in series by number and lists the available ones.

### 10. DNS Record Retriever

Retrieves A, AAAA, ANY, CAA, CDS, CERT, CNAME, DNAME, DNSKEY, DS, HINFO, IPSECKEY, NSEC, NSEC3PARAM, NAPTR, PTR, RP, RRSIG, SOA, SPF, SRV, SSHFP, TLSA, WKS, TXT, NS, and MX records of a domain name (forward) or an IP address (reverse).

### 11. WHOIS Retriever

Retrieves WHOIS information about a domain name.

## Configuration Commands

### Name

`flutter pub run rename setAppName --targets linux --value "Bitscoper_Cyber_ToolBox"`

`flutter pub run rename setAppName --targets android,macos,ios,windows,web --value "Bitscoper Cyber ToolBox"`

### ID

`flutter pub run rename setBundleId --targets linux,android,macos,ios,windows,web --value "bitscoper.bitscoper_cyber_toolbox"`

### Icon

`flutter pub run flutter_launcher_icons`

### Splash Screen

`flutter pub run flutter_native_splash:create`

### Android Keystore

`keytool -genkey -v -keystore ~/Laboratory/Bitscoper\ Cyber\ ToolBox/KeyStore.jks -keyalg RSA -keysize 4096 -validity 10000 -alias Bitscoper_Cyber_ToolBox`

`base64 ~/Laboratory/Bitscoper\ Cyber\ ToolBox/KeyStore.jks > ~/Laboratory/Bitscoper\ Cyber\ ToolBox/KeyStore.b64`
