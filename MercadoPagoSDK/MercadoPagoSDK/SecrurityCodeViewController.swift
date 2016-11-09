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
    
    @IBOutlet weak var panelView: UIView!
    var viewModel : SecrurityCodeViewModel!
    
    var card : CardFrontView!
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        loadMPStyles()
        self.errorLabel.alpha = 0
        self.view.backgroundColor = MercadoPagoContext.getPrimaryColor()
        self.card = CardFrontView()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public init(paymentMethod : PaymentMethod! ,token : Token!, callback: ((_ token: Token?)->Void)! ){
    
        super.init(nibName: "SecrurityCodeViewController", bundle: MercadoPago.getBundle())
        self.viewModel = SecrurityCodeViewModel(paymentMethod: paymentMethod, token: token, callback: callback)
        
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
    
    
    @IBAction func cloneToken(_ sender: AnyObject) {
        self.viewModel.cloneTokenAndCallback(secCode: "123")
    }
    
}

open class SecrurityCodeViewModel: NSObject {
    var paymentMethod : PaymentMethod!
    var token : Token!
    
    
    public init(paymentMethod : PaymentMethod! ,token : Token!, callback: ((_ token: Token?)->Void)! ){
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
    
    func getCardCellHeight() -> CGFloat {
        return UIScreen.main.bounds.height*0.27
    }
    
    
}

