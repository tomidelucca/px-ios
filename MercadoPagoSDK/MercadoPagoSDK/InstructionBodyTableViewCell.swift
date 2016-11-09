//
//  InstructionBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionBodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillCell(instruction: Instruction?){
        if let instruction = instruction{
            var height = 40
            var previus = UIView()
            var constrain = 0
            for (index, info) in instruction.info.enumerated() {
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                    
                    label.textAlignment = .center
                    let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 18) ?? UIFont.systemFont(ofSize: 18),NSForegroundColorAttributeName: UIColor.gray]
                    let myAttrString = NSAttributedString(string: info, attributes: descriptionAttributes)
                    label.numberOfLines = 3
                    label.attributedText = myAttrString
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.sizeToFit()
                    
                    let views = ["label": label]
                    self.view.addSubview(label)
                    
                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    let heightConstraints:[NSLayoutConstraint]
                    //let heightConstraints2:[NSLayoutConstraint]
                    if index == 0{
                        
                        
                        heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                        //heightConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    }
                

                    else {
                        
                        if index+1 != instruction.info.count && instruction.info[index-1] != ""{
                            heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)]
                            constrain = 0
                        } else if index == 6 {
                            heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 60)]
                                ViewUtils.drawBottomLine(y: CGFloat(height), width: UIScreen.main.bounds.width, inView: self.view)
                            constrain = 60
                        } else {
                            heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                            constrain = 30
                            
                        }
                        
                    }
                    previus = label
                    NSLayoutConstraint.activate(widthConstraints)
                    NSLayoutConstraint.activate(heightConstraints)
                    //NSLayoutConstraint.activate(heightConstraints2)
                    
                
                height += Int(label.frame.height) + constrain
                
            }
            for refence in instruction.references {
                if let labelText = refence.label{
                    var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                    label.textAlignment = .center
                    let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.gray]
                    let myAttrString = NSAttributedString(string: String(describing: labelText), attributes: descriptionAttributes)
                    label.numberOfLines = 3
                    label.attributedText = myAttrString
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.sizeToFit()
                    
                    let views = ["label": label]
                    self.view.addSubview(label)
                    
                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    let heightConstraints:[NSLayoutConstraint]
                    //let heightConstraints2:[NSLayoutConstraint]
                    
                    heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                    
                    
                    previus = label
                    NSLayoutConstraint.activate(widthConstraints)
                    NSLayoutConstraint.activate(heightConstraints)
                    height += Int(label.frame.height) + 30
                }
                
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                label.textAlignment = .center
                let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 20) ?? UIFont.systemFont(ofSize: 20),NSForegroundColorAttributeName: UIColor.black]
                let myAttrString = NSAttributedString(string: String(describing: refence.getFullReferenceValue()), attributes: descriptionAttributes)
                label.numberOfLines = 3
                label.attributedText = myAttrString
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let views = ["label": label]
                self.view.addSubview(label)
                
                let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                let heightConstraints:[NSLayoutConstraint]
                //let heightConstraints2:[NSLayoutConstraint]
                
                heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 1)]
                
                
                previus = label
                NSLayoutConstraint.activate(widthConstraints)
                NSLayoutConstraint.activate(heightConstraints)
                
                height += Int(label.frame.height) + 1
                
            }
            if instruction.accreditationMessage != "" {
                
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                label.textAlignment = .center
                let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.gray]
                let myAttrString = NSAttributedString(string: String(describing: instruction.accreditationMessage), attributes: descriptionAttributes)
                label.numberOfLines = 3
                label.attributedText = myAttrString
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let image = UIImageView(frame: CGRect(x: 0, y: height, width: 16, height: 16))
                image.image = MercadoPago.getImage("iconTime")
                image.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(image)
                
                let views = ["label": label, "image": image] as [String : Any]
                self.view.addSubview(label)
                
                
                let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-70-[image]-[label]-70-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                //let widthConstraints2 = [NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 30)]
                let heightConstraints:[NSLayoutConstraint]

                
                heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                NSLayoutConstraint.activate(widthConstraints)
                NSLayoutConstraint.activate(heightConstraints)
                
                
                let verticalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                //let widthConstraints2 = [NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)]
                view.addConstraint(verticalConstraint)
                //NSLayoutConstraint.activate(widthConstraints2)

                previus = label
            }

            let views = ["label": previus]
                let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            NSLayoutConstraint.activate(heightConstraints)
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
