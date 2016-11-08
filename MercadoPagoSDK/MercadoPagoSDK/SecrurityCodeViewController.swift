//
//  SecrurityCodeViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 11/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class SecrurityCodeViewController: MercadoPagoUIViewController {
    
    @IBOutlet weak var securityCodeLabel: UILabel!
    @IBOutlet weak var securityCodeTextField: HoshiTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel : SecrurityCodeViewModel!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        loadMPStyles()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public init(paymentMethod : [PaymentMethod] ,issuer : Issuer?, token : CardInformationForm?, amount: Double?, paymentPreference: PaymentPreference?,installment: Installment?, timer: CountdownTimer?, callback: ((_ payerCost: NSObject?)->Void)? ){
        
        self.viewModel = SecrurityCodeViewModel()
        
        super.init(nibName: "CardAdditionalStep", bundle: self.bundle)
        self.timer=timer
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBar()
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.showNavBar()
    }
    
    
    func showNavBar() {
      //  self.title = self.viewModel.getTilte()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.isTranslucent = false
        let font : UIFont = UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 22) ?? UIFont.systemFont(ofSize: 22)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.systemFontColor(), NSFontAttributeName: font]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    func hideNavBar(){
        self.title = ""
        navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
}

open class SecrurityCodeViewModel: NSObject {
    let paymentMethod : PaymentMethod! = nil
    let token : Token! = nil
    
    
    public init(paymentMethod : PaymentMethod! ,token : Token!, amount: Double?, callback: ((_ token: Token?)->Void)! ){
        self.paymentMethod = paymentMethod
        self.token = token
        self.callback = callback
    }
        
        
    var callback : ((_ token: Token?) -> Void)!
    
    func secCodeInBack() -> Bool {
        return paymentMethod.secCodeInBack()
    }
    func secCodeLenght() -> Int {
        return paymentMethod.secCodeLenght()
    }
    func cloneTokenAndCallback(secCode : String!) {
        MPServicesBuilder.cloneToken(token,securityCode:secCode, success: { (token) in
            self.callback(token)
            }, failure: { (error) in
            self.callback(nil) // VER
        })
    }
}

