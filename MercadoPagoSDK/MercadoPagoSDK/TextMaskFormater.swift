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
    public var characterSpace : String! = "X"
    public var emptyMaskElement : String! = "•"

    var completeEmptySpaces : Bool = true
    
    public init(mask: String!, completeEmptySpaces : Bool = true) {
        super.init()
        self.mask = mask
        self.completeEmptySpaces = completeEmptySpaces
    }
    public func textMasked(text: String!, remasked: Bool = false) -> String!{
        
        if (remasked){
            return textMasked(textUnmasked(text))
        }
        if (text.characters.count == 0){
            return self.emptyTextMasked()
        }
        return self.maskText(text)
    }
    
    //TODO
    public func textUnmasked(text: String!) -> String!{
        return text.trimSpaces()
    }
    
    
    
    private func emptyTextMasked() -> String!{
        if(completeEmptySpaces){
            return (mask?.stringByReplacingOccurrencesOfString(characterSpace, withString: emptyMaskElement))!
        }else{
            return ""
        }
        
    }
    
    private func replaceEmpySpot(text : String!)-> String!{
        return (text.stringByReplacingOccurrencesOfString(characterSpace, withString: emptyMaskElement))
    }
    
    private func maskText(text:String!) -> String!{
        let maskArray = Array(mask.characters)
        let textArray = Array(text.characters)
        var resultString : String = ""
        var charText : Character! = textArray[0]
        var charMask : Character!
        if(!self.completeEmptySpaces && (text.characters.count == 0)){
            return ""
        }
        
        var indexMask = 0
        var indexText = 0
        while ((indexMask < maskArray.count) && (self.completeEmptySpaces || (textArray.count>indexText))){
        
             charMask = maskArray[indexMask]
            
            if (textArray.count>indexText){
                charText = textArray[indexText]
            }else{
                charText = nil
            }
            
            if (charText == nil){
                resultString.appendContentsOf(String(charMask))
                indexMask += 1
            }else if( String(charMask) != characterSpace ){
                resultString.appendContentsOf(String(charMask))
                indexMask += 1
            }else{
                 resultString.appendContentsOf(String(charText))
                indexMask += 1
                indexText += 1
            }
           
            
            
        }
        return self.replaceEmpySpot(resultString)
        
    }
    
    
    private func stringByChoose(maskCharacter: Character, textCharacter: Character!) -> String{
        if (textCharacter == nil){
            return String(maskCharacter)
        }
        if(String(maskCharacter) != characterSpace ){
            return String(maskCharacter) + String(textCharacter)
        }
        return String(textCharacter)
    }
    
}
