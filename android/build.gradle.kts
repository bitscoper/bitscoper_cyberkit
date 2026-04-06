// By Abdullah As-Sadeed

allprojects {
    repositories {
        google()
        mavenCentral {
            setUrl("https://repo1.maven.org/maven2")
        }
        maven {
            setUrl("https://repo1.maven.org/maven2")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory.asFile)
}
