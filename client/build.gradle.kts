buildscript {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.4.10")
        classpath("com.android.tools.build:gradle:3.4.3")
    }
}
group = "org.openstreetmap.maptogether"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}
