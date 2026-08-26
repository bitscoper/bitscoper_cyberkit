// By Abdullah As-Sadeed

import java.util.Properties
import java.io.FileInputStream

// https://mvnrepository.com/artifact/com.android.tools/desugar_jdk_libs
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

flutter {
    source = "../.."
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use {
        localProperties.load(it)
    }
}

val flutterVersionCode: Int =
    localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1

val flutterVersionName: String =
    localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "bitscoper.bitscoper_cyberkit"

    ndkVersion = flutter.ndkVersion
    compileSdk = maxOf(37, flutter.compileSdkVersion)

    defaultConfig {
        applicationId = "bitscoper.bitscoper_cyberkit"

        minSdk = flutter.minSdkVersion
        targetSdk = maxOf(37, flutter.targetSdkVersion)

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    dependenciesInfo {
        includeInBundle = false
        includeInApk = false
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_25
        targetCompatibility = JavaVersion.VERSION_25
    }

    signingConfigs {
        create("release") {
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_25
    }
}
