<p align="center">
    <a href="https://travis-ci.org/mercadopago/px-ios">
      <img src="https://img.shields.io/travis/mercadopago/px-ios.svg">
    </a>
    <img src="https://img.shields.io/badge/Swift-4.1-orange.svg" />
    <a href="https://cocoapods.org/pods/MercadoPagoSDKV4">
        <img src="https://img.shields.io/cocoapods/v/px-ios.svg" alt="CocoaPods" />
    </a>
    <a href="https://cocoapods.org/pods/MercadoPagoSDKV4">
        <img src="https://img.shields.io/cocoapods/dt/MercadoPagoSDKV4.svg?style=flat" alt="CocoaPods downloads" />
    </a>
</p>

![Screenshot iOS](https://i.imgur.com/7nDmBpl.jpg)

MercadoPagoSDKV4 (PX-Payment Experience) make it easy to collect your users' credit card details inside your iOS app. By creating tokens, MercadoPago handles the bulk of PCI compliance by preventing sensitive card data from hitting your server.

## Installation

Add MercadoPagoSDKV4 to your project using CocoaPods.

### CocoaPods (iOS 9.0 or later)

#### Step 1: Download CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries like MercadoPagoSDKV4 in your projects.

CocoaPods is distributed as a ruby gem, and is installed by running the following commands in Terminal:

    $ sudo gem install cocoapods
    $ pod setup

> Depending on your Ruby installation, you may not have to run as `sudo` to install the cocoapods gem.

> :warning: MercadoPagoSDKV4 requires cocoapods 1.4 or higher. With pod --version you can verify the current version you have installed. This framework was built with Swift 4.0 so you will need Xcode 9 or higer in order to use it.

#### Step 2: Create a Podfile

Project dependencies to be managed by CocoaPods are specified in a file called `Podfile`. Create this file in the same directory as your Xcode project (`.xcodeproj`) file:

    $ touch Podfile
    $ open -a Xcode Podfile

You just created the pod file and opened it using Xcode! Ready to add some content to the empty pod file?

Copy and paste the following lines:  

    source 'https://github.com/CocoaPods/Specs.git'
    use_frameworks!
    platform :ios, '9.0'
    pod 'MercadoPagoSDKV4', '4.0'

#### Step 3: Install Dependencies

Now you can install the dependencies in your project:

    $ pod install

From now on, be sure to always open the generated Xcode workspace (`.xcworkspace`) instead of the project file when building your project:

    $ open <YourProjectName>.xcworkspace

## Project Example
This project include an example project using MercadoPagoSDKV4. In case you need support contact the development team.

## Documentation
+ [Advanced full documentation.](http://mercadopago.github.io/px-ios/v4/)
+ [Check out MercadoPago Developers Site.](http://www.mercadopago.com.ar/developers)

## Feedback
You can join the MercadoPago Developers Community on MercadoPago Developers Site:
+ [English](https://www.mercadopago.com.ar/developers/en/community/forum/)
+ [Español](https://www.mercadopago.com.ar/developers/es/community/forum/)
+ [Português](https://www.mercadopago.com.br/developers/pt/community/forum/)
