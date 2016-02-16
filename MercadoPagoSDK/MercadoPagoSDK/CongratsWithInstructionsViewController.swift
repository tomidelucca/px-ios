//
//  CongratsWithInstructionsViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CongratsWithInstructionsViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var congratsTable: UITableView!
    
    var paymentMethod : PaymentMethod?
    var bundle = MercadoPago.getBundle()
    
    public init(paymentMethod : PaymentMethod) {
        super.init(nibName: "CongratsWithInstructionsViewController", bundle: bundle)
        self.paymentMethod = paymentMethod
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.congratsTable.delegate = self
        self.congratsTable.dataSource = self
        
        //Register all cells
        let instructionsHeaderCell = UINib(nibName: "InstructionsHeaderViewCell", bundle: self.bundle)
        let instructionsCell = UINib(nibName: "InstructionsViewCell", bundle: self.bundle)
        let instructionsFooterCell = UINib(nibName: "CongratsInstructionsFooterViewCell", bundle: self.bundle)

        self.congratsTable.registerNib(instructionsHeaderCell, forCellReuseIdentifier: "instructionsHeaderCell")
        self.congratsTable.registerNib(instructionsCell, forCellReuseIdentifier: "instructionsCell")
        self.congratsTable.registerNib(instructionsFooterCell, forCellReuseIdentifier: "instructionsFooterCell")
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Atrás".localized, style: UIBarButtonItemStyle.Bordered, target: self, action: "clearMercadoPagoStyleAndGoBack")
        self.navigationItem.leftBarButtonItem?.target = self
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let instructionsHeaderCell = self.congratsTable.dequeueReusableCellWithIdentifier("instructionsHeaderCell") as! InstructionsHeaderViewCell
            return instructionsHeaderCell
        }
        
        if indexPath.row == 0 {
            let instructionsCell = self.congratsTable.dequeueReusableCellWithIdentifier("instructionsCell") as! InstructionsViewCell
            return instructionsCell
        }
        
        let instructionsFooter = self.congratsTable.dequeueReusableCellWithIdentifier("instructionsFooterCell") as! CongratsInstructionsFooterViewCell
        return instructionsFooter
        
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 182
        }
        return indexPath.row == 0 ? 264 : 96
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 15
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    

}
