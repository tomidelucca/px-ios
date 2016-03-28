//
//  InstructionsTwoLabelsAndButtonViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 18/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionsTwoLabelsAndButtonViewCell: UITableViewCell, InstructionsFillmentDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var infoTitle: MPLabel!
    @IBOutlet weak var referenceLabelFirst: MPLabel!
    @IBOutlet weak var referenceValueFirst: MPLabel!
    
    @IBOutlet weak var referenceLabelSecond: MPLabel!
    @IBOutlet weak var referenceValueSecond: MPLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.button.layer.borderWidth = 1.0
        self.button.layer.cornerRadius = 5
        self.button.layer.borderColor = UIColor().blueMercadoPago().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(instruction: Instruction) -> UITableViewCell {
        
        if instruction.info != nil && instruction.info.count > 0 {
            self.infoTitle.text = instruction.info[0]
        }
        
        if instruction.references != nil && instruction.references.count > 0 {
            self.referenceLabelFirst.text = instruction.references[0].label.uppercaseString
            self.referenceValueFirst.text = instruction.references[0].getFullReferenceValue()
            
            if (instruction.references.count > 1) {
                self.referenceLabelSecond.text = instruction.references[1].label.uppercaseString
                self.referenceValueSecond.text = instruction.references[1].getFullReferenceValue()
            }
        }
        
        return self
    }
    
}
