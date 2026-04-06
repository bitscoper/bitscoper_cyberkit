// By Abdullah As-Sadeed

toolchainManagement {
    jvm {
        javaRepositories {
            repository("foojay") {
                resolverClass.set(org.gradle.toolchains.foojay.FoojayToolchainResolver::class.java)
            }
        }
    }
}

pluginManagement {
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

    repositories {
        google()
        mavenCentral {
            setUrl("https://repo1.maven.org/maven2")
        }
        maven {
            setUrl("https://repo1.maven.org/maven2")
        }
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.application") version "8.12.3" apply false // https://developer.android.com/build/releases/gradle-plugin
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("org.gradle.toolchains.foojay-resolver") version "1.0.0"
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false // https://plugins.gradle.org/plugin/org.jetbrains.kotlin.android
}

include(":app")
