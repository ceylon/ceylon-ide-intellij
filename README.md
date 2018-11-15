Ceylon IDE for IntelliJ [![Join the chat at https://gitter.im/ceylon/ceylon-ide-intellij](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ceylon/ceylon-ide-intellij) [![Build Status](https://ci-ceylon.rhcloud.com/buildStatus/icon?job=ceylon-ide-intellij)](https://ci-ceylon.rhcloud.com/job/ceylon-ide-intellij)
=======================

This project is an IntelliJ IDEA-based IDE for the [Ceylon programming language](http://ceylon-lang.org).

![Ceylon IDE](https://plugins.jetbrains.com/files/8625/screenshot_16167.png)

# Requirements

This plugin is developed against IntelliJ IDEA 2016.2, but is compatible with 2016.1-2017.2.
It works with both Community and Ultimate editions, and also supports Android Studio 2.x.

The plugin includes a full embedded distribution of Ceylon, so you don't necessarily have to download 
and install Ceylon separately.

# Installation

Release packages are made available in the JetBrains plugins repository. Installable archives of 
the current development version are generated and made available in an alternate plugin repository, 
on a regular basis (see below). 

You can install Ceylon IDE for IntelliJ from a repository, or build it from source.

## Common prerequisites

The following software must be installed:

- [IntelliJ IDEA 2016.1-2017.2](http://www.jetbrains.com/idea/download/) Community or Ultimate
- [JDK 7 or 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

## Install stable version from the JetBrains repository

_This is the simplest way to install **stable versions** of Ceyon IDE for IntelliJ._

Inside the IDE, go to `File > Settings (on Mac, Preferences) > Plugins > Browse repositories...` and type `Ceylon`, then install the plugin named `Ceylon IDE`.

## Install from the Development plugin repository

_This is the simplest way to install **development versions** of Ceyon IDE for IntelliJ._

Inside the Intellij IDEA environment, follow
[these instructions](https://www.jetbrains.com/idea/help/managing-enterprise-plugin-repositories.html)
to add one of the following custom repository URLs. From the repository, you will be able to install
a plugin named 'Ceylon IDE'. After installing the plugin and restarting IntelliJ IDEA, you will
have the ability to create Ceylon IntelliJ modules in which you can develop and run Ceylon code.

*Development builds* are published irregularly to this repository:

<http://downloads.ceylon-lang.org/ide/intellij/development/updatePlugins.xml>


*Nightly builds* are published here:

<https://ci-ceylon.rhcloud.com/job/ceylon-ide-intellij/ws/out/installation-packages/updatePlugins.xml>

## Build and install from sources

1. Clone [`ceylon`](http://github.com/ceylon/ceylon) and other required dependencies from Git:

        git clone https://github.com/ceylon/ceylon.git
        cd ceylon
        ant setup-sdk setup-ide

   This will clone sibling projects including `../ceylon-sdk`, `../ceylon-ide-common`, and
   `../ceylon-ide-intellij`.

2. Create a file `../ceylon-ide-intellij/user-build.properties` and add the following line
   so that it points to your IntelliJ installation:

        ideaRoot=/path/to/your/idea/install/

3. From the `ceylon` directory, build the Ceylon distribution, SDK, and Ceylon IDE:

        ant dist sdk intellij

4. Inside IntelliJ, go to 'Settings ... > Plugins' and click 'Install plugin from disk...',
   select `../ceylon-ide-intellij/out/installation-packages/CeylonIDEA.zip`.

5. Enjoy coding Ceylon in IntelliJ!

## Hack the IDE

If you want to debug or hack this plugin, you'll need to build it from sources.

1. Make sure you're using IntelliJ 2016.2.
   A clone of `https://github.com/JetBrains/intellij-community` is highly recommended for hacking
   since you will likely have to debug code from the IntelliJ platform

2. Go to 'Settings ... > Plugins', and ensure that the following plugins are installed and
   enabled in your IDEA instance:
    - Plugin DevKit,
    - UI Designer,
    - PsiViewer (optional but recommended)

3. Clone [`ceylon`](http://github.com/ceylon/ceylon) and other required dependencies from Git:

        git clone https://github.com/ceylon/ceylon.git
        cd ceylon
        ant setup-sdk setup-ide

   This will clone sibling projects including `../ceylon-sdk`, `../ceylon-ide-common`, and
   `../ceylon-ide-intellij`.

4. Edit `../ceylon-ide-intellij/user-build.properties` and change the following line
   so that it points to your IntelliJ installation:

        ideaRoot=/Applications/IntelliJ IDEA 2016.2 CE.app/Contents/

5. Build the Ceylon distribution, SDK, and Ceylon IDE. In the directory `../ceylon`, type:

        ant dist sdk intellij

   This will create a `dist` sub-directory in `../ceylon/dist`, with a full Ceylon distribution,
   along with everything needed to build Ceylon IDE, including the Ceylon SDK, formatter, Java to
   Ceylon converter, `ceylon-ide-common`, and Ceylon IDE itself. (See
   [these more detailed instructions](https://github.com/ceylon/ceylon-dist/blob/master/README.md#building-the-distribution)
   if necessary.)

6. Open the project `ceylon-ide-intellij` in IDEA. When the IDE shows a tooltip indicating "Frameworks detected: Ceylon 
   framework is detected in the project", **do not** click on Configure, the project is already correctly configured. 
   You might be requested to enter the value of two path variables. Go to 'Settings ... > Appearance & Behavior > Path Variables',
   and add a variable named `CEYLON_DIST` pointing to `../ceylon/dist/dist`.

7. In the IDE's 'Settings ... > Editor > File Types', under 'Recognized File Types', register
   `*.car` as an extension under the 'Archive' file type.

8. Go to 'File > Project Structure ... > SDKs':

    - Click on the `+` icon and add a new 'JDK' pointing to a *Java SDK 1.8*
    - Click on the `+` icon and add a new 'IntelliJ Platform Plugin SDK' pointing to the location
      of your IntelliJ installation (the correct folder should be preselected)

   Now, in the 'File > Project Structure ... > Project' section:

     - Set the 'Project SDK' to the previously created IntelliJ plugin SDK
     - Set the 'Project language level' to 7.0
     - Set the 'Project compiler output' to the `./out` directory

   Apply these changes and close the 'Project Structure' dialog.

9. In 'Run > Edit configurations', create a new run configuration with type 'Plugin' and leave the
    default options. Run this configuration to test the IDE.

# Getting started

To create and run your first project in Ceylon IDE for IntelliJ, you can follow the [getting started guide](https://ceylon-lang.org/documentation/current/ide/intellij/getting-started/).
