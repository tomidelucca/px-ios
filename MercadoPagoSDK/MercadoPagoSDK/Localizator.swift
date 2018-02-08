//
//  Localizator.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 2/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

private class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        let languageBundle = Bundle(path : MercadoPagoContext.getLocalizedPath())
        let languageID = MercadoPagoContext.getParentLanguageID()
        
        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    lazy var parentLocalizableDictionary: NSDictionary! = {
        let languageBundle = Bundle(path : MercadoPagoContext.getParentLocalizedPath())
        let languageID = MercadoPagoContext.getParentLanguageID()
        
        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(string: String) -> String {
        guard let localizedStringDictionary = localizableDictionary.value(forKey: string) as? NSDictionary, let localizedString = localizedStringDictionary.value(forKey: "value") as? String else {
            
            var parentLocalizableDictionary = localizableDictionary.value(forKey: string) as? NSDictionary
//            if let parentLocalizedStringDictionary = 
            
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
