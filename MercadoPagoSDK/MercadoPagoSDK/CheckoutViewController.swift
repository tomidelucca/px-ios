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
    var callback : (Payment -> Void)!
    var paymentMethod : PaymentMethod?
    var installments : Int = 0
    var issuer : Issuer?
    var token : Token?
    var paymentButton : MPButton?
    var paymentMethodSearch : PaymentMethodSearch?
    var payerCost : PayerCost?
    
    private var reviewAndConfirmContent = Set<String>()
    
    @IBOutlet weak var checkoutTable: UITableView!
    
    init(preference : CheckoutPreference, callback : (Payment -> Void)){
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

        //Display preference description by default
        self.displayPreferenceDescription = true
        
        self.title = "¿Cómo quieres pagar?".localized

        self.registerAllCells()
        
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Remove navigation items
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil

        if self.paymentMethod == nil {
            self.loadGroupsAndStartPaymentVault()
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && displayPreferenceDescription {
            return 0.1
        }
        return 8
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.displayPreferenceDescription {
                return 120
            }
            return 0
        }
        
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 60
        }
        return 180
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.displayPreferenceDescription ? 1 : 0
        }
        return (self.paymentMethod == nil) ? 2 : 3
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let preferenceDescriptionCell = tableView.dequeueReusableCellWithIdentifier("preferenceDescriptionCell", forIndexPath: indexPath) as! PreferenceDescriptionTableViewCell
            preferenceDescriptionCell.fillRowWithPreference(self.preference!)
            return preferenceDescriptionCell
        }
    
        if indexPath.row == 0 {
            if self.paymentMethod != nil {
                if self.paymentMethod!.isOfflinePaymentMethod() {
                    self.title = "Revisa si está todo bien...".localized
                    let cell = tableView.dequeueReusableCellWithIdentifier("offlinePaymentCell", forIndexPath: indexPath) as! OfflinePaymentMethodCell
                    let paymentMethodSearchItemSelected = Utils.findPaymentMethodSearchItemInGroups(self.paymentMethodSearch!, paymentMethodId: self.paymentMethod!._id, paymentTypeId: self.paymentMethod!.paymentTypeId)
                    cell.fillRowWithPaymentMethod(self.paymentMethod!, paymentMethodSearchItemSelected: paymentMethodSearchItemSelected!)
                    return cell
                } else {
                    self.title = "Tantito más y terminas…".localized
                }
                
            }
            
            return tableView.dequeueReusableCellWithIdentifier("selectPaymentMethodCell", forIndexPath: indexPath) as! SelectPaymentMethodCell
        } else if indexPath.row == 1 {
            let footer = self.checkoutTable.dequeueReusableCellWithIdentifier("paymentDescriptionFooter") as! PaymentDescriptionFooterTableViewCell
            
            footer.layer.shadowOffset = CGSizeMake(0, 1)
            footer.layer.shadowColor = UIColor(red: 153, green: 153, blue: 153).CGColor
            footer.layer.shadowRadius = 1
            footer.layer.shadowOpacity = 0.6
            footer.setAmount(self.preference!.getAmount())
            return footer
        }
        
        let termsAndConditionsButton = self.checkoutTable.dequeueReusableCellWithIdentifier("purchaseTermsAndConditions") as! TermsAndConditionsViewCell
        termsAndConditionsButton.paymentButton.addTarget(self, action: "confirmPayment", forControlEvents: .TouchUpInside)
        self.paymentButton = termsAndConditionsButton.paymentButton
        return termsAndConditionsButton
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
            self.loadGroupsAndStartPaymentVault()
        }
    }
    
    
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1) ? 140 : 0
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let copyrightCell =  self.checkoutTable.dequeueReusableCellWithIdentifier("copyrightCell") as! CopyrightTableViewCell
            copyrightCell.cancelButton.addTarget(self, action: "callbackCancel", forControlEvents: .TouchUpInside)
            copyrightCell.drawBottomLine(self.view.bounds.width)
            return copyrightCell
        }
        return nil
    }
    
    internal func loadGroupsAndStartPaymentVault(){
        
        if self.paymentMethodSearch == nil {
            LoadingOverlay.shared.showOverlay(self.view)
            MPServicesBuilder.searchPaymentMethods(self.preference?.getExcludedPaymentTypesIds(), excludedPaymentMethodIds: self.preference?.getExcludedPaymentMethodsIds(), success: { (paymentMethodSearch) in
                self.paymentMethodSearch = paymentMethodSearch
                
                self.startPaymentVault()
                }, failure: { (error) in
                    //TODO handle error
            })
        } else {
            self.startPaymentVault()
        }
        
    }
    
    internal func startPaymentVault(){
        let paymentVaultVC = MPFlowBuilder.startPaymentVaultInCheckout(self.preference!.getAmount(), paymentSettings: self.preference!.getPaymentSettings(), paymentMethodSearch: self.paymentMethodSearch!, callback: { (paymentMethod, token, issuer, installments) in
                self.paymentMethod = paymentMethod
                self.token = token
                self.issuer = issuer
                self.installments = installments
                self.checkoutTable.reloadData()
            
                let transition = CATransition()
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
                self.navigationController!.popToRootViewControllerAnimated(false)
        })
        
        // Set action for cancel callback
        (paymentVaultVC.viewControllers[0] as! PaymentVaultViewController).callbackCancel = { Void -> Void in
            self.dismissViewControllerAnimated(true, completion: {
                LoadingOverlay.shared.hideOverlayView()
            })
        }

        self.navigationController?.pushViewController(paymentVaultVC.viewControllers[0], animated: true)
    }
    
    internal func confirmPayment(){
        
        LoadingOverlay.shared.showOverlay(self.view)
        self.paymentButton!.enabled = false

        if ((self.paymentMethod?.isOfflinePaymentMethod()) != nil){
            self.confirmPaymentOff()
        } else {
            let payment = Payment()
            payment.transactionAmount = self.preference!.getAmount()
            payment.tokenId = token?._id
            payment.issuerId = self.issuer != nil ? self.issuer!._id!.integerValue : 0
            payment.paymentMethodId = self.paymentMethod!._id
            //TODO
            payment._description = self.preference!.items![0].title
            self.confirmPaymentOn(payment, token: token!)
        }
        
        
       
    }
    
    internal func confirmPaymentOff(){
        MercadoPago.createMPPayment(self.preference!.payer.email, preferenceId: self.preference!._id, paymentMethod: self.paymentMethod!,token : nil, payerCost: nil, issuer: nil,success: { (payment) -> Void in
            payment._id = 1826446924
            self.navigationController!.pushViewController(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                self.modalTransitionStyle = .CrossDissolve
                self.dismissViewControllerAnimated(true, completion: {
                    LoadingOverlay.shared.hideOverlayView()
                })
                    self.callback(payment)
                }), animated: true)
           }, failure : { (error) -> Void in
                //TODO : remove / payment failed
            let payment = Payment()
            payment.transactionAmount = self.preference!.getAmount()
            payment.issuerId = self.issuer != nil ? self.issuer!._id!.integerValue : 0
            payment.paymentMethodId = self.paymentMethod!._id
            payment.paymentTypeId = self.paymentMethod!.paymentTypeId.rawValue
            payment._description = self.preference!.items![0].title
            payment._id = 1826446924
            self.navigationController?.pushViewController(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                self.modalTransitionStyle = .CrossDissolve
                self.dismissViewControllerAnimated(true, completion: {
                  LoadingOverlay.shared.hideOverlayView()
                })
                self.callback(payment)
            }), animated: true)
        })
    }
    
    internal func confirmPaymentOn(payment : Payment , token : Token){
        MercadoPago.createMPPayment(self.preference!.payer.email, preferenceId: self.preference!._id, paymentMethod: self.paymentMethod!,token : token, payerCost:payerCost , issuer: self.issuer,success: { (payment) -> Void in
            
                self.clearMercadoPagoStyleAndGoBack()
              //  MPFlowController.dismiss(true)
            }, failure : { (error) -> Void in
                //TODO : remove / payment failed
              /*  MPFlowController.push(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                    self.clearMercadoPagoStyle()
                    self.callback(payment)
                }))*/
                
        })
    }
    
    internal func callbackCancel(){
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    internal func togglePreferenceDescription(){
        self.togglePreferenceDescription(self.checkoutTable)
    }
    
    private func registerAllCells(){
        
        //Register rows
        let offlinePaymentMethodNib = UINib(nibName: "OfflinePaymentMethodCell", bundle: self.bundle)
        self.checkoutTable.registerNib(offlinePaymentMethodNib, forCellReuseIdentifier: "offlinePaymentCell")
        let preferenceDescriptionCell = UINib(nibName: "PreferenceDescriptionTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(preferenceDescriptionCell, forCellReuseIdentifier: "preferenceDescriptionCell")
        let selectPaymentMethodCell = UINib(nibName: "SelectPaymentMethodCell", bundle: self.bundle)
        self.checkoutTable.registerNib(selectPaymentMethodCell, forCellReuseIdentifier: "selectPaymentMethodCell")
        let paymentDescriptionFooter = UINib(nibName: "PaymentDescriptionFooterTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(paymentDescriptionFooter, forCellReuseIdentifier: "paymentDescriptionFooter")
        let purchaseTermsAndConditions = UINib(nibName: "TermsAndConditionsViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(purchaseTermsAndConditions, forCellReuseIdentifier: "purchaseTermsAndConditions")
        let copyrightCell = UINib(nibName: "CopyrightTableViewCell", bundle: self.bundle)
        
        self.checkoutTable.registerNib(copyrightCell, forCellReuseIdentifier: "copyrightCell")
        
        self.checkoutTable.delegate = self
        self.checkoutTable.dataSource = self
        self.checkoutTable.separatorStyle = .None
    }
    
    
}
