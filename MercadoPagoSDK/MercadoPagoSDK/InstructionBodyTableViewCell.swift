//
//  InstructionBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionBodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    func fillCell(instruction: Instruction?){
        if let instruction = instruction{
            var height = 40
            var previus = UIView()
            for info in instruction.info {
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                                if info != ""{
                
                                label.textAlignment = .center
                                let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 18) ?? UIFont.systemFont(ofSize: 18),NSForegroundColorAttributeName: UIColor.lightGray]
                                let myAttrString = NSAttributedString(string: info, attributes: descriptionAttributes)
                                label.numberOfLines = 3
                                label.attributedText = myAttrString
                                label.translatesAutoresizingMaskIntoConstraints = false
                                label.sizeToFit()
                                self.view.addSubview(label)
                                    let views = ["label": label]
                                    
                                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                                    let heightConstraints:[NSLayoutConstraint]
                                    if info == instruction.info[0]{
                
                
                                heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[label]-(200)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                                    }
                                    else {
//                                        let views = ["label": label, "prev": previus as! UILabel]
//                                            heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[prev]-(100)-[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                                        heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 20)]
                                    }
                
                
                                //NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
                                NSLayoutConstraint.activate(widthConstraints)
                                NSLayoutConstraint.activate(heightConstraints)
                                    previus = label
                                }
                height += Int(label.frame.height) + 30
//                label.textAlignment = .center
//                var descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 18) ?? UIFont.systemFont(ofSize: 18),NSForegroundColorAttributeName: UIColor.lightGray]
//                var myAttrString = NSAttributedString(string: instruction.info[0], attributes: descriptionAttributes)
//                label.numberOfLines = 3
//                label.attributedText = myAttrString
//                label.translatesAutoresizingMaskIntoConstraints = false
//                label.sizeToFit()
//                self.view.addSubview(label)
//                var views = ["label": label]
//                var widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
//                var heightConstraints:[NSLayoutConstraint]
//                
//                
//                
//                heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
//                
//                
//                
//                //NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
//                NSLayoutConstraint.activate(widthConstraints)
//                NSLayoutConstraint.activate(heightConstraints)
//                previus = label
//                label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
//                label.textAlignment = .center
//                descriptionAttributes = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 18) ?? UIFont.systemFont(ofSize: 18),NSForegroundColorAttributeName: UIColor.lightGray]
//                myAttrString = NSAttributedString(string: instruction.info[3], attributes: descriptionAttributes)
//                label.numberOfLines = 3
//                label.attributedText = myAttrString
//                label.translatesAutoresizingMaskIntoConstraints = false
//                label.sizeToFit()
//                self.view.addSubview(label)
//                views = ["label": label, "prev":previus as! UILabel]
//                widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
//                
//                heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[prev]-(100)-[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
//                
//                
//                //NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
//                NSLayoutConstraint.activate(widthConstraints)
//                NSLayoutConstraint.activate(heightConstraints)
                
                
            }
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
