//
//  TextMaskFormater.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 8/16/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class TextMaskFormater: NSObject {

    var mask : String!
    var characterSpace : String = "X"
    var emptyMaskElement : String = "•"

    public func textMasked(text: String) -> String{
        
        if (text.characters.count == 0){
            return self.emptyTextMasked()
        }
        return ""
    }
    
    
    public func emptyTextMasked() -> String{
        return (mask?.stringByReplacingOccurrencesOfString(characterSpace, withString: emptyMaskElement))!
    }
    
    
    public func replace(text:String){
        let maskArray = Array(mask.characters)
        let textArray = Array(text.characters)
        
        
        
    }
    
    
    private func stringByChoose(maskCharacter: String.CharacterView, textCharacter: String.CharacterView?) -> String{
        if (textCharacter == nil){
            return String(maskCharacter)
        }
        
        return ""
    }
    
}
