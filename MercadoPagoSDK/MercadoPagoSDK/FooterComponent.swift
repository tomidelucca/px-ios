//
//  FooterComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class FooterComponent: NSObject {
    var titleLabel : String
    var titleButton : String
   var actionButton : (()->Void)?
    init(data : FooterData) {
        self.titleLabel = data.titleLabel
        self.titleButton = data.titleButton
        self.actionButton = data.actionButton
    }
    
}
class FooterData: NSObject {
    var titleLabel : String
    var titleButton : String
    var actionButton : (()->Void)?
    init(titleLabel : String, titleButton : String, actionCallback:(()->Void)? = nil) {
        self.titleLabel = titleLabel
        self.titleButton = titleButton
        self.actionButton = actionCallback
    }
}


