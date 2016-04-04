//
//  PaymentInstallmentsViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 3/22/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentInstallmentsViewController: MercadoPagoUIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var bundle : NSBundle? = MercadoPago.getBundle()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    public init(paymentMethod : PaymentMethod?,issuer : Issuer?,cardToken : Token?,amount : Double?,minInstallments : Int?, callback : ((installment: Installment) -> Void)) {
        super.init(nibName: "PaymentInstallmentsViewController", bundle: self.bundle)
     
        self.edgesForExtendedLayout = .All
        MPServicesBuilder.getInstallments("547492", amount: 10000, issuer: issuer, paymentTypeId: PaymentTypeId.CREDIT_CARD, success: { (installments) -> Void in
            self.tableView.reloadData()
            }) { (error) -> Void in
                print("error!")
        }

    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let installmentNib = UINib(nibName: "PaymentInstallmentTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(installmentNib, forCellReuseIdentifier: "PaymentInstallmentsCell")
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        return 50
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 40
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        


            let installmentCell = tableView.dequeueReusableCellWithIdentifier("PaymentInstallmentsCell", forIndexPath: indexPath) as! PaymentInstallmentTableViewCell
            
            return installmentCell
        }
          }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    

