//
//  PXAddCardCongratsBodyComponent.swift
//  MercadoPagoSDKV4
//
//  Created by Diego Flores Domenech on 24/9/18.
//

import UIKit

class PXAddCardCongratsBodyComponent: PXComponentizable {
    
    func render() -> UIView {
        return PXAddCardCongratsBodyView()
    }
}

class PXAddCardCongratsBodyView: UIView {
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.shared.labelTintColor()
        label.font = UIFont(name: ThemeManager.shared.getFontName(), size: 16)
        label.text = "Podés usarla cuando quieras."
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.addSubview(self.textLabel)
        PXLayout.centerVertically(view: self.textLabel).isActive = true
        PXLayout.centerHorizontally(view: self.textLabel).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
