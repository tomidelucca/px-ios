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
    }

    func fillCell(instruction: Instruction?, payment: Payment){
        if let instruction = instruction{
            var previus = UIView()
            var height = 0
            
            for (index, info) in instruction.info.enumerated() {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
                label.textAlignment = .center
                var fontSize = 18
                
                if index>1 && index<5 && payment.paymentMethodId == "redlink"{
                    fontSize = 16
                }
                let labelText = NSAttributedString(string: info, attributes: getAttributes(fontSize: fontSize, color: UIColor.gray))
                label.numberOfLines = 0
                label.attributedText = labelText
                label.sizeToFit()
                height += Int(label.frame.height)
                label.translatesAutoresizingMaskIntoConstraints = false
                
                let views = ["label": label]
                self.view.addSubview(label)
                setContrainsHorizontal(views: views)
                
                let heightConstraints:[NSLayoutConstraint]
                
                if index == 0{
                    heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    height += 30
                    NSLayoutConstraint.activate(heightConstraints)
                    
                } else if index+1 != instruction.info.count && instruction.info[index-1] != "" && payment.paymentMethodId == "redlink"{
                    
                    setContrainsVertical(label: label, previus: previus, constrain: 0)
                } else if index == 6 && payment.paymentMethodId == "redlink"{
                    setContrainsVertical(label: label, previus: previus, constrain: 60)
                    
                    height += 60
                } else {
                    setContrainsVertical(label: label, previus: previus, constrain: 30)
                    height += 30
                }
                previus = label
                
                if index == 4 && payment.paymentMethodId == "redlink"{
                    ViewUtils.drawBottomLine(y: CGFloat(height), width: UIScreen.main.bounds.width, inView: self.view)
                }
                
            }
            for reference in instruction.references {
                if let labelText = reference.label{
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
                    label.textAlignment = .center
                    let myAttrString = NSAttributedString(string: String(describing: labelText), attributes: getAttributes(fontSize: 12, color: UIColor.gray))
                    label.numberOfLines = 0
                    label.attributedText = myAttrString
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.sizeToFit()
                    
                    let views = ["label": label]
                    self.view.addSubview(label)
                    
                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[label]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    let heightConstraints:[NSLayoutConstraint]
                    
                    if  previus != nil {
                        setContrainsVertical(label: label, previus: previus, constrain: 30)
                    } else {
                        heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                        NSLayoutConstraint.activate(heightConstraints)
                    }
                    
                    previus = label
                    NSLayoutConstraint.activate(widthConstraints)
                    
                }
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
                label.textAlignment = .center
                let labelTitle = NSAttributedString(string: String(describing: reference.getFullReferenceValue()), attributes: getAttributes(fontSize: 20, color: UIColor.black))
                label.numberOfLines = 0
                label.attributedText = labelTitle
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let views = ["label": label]
                self.view.addSubview(label)
                let widthConstraints:[NSLayoutConstraint]
                
                if payment.paymentMethodId == "redlink"{
                    widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[label]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                } else {
                    widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[label]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                }
                
                setContrainsVertical(label: label, previus: previus, constrain: 1)
                previus = label
                NSLayoutConstraint.activate(widthConstraints)
                
            }
            if instruction.accreditationMessage != "" {
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
                label.textAlignment = .center
                let labelText = NSAttributedString(string: String(describing: instruction.accreditationMessage), attributes: getAttributes(fontSize: 12, color: UIColor.gray))
                label.numberOfLines = 3
                label.attributedText = labelText
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                image.image = MercadoPago.getImage("iconTime")
                image.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(image)
                
                let views = ["label": label, "image": image] as [String : Any]
                self.view.addSubview(label)
                
                let widthConstraints:[NSLayoutConstraint]
                
                
                widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[image]-[label]-\((UIScreen.main.bounds.width - label.frame.width - 16)/2)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                setContrainsVertical(label: label, previus: previus, constrain: 30)
                NSLayoutConstraint.activate(widthConstraints)
                let verticalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                view.addConstraint(verticalConstraint)
                
                previus = label
            }
            if instruction.actions != nil && (instruction.actions?.count)! > 0 {
                if instruction.actions![0].tag == ActionTag.LINK.rawValue {
                    let button = MPButton(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
                    button.titleLabel?.font = UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 16) ?? UIFont.systemFont(ofSize: 16)
                    button.setTitle(instruction.actions![0].label, for: .normal)
                    button.setTitleColor(UIColor(red: 0, green: 158, blue: 227), for: .normal)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    
                    button.actionLink = instruction.actions![0].url
                    button.addTarget(self, action: #selector(self.goToURL), for: .touchUpInside)
                    self.view.addSubview(button)
                    let views = ["button": button]
                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[button]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    
                    setContrainsVertical(label: button, previus: previus, constrain: 30)
                    NSLayoutConstraint.activate(widthConstraints)
                    previus = button
                }
            }
            
            let views = ["label": previus]
            let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            NSLayoutConstraint.activate(heightConstraints)
            
        }
        
    }
    func getAttributes(fontSize:Int, color:UIColor)-> [String:AnyObject] {
        return [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize)),NSForegroundColorAttributeName: color]
    }
    
    func setContrainsHorizontal(views: [String: UILabel]){
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[label]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(widthConstraints)
    }
    
    func setContrainsVertical(label: UIView, previus: UIView, constrain:CGFloat){
        let heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: constrain)]
        NSLayoutConstraint.activate(heightConstraints)
    }
    
    func goToURL(sender:MPButton!)
    {   if let link = sender.actionLink {
        UIApplication.shared.openURL(URL(string: link)!)
        }
    }
    
}
