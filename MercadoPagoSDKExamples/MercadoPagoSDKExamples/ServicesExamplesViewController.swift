//
//  ServicesExamplesViewController.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 29/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class ServicesExamplesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let servicesExamples = [
        "Métodos de Pago".localized,
        "Simple Payment Vault".localized,
        "Advanced Vault".localized,
        "Final Vault".localized
         ]
    
    @IBOutlet weak var servicesExamplesTable: UITableView!
    
    var paymentMethod : PaymentMethod!
    
    init(){
        super.init(nibName: "ServicesExamplesViewController", bundle: nil)
        let pm = PaymentMethod()
        pm._id = "master"
        pm.name = "Mastercard"
        pm.paymentTypeId = PaymentTypeId.CREDIT_CARD.rawValue
        
        self.paymentMethod = pm
        
        //Initialize MercadoPagoContext
        MercadoPagoContext.setCustomerURI(ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI)
        MercadoPagoContext.setMerchantAccessToken(ExamplesUtils.MERCHANT_ACCESS_TOKEN)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.servicesExamplesTable.delegate = self
        self.servicesExamplesTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servicesExamples.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.servicesExamples[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.servicesExamplesTable.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            startPaymentMethodsVault()
        case 1:
            startSimpleVault()
        case 2:
            startAdvancedVault()
            return
        case 3:
            startFinalVault()
        default:
            break
        }
    }
    
    private func startPaymentMethodsVault(){
        //TODO !!!!!!
    }
    
    private func startSimpleVault(){
        let simpleVault = ExamplesUtils.startSimpleVaultActivity(MercadoPagoContext.publicKey(), merchantBaseUrl:  ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: MercadoPagoContext.customerURI(), merchantAccessToken: MercadoPagoContext.merchantAccessToken(), paymentPreference: nil) { (paymentMethod, token) in
            
        }
        
        self.navigationController?.pushViewController(simpleVault, animated: true)
    }
    
    private func startAdvancedVault(){
        let advancedVault = ExamplesUtils.startAdvancedVaultActivity(MercadoPagoContext.publicKey(), merchantBaseUrl:  ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: MercadoPagoContext.customerURI(), merchantAccessToken: MercadoPagoContext.merchantAccessToken(), amount: 1000, paymentPreference: nil, callback: { (paymentMethod, token, issuer, installments) in
        
        })
    
        self.navigationController?.pushViewController(advancedVault, animated: true)
    }
    
    
    private func startFinalVault(){
        let finalVault = ExamplesUtils.startFinalVaultActivity(MercadoPagoContext.publicKey(), merchantBaseUrl:  ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: MercadoPagoContext.customerURI(), merchantAccessToken: MercadoPagoContext.merchantAccessToken(), amount: 1000, paymentPreference: nil) { (paymentMethod, token, issuer, installments) in
            
        }
        
        self.navigationController?.pushViewController(finalVault, animated: true)
    }
}
