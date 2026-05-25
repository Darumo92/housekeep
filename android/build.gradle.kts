allprojects {
    repositories {
        google()
        mavenCentral()
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
    afterEvaluate {
        if (extensions.findByName("android") != null) {
            val androidExt = extensions.getByName("android")
            try {
                val setter = androidExt.javaClass.getMethod(
                    "setCompileSdkVersion",
                    Int::class.javaPrimitiveType,
                )
                setter.invoke(androidExt, 36)
            } catch (_: Throwable) {
                try {
                    val setter = androidExt.javaClass.getMethod(
                        "setCompileSdk",
                        Int::class.javaPrimitiveType,
                    )
                    setter.invoke(androidExt, 36)
                } catch (_: Throwable) {
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
