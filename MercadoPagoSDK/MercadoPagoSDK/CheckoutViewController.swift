//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var preferenceId : String!
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
    
    init(preferenceId : String, callback : (Payment -> Void)){
        super.init(nibName: "CheckoutViewController", bundle: MercadoPago.getBundle())
        self.publicKey = MercadoPagoContext.publicKey()
        self.accessToken = MercadoPagoContext.merchantAccessToken()
        self.preferenceId = preferenceId
        self.callback = callback
        self.callbackCancel = {
            self.dismissViewControllerAnimated(true, completion: { 
                
            })
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {

        super.viewDidLoad()
        
        self.checkoutTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.01))
        
        //Display preference description by default
        self.displayPreferenceDescription = true
        
        self.title = "¿Cómo quieres pagar?".localized
        
        if preference == nil {
            self.loadPreference()
        } else {
            self.loadGroupsAndStartPaymentVault()
        }
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showLoading()
        
        //Remove navigation items
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil

        if self.paymentMethod != nil {
            self.checkoutTable.reloadData()
        }
        
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hideLoading()
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
                    let displayEditSelection = (paymentMethodSearch!.groups.count > 1)
                    cell.fillRowWithPaymentMethod(self.paymentMethod!, paymentMethodSearchItemSelected: paymentMethodSearchItemSelected!, displayCustomIndicator: displayEditSelection)
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
        } else if indexPath.section == 1 && indexPath.row == 0 && self.paymentMethodSearch?.groups.count > 1 {
            self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
            self.loadGroupsAndStartPaymentVault(true)
        }
    }
    
    
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1) ? 140 : 0
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let copyrightCell =  self.checkoutTable.dequeueReusableCellWithIdentifier("copyrightCell") as! CopyrightTableViewCell
            copyrightCell.cancelButton.addTarget(self, action: "invokeCallbackCancel", forControlEvents: .TouchUpInside)
            copyrightCell.drawBottomLine(self.view.bounds.width)
            return copyrightCell
        }
        return nil
    }
    
    internal func loadGroupsAndStartPaymentVault(animated : Bool = false){
        
        if self.paymentMethodSearch == nil {
            MPServicesBuilder.searchPaymentMethods(self.preference?.getExcludedPaymentTypesIds(), excludedPaymentMethodIds: self.preference?.getExcludedPaymentMethodsIds(), success: { (paymentMethodSearch) in
                self.paymentMethodSearch = paymentMethodSearch
                
                self.startPaymentVault()
                }, failure: { (error) in
                    //TODO handle error
            })
        } else {
            self.startPaymentVault(animated)
        }
        
    }
    
    internal func startPaymentVault(animated : Bool = false){
        self.registerAllCells()
        
        let paymentVaultVC = MPFlowBuilder.startPaymentVaultInCheckout(self.preference!.getAmount(), purchaseTitle: self.preference!.getTitle(), currencyId: self.preference!.getCurrencyId(), pictureUrl : self.preference!.getPictureUrl(), paymentSettings: self.preference!.getPaymentSettings(), paymentMethodSearch: self.paymentMethodSearch!, callback: { (paymentMethod, token, issuer, installments) in
                self.paymentMethod = paymentMethod
                self.token = token
                self.issuer = issuer
                self.installments = installments
                self.checkoutTable.reloadData()
            
            
                let transition = CATransition()
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
                self.navigationController!.popToRootViewControllerAnimated(animated)
            
        })
        
        var callbackCancel : (Void -> Void)
        // Set action for cancel callback
        if self.paymentMethod == nil {
            callbackCancel = { Void -> Void in
                self.dismissViewControllerAnimated(true, completion: {
                })
            }
        } else {
            callbackCancel = { Void -> Void in
               self.navigationController!.popViewControllerAnimated(true)
            }
        }

        (paymentVaultVC.viewControllers[0] as! PaymentVaultViewController).callbackCancel = callbackCancel
        self.navigationController?.pushViewController(paymentVaultVC.viewControllers[0], animated: animated)
    }
    
    internal func confirmPayment(){
        
        self.showLoading()
        self.paymentButton!.enabled = false

        if (self.paymentMethod!.isOfflinePaymentMethod()){
            self.confirmPaymentOff()
        } else {
            self.confirmPaymentOn()
        }
        self.hideLoading()
    }
    
    internal func confirmPaymentOff(){
        MercadoPago.createMPPayment(self.preference!.payer.email, preferenceId: self.preference!._id, paymentMethod: self.paymentMethod!,success: { (payment) -> Void in
            payment._id = 1826446924
            self.navigationController!.pushViewController(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                self.modalTransitionStyle = .CrossDissolve
                self.dismissViewControllerAnimated(true, completion: {
                    
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
                  
                })
                self.callback(payment)
            }), animated: true)
        })
    }
    
    internal func confirmPaymentOn(){
        MercadoPago.createMPPayment(self.preference!.payer.email, preferenceId: self.preference!._id, paymentMethod: self.paymentMethod!,token : self.token, installments: self.installments , issuer: self.issuer,success: { (payment) -> Void in
            
                self.clearMercadoPagoStyleAndGoBack()
                let congratsVC = MPStepBuilder.startPaymentCongratsStep(payment, callback: {
                    self.dismissViewControllerAnimated(true, completion: {
                        
                    })
                })
                self.navigationController?.pushViewController(congratsVC, animated: true)
            
            }, failure : { (error) -> Void in
                //TODO : remove / payment failed
                
        })
    }

    
    internal func togglePreferenceDescription(){
        self.togglePreferenceDescription(self.checkoutTable)
    }
    
    private func loadPreference(){
        MPServicesBuilder.getPreference(self.preferenceId, success: { (preference) in
                if preference.validate() != nil {
                    //TODO error
                }
                self.preference = preference
                self.loadGroupsAndStartPaymentVault(false)
            }) { (error) in
                //TODO
        }
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
