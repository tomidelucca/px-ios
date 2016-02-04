//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var preference : CheckoutPreference?
    var publicKey : String!
    var accessToken : String!
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : (MerchantPayment -> Void)!
    var paymentMethod : PaymentMethod?
    var installments : Int = 0
    var issuer : Issuer?
    var tokenId : String?
    
    private var reviewAndConfirmContent = Set<String>()
    
    @IBOutlet weak var checkoutTable: UITableView!
    
    @IBOutlet weak var confirmPaymentButton: UIButton!
    
    init(preference : CheckoutPreference, callback : (MerchantPayment -> Void)){
        super.init(nibName: "CheckoutViewController", bundle: MercadoPago.getBundle())
        self.preference = preference
        self.publicKey = MercadoPagoContext.publicKey()
        self.accessToken = MercadoPagoContext.merchantAccessToken()
        self.callback = callback
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "¿Cómo quieres pagar?".localized

        //Register rows
        let offlinePaymentMethodNib = UINib(nibName: "OfflinePaymentMethodCell", bundle: self.bundle)
        self.checkoutTable.registerNib(offlinePaymentMethodNib, forCellReuseIdentifier: "offlinePaymentCell")
        
        let preferenceDescriptionCell = UINib(nibName: "PreferenceDescriptionTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(preferenceDescriptionCell, forCellReuseIdentifier: "preferenceDescriptionCell")
        
        self.checkoutTable.delegate = self
        self.checkoutTable.dataSource = self
        self.checkoutTable.contentInset = UIEdgeInsetsMake(-35.0, 0.0, 0.0, 0.0);
        
        self.confirmPaymentButton.setTitle("Pagar $".localized +  String(preference!.getAmount()), forState: .Normal)
        
        self.confirmPaymentButton.addTarget(self, action: "confirmPayment", forControlEvents: .TouchUpInside)
        self.confirmPaymentButton.layer.cornerRadius = 5
        self.confirmPaymentButton.clipsToBounds = true
        

        
//        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        self.navigationItem.leftBarButtonItem?.action = Selector("clearMercadoPagoStyle")
        self.navigationItem.leftBarButtonItem?.target = self
            
            
        self.startPaymentVault()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return CGFloat(100 * self.reviewAndConfirmContent.count)
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : reviewAndConfirmContent.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let preferenceDescriptionCell = UITableViewCell()
        
        if self.paymentMethod != nil {
            //TODO : complete flow
            self.title = "Revisa si está todo bien...".localized
            if indexPath.section == 0 {
                let preferenceDescriptionCell = tableView.dequeueReusableCellWithIdentifier("preferenceDescriptionCell", forIndexPath: indexPath) as! PreferenceDescriptionTableViewCell
                preferenceDescriptionCell.fillRowWithPreference(self.preference!)
                return preferenceDescriptionCell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("offlinePaymentCell", forIndexPath: indexPath) as! OfflinePaymentMethodCell
                cell.fillRowWithPaymentMethod(self.paymentMethod!)
                let leftMargin = UIView(frame: CGRectMake(0, 0, 8, 100))
                leftMargin.backgroundColor = UIColor().backgroundColor()
                
                
                cell.contentView.addSubview(leftMargin)
                
                let rightMargin = UIView(frame: CGRectMake(cell.frame.width - 8, 0, 8, 100))
                rightMargin.backgroundColor = UIColor().backgroundColor()
                cell.contentView.addSubview(rightMargin)
                return cell
            }
        } else {
            //TODO: verificar!!!
            let preferenceDescriptionCell = tableView.dequeueReusableCellWithIdentifier("preferenceDescriptionCell", forIndexPath: indexPath) as! PreferenceDescriptionTableViewCell
            preferenceDescriptionCell.preferenceDescription.text = self.preference!.items![0].title
        }
        return preferenceDescriptionCell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
        self.startPaymentVault()
    }

    internal func startPaymentVault(){
        let paymentVault = MPFlowBuilder.startPaymentVaultViewController((preference?.getAmount())!, excludedPaymentTypes: preference!.getExcludedPaymentTypes(), excludedPaymentMethods: preference!.getExcludedPaymentMethods()) { (paymentMethod, tokenId, issuer, installments) -> Void in
            self.paymentMethod = paymentMethod
            self.tokenId = tokenId
            self.issuer = issuer
            self.installments = installments
            
            self.reviewAndConfirmContent.insert("OfflinePayment")
            
            self.checkoutTable.reloadData()
        }
        
        self.navigationController?.pushViewController(paymentVault, animated: true)
    }
    
    internal func confirmPayment(){
        let payment = Payment()
        payment.transactionAmount = self.preference!.getAmount()
        payment.tokenId = self.tokenId
        payment.issuerId = self.issuer != nil ? self.issuer!._id!.integerValue : 0
        payment.paymentMethodId = self.paymentMethod!._id
        payment._description = "description"
    
        clearMercadoPagoStyle()
        MercadoPago.createMPPayment(payment, success: { (payment) -> Void in
            self.navigationController?.pushViewController(MPStepBuilder.startCongratsStep(payment, paymentMethod: self.paymentMethod!), animated: true)
            }) { (error) -> Void in
                //TODO
                
        }
    }
    
    internal func cancelPayment(){
        clearMercadoPagoStyle()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
