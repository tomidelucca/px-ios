//
//  Localizator.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 2/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal class Localizator {
    static let sharedInstance = Localizator()
    private var language: String = NSLocale.preferredLanguages[0]

    private lazy var localizableDictionary: NSDictionary! = {
        let languageBundle = Bundle(path: getLocalizedPath())
        let languageID = getParentLanguageID()

        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()

    private lazy var parentLocalizableDictionary: NSDictionary! = {
        let languageBundle = Bundle(path: getParentLocalizedPath())
        let languageID = getParentLanguageID()

        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()

}

// MARK: Getters/ Setters
extension Localizator {
    func setLanguage(language: Languages) {
        self.language = language.rawValue
    }

    func setLanguage(string: String) {
        let enumLanguage = Languages(rawValue: string)
        guard let languange = enumLanguage else {
            self.language = Languages.SPANISH.rawValue
            return
        }
        self.language = languange.rawValue
    }

    func getLanguage() -> String {
        return language
    }

}

// MARK: Localization Paths
extension Localizator {
    private func getLocalizedID() -> String {
        let bundle = ResourceManager.shared.getBundle() ?? Bundle.main

        let currentLanguage = getLanguage()
        let currentLanguageSeparated = currentLanguage.components(separatedBy: "-")[0]
        if bundle.path(forResource: currentLanguage, ofType: "lproj") != nil {
            return currentLanguage
        } else if (bundle.path(forResource: currentLanguageSeparated, ofType: "lproj") != nil) {
            return currentLanguageSeparated
        } else {
            return "es"
        }
    }

    private func getParentLanguageID() -> String {
        return getLanguage().components(separatedBy: "-")[0]
    }

    func getLocalizedPath() -> String {
        let bundle = ResourceManager.shared.getBundle() ?? Bundle.main
        let pathID = getLocalizedID()
        return bundle.path(forResource: pathID, ofType: "lproj")!
    }

    private func getParentLocalizedPath() -> String {
        let bundle = ResourceManager.shared.getBundle() ?? Bundle.main
        let pathID = getParentLanguageID()
        return bundle.path(forResource: pathID, ofType: "lproj")!
    }

    func localize(string: String) -> String {
        guard let localizedStringDictionary = localizableDictionary.value(forKey: string) as? NSDictionary, let localizedString = localizedStringDictionary.value(forKey: "value") as? String else {

            let parentLocalizableDictionary = self.parentLocalizableDictionary.value(forKey: string) as? NSDictionary
            if let parentLocalizedString = parentLocalizableDictionary?.value(forKey: "value") as? String {
                return parentLocalizedString
            }

            #if DEBUG
            assertionFailure("Missing translation for: \(string)")
            #endif

            return string
        }

        return localizedString
    }
}

/** :nodoc: */
extension String {
    var localized_beta: String {
        return Localizator.sharedInstance.localize(string: self)
    }

    var localized: String {
        var bundle: Bundle? = ResourceManager.shared.getBundle()
        if bundle == nil {
            bundle = Bundle.main
        }
        let languageBundle = Bundle(path: Localizator.sharedInstance.getLocalizedPath())
        return languageBundle!.localizedString(forKey: self, value: "", table: nil)
    }
}
