//name := "RPS"

//ThisBuild / version := "0.1.0"
ThisBuild / version          := "2.5.0"

//scalaVersion := "2.12.13"
ThisBuild / scalaVersion     := "2.13.7"

val chiselVersion = "3.5.2"


lazy val root = (project in file("."))
  .settings(
    name := "RPS",
    libraryDependencies ++= Seq(
//      "edu.berkeley.cs" %% "chisel3" % "3.4.3",
//      "edu.berkeley.cs" %% "chiseltest" % "0.3.3" % "test",
      "edu.berkeley.cs" %% "chisel-iotesters" % "2.5.2",
      "edu.berkeley.cs" %% "chisel3" % chiselVersion,
      "edu.berkeley.cs" %% "chiseltest" % "0.5.2" //% "test"
    ),
    scalacOptions ++= Seq(
      "-Xsource:2.13",
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      // Enables autoclonetype2 in 3.4.x (on by default in 3.5)
      //"-P:chiselplugin:useBundlePlugin"
    ),
//    addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.4.3" cross CrossVersion.full),
//    addCompilerPlugin("org.scalamacros" % "paradise" % "2.1.1" cross CrossVersion.full),
    addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % chiselVersion cross CrossVersion.full),
  )