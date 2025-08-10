plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.job_finder_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    
    // <<< THÊM MỚI BẮT ĐẦU >>>
    // Khối này chỉ định rõ ràng file keystore dùng cho việc ký ứng dụng,
    // giúp đảm bảo mã SHA-1 luôn nhất quán.
    signingConfigs {
        getByName("debug") {
            storeFile = file("../../keystore/debug.keystore") // Đường dẫn tương đối đến file keystore
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }
    // <<< THÊM MỚI KẾT THÚC >>>

    defaultConfig {
        applicationId = "com.example.job_finder_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}