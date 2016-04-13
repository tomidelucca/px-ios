//
//  CongratsWithInstructionsViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import Foundation

public class InstructionsViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var congratsTable: UITableView!
    
    var currentInstruction : Instruction?
    
    // NSDictionary used to build instructions screens by paymentMethodId
    let instructionsByPaymentMethod = ["oxxo" : ["body" : "simpleInstructionsCell", "body_heigth" : 130, "footer" : "defaultInstructionsFooterCell", "footer_height" : 100],
        "serfin_ticket" : ["body" : "instructionsTwoLabelsCell" , "body_heigth" : 170, "footer" : "defaultInstructionsFooterCell", "footer_height" : 100],
        "bancomer_ticket" : ["body" : "instructionsTwoLabelsCell" , "body_heigth" : 170, "footer" : "intructionsWithTertiaryInfoFooterCell", "footer_height" : 150],
        "7eleven" : ["body" : "instructionsTwoLabelsCell" , "body_heigth" : 170, "footer" : "defaultInstructionsFooterCell", "footer_height" : 100],
        "banamex_ticket" : ["body" : "instructionsCell" , "body_heigth" : 210, "footer" : "defaultInstructionsFooterCell", "footer_height" : 100],
        "telecomm" : ["body" : "instructionsCell" , "body_heigth" : 210, "footer" : "intructionsWithTertiaryInfoFooterCell", "footer_height" : 150],
        "serfin_bank_transfer" : ["body" : "simpleInstructionWithButtonViewCell" , "body_heigth" : 208, "footer" : "intructionsWithSecondaryInfoFooterCell", "footer_height" : 130],
        "banamex_bank_transfer" : ["body" : "instructionsWithButtonCell" , "body_heigth" : 276, "footer" : "intructionsWithSecondaryInfoFooterCell", "footer_height" : 130],
        "bancomer_bank_transfer" : ["body" : "instructionsTwoLabelsAndButtonViewCell" , "body_heigth" : 258, "footer" : "intructionsWithSecondaryInfoFooterCell", "footer_height" : 130],
    ]
    
    var payment : Payment!
    var callback : ((Payment) -> Void)!
    var bundle = MercadoPago.getBundle()
    
    public init(payment : Payment, callback : (Payment) -> Void) {
        super.init(nibName: "InstructionsViewController", bundle: bundle)
        self.payment = payment
        self.callback = callback
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer?.delegate = nil
        
        
        if currentInstruction == nil {
            registerAllCells()
            MPServicesBuilder.getInstructionsByPaymentId(payment._id, paymentMethodId: payment.paymentMethodId.lowercaseString, success: { (instruction) -> Void in
                self.currentInstruction = instruction
                self.congratsTable.delegate = self
                self.congratsTable.dataSource = self
                self.congratsTable.reloadData()
                }, failure: { (error) -> Void in
                    //TODO
            })
        } else {
            self.congratsTable.reloadData()
        }
        
        self.congratsTable.tableHeaderView = UIView(frame: CGRectMake(0.0, 0.0, self.congratsTable.bounds.size.width, 0.01))
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = nil
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        self.loadMPStyles()
        self.navigationController?.navigationBar.barTintColor = UIColor().UIColorFromRGB(0xFBF8E3)
    }
    
    override public func viewWillDisappear(animated: Bool) {
        self.clearMercadoPagoStyle()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  section == 1 ? 20 : 0.01
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let instructionsHeaderCell = self.congratsTable.dequeueReusableCellWithIdentifier("instructionsHeaderCell") as! InstructionsHeaderViewCell
            return instructionsHeaderCell.fillCell(self.currentInstruction!.title, amount : self.payment.transactionAmount)
        }
        
        if indexPath.section == 1 {
            let bodyViewCell = self.resolveInstructionsBodyViewCell(self.payment.paymentMethodId)!
            return bodyViewCell
        }
        
        if indexPath.section == 2 {
            let footer = self.resolveInstructionsFooter(self.payment.paymentMethodId)!
            /*footer.layer.shadowOffset = CGSizeMake(0, 1)
            footer.layer.shadowColor = UIColor(red: 153, green: 153, blue: 153).CGColor
            footer.layer.shadowRadius = 3
            footer.layer.shadowOpacity = 0.6*/
            return footer
        }
        
        let copyrightCell =  self.congratsTable.dequeueReusableCellWithIdentifier("copyrightCell") as! CopyrightTableViewCell
        copyrightCell.cancelButton.setTitle("Finalizar".localized, forState: .Normal)
        return copyrightCell
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 182
        }
        if indexPath.section == 1  {
            return self.resolveInstructionsBodyHeightForRow(self.payment.paymentMethodId)
        } else if indexPath.section == 2 {
            return self.resolveInstructionsFooterHeight(self.payment.paymentMethodId)
        }
        return 140
    }

    

    internal func resolveInstructionsBodyViewCell(paymentMethodId : String) -> UITableViewCell? {
        let instructionScreenStructure = self.instructionsByPaymentMethod[paymentMethodId]
        let instructionBodyCell = instructionScreenStructure!["body"] as! String
        let cell = self.congratsTable.dequeueReusableCellWithIdentifier(instructionBodyCell) as! InstructionsFillmentDelegate
        return cell.fillCell(self.currentInstruction!)
    }
    
    internal func resolveInstructionsBodyHeightForRow(paymentMethodId : String) -> CGFloat {
        let instructionScreenStructure = self.instructionsByPaymentMethod[paymentMethodId]
        let instructionBodyHeight = instructionScreenStructure!["body_heigth"] as! CGFloat
        return instructionBodyHeight
    }
    
    internal func resolveInstructionsFooter(paymentMethodId : String) -> UITableViewCell? {
        let instructionScreenStructure = self.instructionsByPaymentMethod[paymentMethodId]
        let instructionFooterCell = instructionScreenStructure!["footer"] as! String
        let cell = self.congratsTable.dequeueReusableCellWithIdentifier(instructionFooterCell)  as! InstructionsFillmentDelegate
        return cell.fillCell(self.currentInstruction!)
    }
    
    internal func resolveInstructionsFooterHeight(paymentMethodId : String) -> CGFloat {
        let instructionScreenStructure = self.instructionsByPaymentMethod[paymentMethodId]
        let instructionBodyHeight = instructionScreenStructure!["footer_height"] as! CGFloat
        return instructionBodyHeight
    }
    
    internal func finishInstructions(){
        self.callback(self.payment)
    }
    
    internal func registerAllCells() {

        // Create cell nibs
        let instructionsHeaderCell = UINib(nibName: "InstructionsHeaderViewCell", bundle: self.bundle)
        
        let instructionsCell = UINib(nibName: "InstructionsViewCell", bundle: self.bundle)
        let instructionsTwoLabelsCell = UINib(nibName: "InstructionsTwoLabelsViewCell", bundle: self.bundle)
        let simpleInstructionsViewCell = UINib(nibName: "SimpleInstructionsViewCell", bundle: self.bundle)
        let simpleInstructionsWithButtonViewCell = UINib(nibName: "SimpleInstructionsWithButtonViewCell", bundle: self.bundle)
        let instructionsWithButtonCell = UINib(nibName: "InstructionsWithButtonViewCell", bundle: self.bundle)
        let instructionsTwoLabelsWithButtonCell = UINib(nibName: "InstructionsTwoLabelsAndButtonViewCell", bundle: self.bundle)
        
        let defaultInstructionsFooterCell = UINib(nibName: "DefaultInstructionsFooterViewCell", bundle: self.bundle)
        let instructionFooterWithTertiaryInfoCell = UINib(nibName: "InstructionsFooterWithTertiaryInfoViewCell", bundle: self.bundle)
        let instructionFooterWithSecondaryInfoCell = UINib(nibName: "InstructionsFooterWithSecondaryInfoViewCell", bundle: self.bundle)
        let copyrightCell = UINib(nibName: "CopyrightTableViewCell", bundle: self.bundle)
        
        // Register cell nibs in table
        self.congratsTable.registerNib(instructionsHeaderCell, forCellReuseIdentifier: "instructionsHeaderCell")
        self.congratsTable.registerNib(instructionsCell, forCellReuseIdentifier: "instructionsCell")
        self.congratsTable.registerNib(instructionsTwoLabelsCell, forCellReuseIdentifier: "instructionsTwoLabelsCell")
        self.congratsTable.registerNib(simpleInstructionsViewCell, forCellReuseIdentifier: "simpleInstructionsCell")

        self.congratsTable.registerNib(simpleInstructionsWithButtonViewCell, forCellReuseIdentifier: "simpleInstructionWithButtonViewCell")
        self.congratsTable.registerNib(instructionsWithButtonCell, forCellReuseIdentifier: "instructionsWithButtonCell")
        self.congratsTable.registerNib(instructionsTwoLabelsWithButtonCell, forCellReuseIdentifier: "instructionsTwoLabelsAndButtonViewCell")
        
        self.congratsTable.registerNib(defaultInstructionsFooterCell, forCellReuseIdentifier: "defaultInstructionsFooterCell")
        self.congratsTable.registerNib(instructionFooterWithTertiaryInfoCell, forCellReuseIdentifier: "intructionsWithTertiaryInfoFooterCell")
        self.congratsTable.registerNib(instructionFooterWithSecondaryInfoCell, forCellReuseIdentifier: "intructionsWithSecondaryInfoFooterCell")
        self.congratsTable.registerNib(copyrightCell, forCellReuseIdentifier: "copyrightCell")
    }
}
