//
//  DecorationPreference.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class DecorationPreference : NSObject{
    var baseColor: UIColor = UIColor.px_blueMercadoPago()
    var textColor: UIColor = UIColor.black
    var fontName: String?
    
    public func setBaseColor(color: UIColor){
        baseColor = color
    }
    public func enableDarkFont(){
        textColor = UIColor.black
    }
    public func enableLightFont(){
        textColor = UIColor.white
    }
    public func setFontName(fontName: String){
        
    }
    public func getBaseColor() -> UIColor {
        return baseColor
    }
    public func getTextColor() -> UIColor {
        return textColor
    }
}
