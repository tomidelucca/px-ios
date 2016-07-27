//
//  String+Additions.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

extension String {
	
	var localized: String {
		var bundle : NSBundle? = MercadoPago.getBundle()
		if bundle == nil {
			bundle = NSBundle.mainBundle()
		}
		return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
	}
	
    public func existsLocalized() -> Bool {
        let localizedString = self.localized
        return localizedString != self
    }
    
    static public func isNullOrEmpty(value: String?) -> Bool
    {
        return value == nil || value!.isEmpty
    }
    
    static public func isDigitsOnly(a: String) -> Bool {
		if Regex.init("^[0-9]*$").test(a) {
			return true
		} else {
			return false
		}
    }
    
    public func startsWith(prefix : String) -> Bool {
        let startIndex = self.rangeOfString(prefix)
        if startIndex == nil  || self.startIndex != startIndex?.startIndex {
            return false
        }
        return true
    }
    
    subscript (i: Int) -> String {
        
        if self.characters.count > i {
            return String(self[self.startIndex.advancedBy(i)])
        }
        
        return ""
    }
    
    public func indexAt(theInt:Int)->String.Index {
        
        return self.characters.startIndex.advancedBy(theInt)
    }
    
    public func trimSpaces()-> String {
        
        var stringTrimmed = self.stringByReplacingOccurrencesOfString(" ", withString: "")
        stringTrimmed = stringTrimmed.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return stringTrimmed
    }
}