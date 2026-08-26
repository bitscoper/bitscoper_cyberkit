// By Abdullah As-Sadeed

include(":app")

pluginManagement {
    repositories {
        google()
        gradlePluginPortal()
        maven {
            setUrl("https://repo1.maven.org/maven2")
        }
        mavenCentral {
            setUrl("https://repo1.maven.org/maven2")
        }
    }

    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }
    extra["flutterSdkPath"] = flutterSdkPath

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.3.1" apply false // https://developer.android.com/build/releases/gradle-plugin
    id("org.jetbrains.kotlin.android") version "2.4.10" apply false // https://plugins.gradle.org/plugin/org.jetbrains.kotlin.android
}
