//
//  InstructionsViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionsViewCell: UITableViewCell, InstructionsFillmentDelegate {

    @IBOutlet weak var infoTitle: UILabel!
    
    @IBOutlet weak var firstReferenceLabel: UILabel!
    
    @IBOutlet weak var firstReferenceValue: UILabel!
    
    @IBOutlet weak var secondReferenceLabel: UILabel!
    
    @IBOutlet weak var secondReferenceValue: UILabel!
    
    
    @IBOutlet weak var thirdReferenceLabel: UILabel!
    
    @IBOutlet weak var thirdReferenceValue: UILabel!
    
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
            self.firstReferenceLabel.text = instruction.references[0].label.uppercaseString
            self.firstReferenceValue.text = instruction.references[0].getFullReferenceValue()
            
            if instruction.references.count > 1 {
                self.secondReferenceLabel.text = instruction.references[1].label.uppercaseString
                self.secondReferenceValue.text = instruction.references[1].getFullReferenceValue()
                
                if instruction.references.count > 2 {
                    self.thirdReferenceLabel.text = instruction.references[2].label.uppercaseString
                    self.thirdReferenceValue.text = instruction.references[2].getFullReferenceValue()
                }
            }
            
        }
        return self
    }
}
