//
//  InstructionsTwoLabelsViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 17/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionsTwoLabelsViewCell: UITableViewCell, InstructionsFillmentDelegate {

    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var firstReferenceTitle: UILabel!
    @IBOutlet weak var firstReferenceValue: UILabel!
    @IBOutlet weak var secondReferenceTitle: UILabel!
    @IBOutlet weak var secondReferenceValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(instruction : Instruction) -> UITableViewCell {
        
        if instruction.info != nil && instruction.info.count > 0 {
            self.infoTitle.text = instruction.info[0]
        }
        
        if instruction.references != nil && instruction.references.count > 0 {
            self.firstReferenceTitle.text = instruction.references[0].label.uppercaseString
            self.firstReferenceValue.text = instruction.references[0].getFullReferenceValue()
            
            if instruction.references.count > 1 {
                self.secondReferenceTitle.text = instruction.references[1].label.uppercaseString
                self.secondReferenceValue.text = instruction.references[1].getFullReferenceValue()
            }
        }
        
        return self
    }
    
}
