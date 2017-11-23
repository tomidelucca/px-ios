//
//  BodyComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class BodyComponent: NSObject {
    var text: String
    init(data: BodyData) {
        self.text = data.text
    }

}
class BodyData: NSObject {
    var text: String
    init(text: String) {
        self.text = text
    }
}
