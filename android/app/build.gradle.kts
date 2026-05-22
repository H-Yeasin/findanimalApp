import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

fun dartDefineValue(name: String): String? {
    val encodedDefines = project.findProperty("dart-defines") as? String ?: return null

    return encodedDefines
        .split(",")
        .mapNotNull { encodedDefine ->
            runCatching {
                String(Base64.getDecoder().decode(encodedDefine))
            }.getOrNull()
        }
        .firstOrNull { decodedDefine -> decodedDefine.startsWith("$name=") }
        ?.substringAfter("=")
}

val releaseTaskRequested = gradle.startParameter.taskNames.any {
    it.contains("Release", ignoreCase = true)
}
val androidAppBuildTaskRequested = gradle.startParameter.taskNames.any {
    it.contains("assemble", ignoreCase = true) ||
        it.contains("bundle", ignoreCase = true) ||
        it.contains("install", ignoreCase = true)
}
val googleMapsApiKey = dartDefineValue("GOOGLE_MAPS_API_KEY")
    ?: System.getenv("GOOGLE_MAPS_API_KEY")
    ?: ""

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

val hasReleaseKeystore = listOf(
    "storeFile",
    "storePassword",
    "keyAlias",
    "keyPassword"
).all { key -> !keystoreProperties.getProperty(key).isNullOrBlank() }

if (androidAppBuildTaskRequested && googleMapsApiKey.isBlank()) {
    throw GradleException(
        "GOOGLE_MAPS_API_KEY is required for Android Google Maps. Run Flutter with " +
            "--dart-define-from-file=env/local.json or pass --dart-define=GOOGLE_MAPS_API_KEY=..."
    )
}

if (releaseTaskRequested && !hasReleaseKeystore) {
    throw GradleException(
        "Release signing is not configured. Create android/key.properties with storeFile, storePassword, keyAlias, and keyPassword."
    )
}

android {
    namespace = "com.emmafve.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.emmafve.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseKeystore) {
                signingConfig = signingConfigs.getByName("release")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
