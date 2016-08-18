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
    var leftToRight : Bool = true
    var unmask : (( textToUnmask: String) -> String)?
    
    
    
    public init(mask: String!, completeEmptySpaces : Bool = true, leftToRight : Bool = true) {
        super.init()
        self.mask = mask
        self.completeEmptySpaces = completeEmptySpaces
        self.leftToRight = leftToRight
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
    

    public func textUnmasked(text: String!) -> String!{
        
        if (unmask != nil){
            return unmask!(textToUnmask:text)
        }else{
            let charset : Set<Character> = ["0","1","2","3","4","5","6","7","8","9"]
            var ints: String = ""
            for char:Character in text.characters {
                if charset.contains(char){
                    ints.append(char)
                }
            }
            return ints
        }
        
        
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
        var textToMask = text
        if ((!leftToRight)&&(completeEmptySpaces)){
            textToMask = completeWithEmptySpaces(text)
        }
        let textArray = Array(textToMask.characters)
        var resultString : String = ""
        var charText : Character! = textArray[0]
        var charMask : Character!
        if(!self.completeEmptySpaces && (textToMask.characters.count == 0)){
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
              //  if (leftToRight){
                    resultString.appendContentsOf(String(charMask))
               // }
                
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
    
    private func completeWithEmptySpaces(text: String)->String{
        let charset : Set<Character> = ["X"]
        var xs: String = ""
        for char:Character in mask.characters {
            if charset.contains(char){
                xs.append(char)
            }
        }
        let max = xs.characters.count - text.characters.count
        let x: Character = "X"
        return (String(count:max, repeatedValue:x) + text)
        
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


