//
//  AppUtils.swift
//  MercadoPagoSDKExamples
//
//  Created by Demian Tejo on 7/19/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

class AppUtils : ExamplesUtils{
    static var preferenceSelectedID : String = ExamplesUtils.PREF_ID_NO_EXCLUSIONS
    
    internal class func setPreferenceID(idPref : String){
        AppUtils.preferenceSelectedID = idPref
    }
}