<div align="center">
  <img src="assets/icon/icon.png" height="128" alt="Bitscoper Cyber ToolBox" />
</div>
<div align="center">

# Bitscoper Cyber ToolBox

A Flutter application consisting of TCP Port Scanner, Route Tracer, Pinger, File Hash Calculator, String Hash Calculator, Base Encoder, Morse Code Translator, Open Graph Protocol Data Extractor, Series URI Crawler, DNS Record Retriever, and WHOIS Retriever.

[![Build and Release](https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/actions/workflows/Build%20and%20Release.yaml/badge.svg)](https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/actions/workflows/Build%20and%20Release.yaml)

<a href="https://apps.microsoft.com/detail/9n6r5lxczxl6">
  <img src="https://get.microsoft.com/images/en-us%20dark.svg" height="48" alt="Microsoft Store" />
</a>
<a href="https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyber_toolbox">
  <img src="https://raw.githubusercontent.com/bitscoper/bitscoper/main/External_Files/Google_Play.png" height="48" alt="Google Play" />
</a>
<a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/pkgs/container/bitscoper_cyber_toolbox/">
  <img src="https://raw.githubusercontent.com/bitscoper/bitscoper/main/External_Files/Docker.png" height="48" alt="Docker Images" />
</a>
</div>

## [Latest Release](https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/)

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

Code --> iOS{iOS}
iOS --> |Not Signing Yet| iOS_Executable(Executable)

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
iOS_Executable --> Release[Release]
Windows_x64_Executable --> Release[Release]
Windows_x64_MSIX_Package --> Release[Release]
Web --> Release[Release]

Linux_x64_Executable --> Docker_Image(Docker Image)
Docker_Image --> GHCR[GHCR]
Docker_Image --> Amazon_ECR[Amazon ECR]

Android_appbundle --> |Manual Submission| Google_Play[Google Play]
Windows_x64_MSIX_Package --> |Manual Submission| Microsoft_Store[Microsoft Store]
```

  <table>
    <tr>
      <th colspan="2">Platform</th>
      <th colspan="2">Builds</th>
      <th>Debug Symbols</th>
      <th>Stores / Repositories</th>
    </tr>
    <tr>
      <th rowspan="2" colspan="2">Linux</th>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Linux_x64_Executable.zip">Linux_x64_Executable.zip</a>
      </td>
      <td rowspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Linux_x64_Debug_Symbols.zip">Linux_x64_Debug_Symbols.zip</a>
      </td>
      <td rowspan="2">-</td>
    </tr>
    <tr>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Bitscoper_Cyber_ToolBox-12.0.1-x64.AppImage">Bitscoper_Cyber_ToolBox-12.0.1-x64.AppImage</a>
      </td>
    </tr>
    <tr>
      <th rowspan="4" width="46">Android</th>
      <th>appbundle</th>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Android_appbundle.zip">Android_appbundle.zip</a>
      </td>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Android_appbundle_Debug_Symbols.zip">Android_appbundle_Debug_Symbols.zip</a>
      </td>
      <td rowspan="4">
        <a href="https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyber_toolbox">Google Play</a> *
      </td>
    </tr>
    <tr>
      <th rowspan="3">APK</th>
      <td rowspan="2">ARM</td>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/APK_ARM64_V8A.zip">APK_ARM64_V8A.zip</a>
      </td>
      <td rowspan="3">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/APK_Debug_Symbols.zip">APK_Debug_Symbols.zip</a>
      </td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/APK_ARMEABI_V7A.zip">APK_ARMEABI_V7A.zip</a>
      </td>
    </tr>
    <tr>
      <td>x86_64</td>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/APK_x86_64.zip">APK_x86_64.zip</a>
      </td>
    </tr>
    <tr>
      <th colspan="2">macOS</th>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/macOS_Executable.zip">macOS_Executable.zip</a>
      </td>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/macOS_Debug_Symbols.zip">macOS_Debug_Symbols.zip</a>
      </td>
      <td>-</td>
    </tr>
    <tr>
      <th colspan="2">iOS</th>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/iOS_Application.zip">iOS_Application.zip</a>
      </td>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/iOS_Debug_Symbols.zip">iOS_Debug_Symbols.zip</a>
      </td>
      <td>-</td>
    </tr>
    <tr>
      <th rowspan="2" colspan="2">Windows</th>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Windows_x64_Executable.zip">Windows_x64_Executable.zip</a>
      </td>
      <td rowspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Windows_x64_Debug_Symbols.zip">Windows_x64_Debug_Symbols.zip</a>
      </td>
      <td rowspan="2">
        <a href="https://apps.microsoft.com/detail/9n6r5lxczxl6">Microsoft Store</a> *
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Windows_x64_MSIX_Package.zip">Windows_x64_MSIX_Package.zip</a>
      </td>
    </tr>
    <tr>
      <th colspan="2">Web</th>
      <td colspan="2">
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Web_Application.zip">Web_Application.zip</a>
        <br /> (Not Recommended)
      </td>
      <td>-</td>
      <td>-</td>
    </tr>
    <tr>
      <th colspan="2" rowspan="2">Docker / Podman</th>
      <td colspan="2" rowspan="2">-</td>
      <td rowspan="2">-</td>
      <td>
        <a href="https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/pkgs/container/bitscoper_cyber_toolbox/">GHCR</a>
      </td>
    </tr>
    <tr>
      <td>
        <a href="">Amazon ECR</a>
      </td>
    </tr>
  </table>
</div>

\* Versions are submitted to the marked stores manually, so releases may be delayed.

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

## Using Docker / Podman Locally on Linux

### Build

```bash
docker build -t bitscoper_cyber_toolbox .
```

### Run

```bash
xhost +si:localuser:root && docker run --rm -it -e DISPLAY=$DISPLAY -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY -v /run/user/$(id -u)/wayland-0:/run/user/$(id -u)/wayland-0 -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR bitscoper_cyber_toolbox
```

## Development Configuration Commands

### Name

```bash
flutter pub run rename setAppName --targets linux --value "Bitscoper_Cyber_ToolBox"
```

```bash
flutter pub run rename setAppName --targets android,macos,ios,windows,web --value "Bitscoper Cyber ToolBox"
```

### ID

```bash
flutter pub run rename setBundleId --targets linux,android,macos,ios,windows,web --value "bitscoper.bitscoper_cyber_toolbox"
```

### Icon

```bash
flutter pub run flutter_launcher_icons
```

### Splash Screen

```bash
flutter pub run flutter_native_splash:create
```

### Android Keystore

#### Generation

```bash
keytool -genkey -v -keystore ~/Laboratory/Bitscoper\ Cyber\ ToolBox/KeyStore.jks -keyalg RSA -keysize 4096 -validity 10000 -alias Bitscoper_Cyber_ToolBox
```

#### Conversion to Base64

```bash
base64 ~/Laboratory/Bitscoper\ Cyber\ ToolBox/KeyStore.jks > ~/Laboratory/Bitscoper\ Cyber\ ToolBox/KeyStore.b64
```
