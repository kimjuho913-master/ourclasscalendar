// android/app/build.gradle.kts

// START: Add these lines at the top of the file
import java.util.Properties
import java.io.FileInputStream
// END: Add these lines

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// START: Add this section to read keystore properties
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// END: Add this section

android {
    namespace = "kimjuho913.class_calendar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13599879"

    // START: Add this signingConfigs block
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = if (keystoreProperties["storeFile"] != null) file(keystoreProperties["storeFile"] as String) else null
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    // END: Add this signingConfigs block

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "kimjuho913.class_calendar"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.

            // START: Change this line from "debug" to "release"
            signingConfig = signingConfigs.getByName("release")
            // END: Change this line
        }
    }
}

flutter {
    source = "../.."
}