//
//  PaymentSearchCollectionViewCell.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 10/25/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageSearch: UIImageView!
    @IBOutlet weak var titleSearch: UILabel!
    @IBOutlet weak var subtitleSearch: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func fillCell(image: UIImage, title: String, subtitle: String = ""){
        self.imageSearch.image = image
        self.titleSearch.text = title
        self.subtitleSearch.text = subtitle
    }
}
