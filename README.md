![Screenshot iOS](https://i.imgur.com/7nDmBpl.jpg)
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

MercadoPagoSDKV4 (PX-Payment Experience) make it easy to collect your users' credit card details inside your iOS app. By creating tokens, MercadoPago handles the bulk of PCI compliance by preventing sensitive card data from hitting your server.

## 📲 How to Install

#### Using [CocoaPods](https://cocoapods.org)

Edit your `Podfile` and specify the dependency:

```ruby
pod 'MercadoPagoSDKV4', '~> 4.0'
```

## 🐒 How to use
Only **3** steps needed to create a basic checkout using `MercadopagoSDKV4`:

### 1 - Import in your project
```swift
import MercadoPagoSDKV4
```

### 2 - Set your  `PublicKey`  and  `PreferenceId` 
```swift
let checkout = MercadoPagoCheckout.init(builder: MercadoPagoCheckoutBuilder.init(publicKey: "your_public_key", preferenceId: "your_checkout_preference_id"))
```

### 3 - Start
```swift
checkout.start(navigationController: self.navigationController!)
```

## 💡Advanced integration?
Check our official code <a href="http://mercadopago.github.io/px-ios/v4/" target="_blank"> reference </a>, especially <a href="http://mercadopago.github.io/px-ios/v4/Classes/MercadoPagoCheckoutBuilder.html" target="_blank"> MercadoPagoCheckoutBuilder </a> object to explore all available functionalities.

## 💪One line integration?
Use MercadoPagoCheckoutBuilder to start your checkout flow in only one line.
```swift
MercadoPagoCheckout.init(builder: MercadoPagoCheckoutBuilder.init(publicKey: "your_public_key", preferenceId: "your_checkout_preference_id")).start(navigationController: self.navigationController!)
```
    
## 🌟 Features
- [x] Easy to install
- [x] Easy to use
- [x] Basic color customization
- [x] Advanced color customization
- [x] Lazy loading initialization support
- [x] Custom UIViews support in certain screens
- [x] Support to build your own Payment Processor
- [x] Support to create your own custom Payment Method

### 📋 Supported OS & SDK Versions
* iOS 9.0+
* Swift 4
* xCode 9.2+
* @Objc full compatibility

### 🔮 Project Example
This project include an example project using MercadoPagoSDKV4. In case you need support contact the MercadoPago Developers Site.

### 📚 Documentation & DevSite
+ [Advanced full documentation](http://mercadopago.github.io/px-ios/v4/)
+ [Check out MercadoPago Developers Site](http://www.mercadopago.com.ar/developers)

## ❤️ Feedback
You can join the MercadoPago Developers Community on MercadoPago Developers Site:
+ [English](https://www.mercadopago.com.ar/developers/en/community/forum/)
+ [Español](https://www.mercadopago.com.ar/developers/es/community/forum/)
+ [Português](https://www.mercadopago.com.br/developers/pt/community/forum/)

This is an open source project, so feel free to contribute. How?
- Fork this project and propose your own fixes, suggestions and open a pull request with the changes.


## 👨🏻‍💻 Author
Mercado Pago / Mercado Libre

## 👮🏻 License

```
MIT License

Copyright (c) 2018 - Mercado Pago / Mercado Libre

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
