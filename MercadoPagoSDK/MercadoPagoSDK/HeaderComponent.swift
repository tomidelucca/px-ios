//
//  HeaderComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class HeaderComponent: NSObject {
    var title : String
    var subTitle : String
    init(data : HeaderData) {
        self.title = data.title
        self.subTitle = data.subTitle
    }
}
class HeaderData : NSObject {
    var title : String
    var subTitle : String
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
}


