plugins {
    id("com.android.application")
    kotlin("android")
}

val storageUrl = System.getenv("FLUTTER_STORAGE_BASE_URL") ?: "https://storage.googleapis.com"
repositories {
	maven(url = "$projectDir/../ui/build/host/outputs/repo")
	maven(url = "$storageUrl/download.flutter.io")
}

dependencies {
    implementation(project(":shared"))
    implementation("com.google.android.material:material:1.2.1")
    implementation("androidx.appcompat:appcompat:1.2.0")
    implementation("androidx.constraintlayout:constraintlayout:2.0.2")

	debugImplementation("maptogether.client.ui:flutter_debug:1.0")
	// profileImplementation("maptogether.client.ui:flutter_profile:1.0")
	releaseImplementation("maptogether.client.ui:flutter_release:1.0")
}

android {
    compileSdkVersion(29)
    defaultConfig {
        applicationId = "maptogether.client.android"
        minSdkVersion(24)
        targetSdkVersion(29)
        versionCode = 1
        versionName = "1.0"
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
		//profile {
		// getByName("profile") {
        //   initWith("debug")
        // }
    }
	compileOptions {
		sourceCompatibility = JavaVersion.VERSION_1_8
		targetCompatibility = JavaVersion.VERSION_1_8
	}
}
