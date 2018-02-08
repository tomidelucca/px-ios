//
//  String+Additions.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

extension String {

    static let NON_BREAKING_LINE_SPACE = "\u{00a0}"

	var localized: String {
		var bundle: Bundle? = MercadoPago.getBundle()
		if bundle == nil {
			bundle = Bundle.main
		}
        let languageBundle = Bundle(path : MercadoPagoContext.getLocalizedPath())
        return languageBundle!.localizedString(forKey: self, value : "", table : nil)

	}

    public func existsLocalized() -> Bool {
        let localizedString = self.localized
        return localizedString != self
    }

    static public func isDigitsOnly(_ a: String) -> Bool {
		if Regex.init("^[0-9]*$").test(a) {
			return true
		} else {
			return false
		}
    }

    public func startsWith(_ prefix: String) -> Bool {
        if prefix == self {
            return true
        }
        let startIndex = self.range(of: prefix)
        if startIndex == nil  || self.startIndex != startIndex?.lowerBound {
            return false
        }
        return true
    }

    subscript (i: Int) -> String {

        if self.count > i {
            return String(self[self.index(self.startIndex, offsetBy: i)])
        }

        return ""
    }

    public func lastCharacters(number: Int) -> String {
        let trimmedString: String = (self as NSString).substring(from: max(self.count - number, 0))
        return trimmedString
    }

    public func indexAt(_ theInt: Int) ->String.Index {
        return self.index(self.startIndex, offsetBy: theInt)
    }

    public func trimSpaces() -> String {

        var stringTrimmed = self.replacingOccurrences(of: " ", with: "")
        stringTrimmed = stringTrimmed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return stringTrimmed
    }

    mutating func paramsAppend(key: String, value: String?) {
        if !key.isEmpty && !String.isNullOrEmpty(value) {
            if self.isEmpty {
                self = key + "=" + value!
            } else {
                self = self + "&" + key + "=" + value!
            }
        }
    }

    public func toAttributedString(attributes: [String: Any]? = nil) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
}


private class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        var bundle: Bundle? = MercadoPago.getBundle()
        if bundle == nil {
            bundle = Bundle.main
        }
        let languageBundle = Bundle(path : MercadoPagoContext.getLocalizedPath())
        let languageID = MercadoPagoContext.getLocalizedID()
        
        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(string: String) -> String {
        guard let localizedStringDictionary = localizableDictionary.value(forKey: string) as? NSDictionary, let localizedString = localizedStringDictionary.value(forKey: "value") as? String else {
            assertionFailure("Missing translation for: \(string)")
            return ""
        }

        return localizedString
    }
}

extension String {
    var localized_beta: String {
        return Localizator.sharedInstance.localize(string: self)
    }
}

