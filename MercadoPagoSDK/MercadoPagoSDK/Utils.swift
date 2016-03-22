//
//  Utils.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 21/4/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    class func getDateFromString(string: String!) -> NSDate! {
        if string == nil {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateArr = string.characters.split {$0 == "T"}.map(String.init)
        return dateFormatter.dateFromString(dateArr[0])
    }
    
    class func getAttributedAmount(formattedString : String) -> NSAttributedString {
        let range = formattedString.rangeOfString(".")
        let centsIndex = range!.startIndex.advancedBy(1)
        var cents = formattedString.substringFromIndex(centsIndex)
        if cents.isEmpty || cents.characters.count < 2 {
            var missingZeros = 2 - cents.characters.count
            while missingZeros > 0 {
                cents.appendContentsOf("0")
                missingZeros = missingZeros - 1
            }
        }
        var amount = formattedString.substringToIndex(range!.startIndex)
        amount = "$" + amount
        
        
        let normalAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 18)!,NSForegroundColorAttributeName: UIColor.whiteColor()]
        let smallAttributes : [String:AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 8)!,NSForegroundColorAttributeName: UIColor.whiteColor()]

        let attributedAmount = NSMutableAttributedString(string: amount, attributes: normalAttributes)
        let attributedCents = NSAttributedString(string: cents, attributes: smallAttributes)
        attributedAmount.appendAttributedString(attributedCents)
        return attributedAmount
    }
}