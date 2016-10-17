//
//  IssuerRowTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/17/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class IssuerRowTableViewCell: UITableViewCell {

    @IBOutlet weak var issuerImage: UIImageView!
    func fillCell(issuer: Issuer, bundle: Bundle){
        issuerImage.image = UIImage(named: "ico_bank_\(issuer._id!)", in: bundle, compatibleWith: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
