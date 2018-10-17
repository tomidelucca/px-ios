//
//  PXMockedCards.swift
//
//  Created by Juan sebastian Sanzone on 12/10/18.
//

import UIKit

// American Express
@objc class AmericanExpress: NSObject, CardUI {
    var placeholderName = ""
    var placeholderExpiration = ""
    var bankImage: UIImage?
    var cardPattern = [1, 3, 4, 4]
    var cardFontColor: UIColor = .white
    var cardLogoImage: UIImage? = ResourceManager.shared.getImage("amex")
    var cardBackgroundColor: UIColor = UIColor(red: 170/255, green: 195/255, blue: 177/255, alpha: 1)
    var securityCodeLocation: Location = .back
    var defaultUI = true
    var securityCodePattern = 3
    var fontType: String = "light"
}

// Visa
@objc class Visa: NSObject, CardUI {
    var placeholderName = ""
    var placeholderExpiration = ""
    var bankImage: UIImage?
    var cardPattern = [4, 4, 4, 4]
    var cardFontColor: UIColor = .white
    var cardLogoImage: UIImage? = ResourceManager.shared.getImage("visa_light")
    var cardBackgroundColor: UIColor = UIColor(red: 75/255, green: 100/255, blue: 193/255, alpha: 1)
    var securityCodeLocation: Location = .back
    var defaultUI = true
    var securityCodePattern = 3
    var fontType: String = "light"
}

// Maestro
@objc class Maestro: NSObject, CardUI {
    var placeholderName = ""
    var placeholderExpiration = ""
    var bankImage: UIImage?
    var cardPattern = [4, 4, 4, 4]
    var cardFontColor: UIColor = .white
    var cardLogoImage: UIImage? = ResourceManager.shared.getImage("debmaestro_light")
    var cardBackgroundColor: UIColor = UIColor(red: 98/255, green: 132/255, blue: 153/255, alpha: 1)
    var securityCodeLocation: Location = .back
    var defaultUI = true
    var securityCodePattern = 3
    var fontType: String = "light"
}

// Galicia Amex
@objc class GaliciaAmex: NSObject, CardUI {
    var placeholderName = ""
    var placeholderExpiration = ""
    var bankImage: UIImage? = ResourceManager.shared.getImage("galicia_light")
    var cardPattern = [4, 4, 4, 4]
    var cardFontColor: UIColor = .white
    var cardLogoImage: UIImage? = ResourceManager.shared.getImage("amex")
    var cardBackgroundColor: UIColor = UIColor(red: 238/255, green: 140/255, blue: 58/255, alpha: 1)
    var securityCodeLocation: Location = .back
    var defaultUI = true
    var securityCodePattern = 3
    var fontType: String = "light"
}
