//
//  FooterComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class FooterComponent: NSObject {
  var data : FooterData
    init(data: FooterData) {
        self.data = data
    }

}
class FooterData: NSObject {
    var principalButtonLabel: String
    var principalButtonAction : (() -> Void)?
    var secundaryButtonLabel: String
    var secundaryButtonAction : (() -> Void)?
    init(principalButtonLabel: String, principalButtonAction : (() -> Void)?, secundaryButtonLabel: String, secundaryButtonAction : (() -> Void)?) {
        self.principalButtonLabel = principalButtonLabel
        self.principalButtonAction = principalButtonAction
        self.secundaryButtonLabel = secundaryButtonLabel
        self.secundaryButtonAction = secundaryButtonAction
    }
}
