//
//  StepsExamplesViewController.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 29/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class StepsExamplesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let stepsExamples = [
        "Payment Vault".localized,
        "Card Form con cuotas".localized,
        "Card Form sin cuotas".localized,
        "Métodos de Pago".localized,
        "Selección de Banco".localized,
        "Selección de Cuotas".localized,
        "Crear Pago".localized
    ]
    
    @IBOutlet weak var stepsExamplesTable: UITableView!
    
    var paymentMethod : PaymentMethod!
    
    init(){
        super.init(nibName: "StepsExamplesViewController", bundle: nil)
        let pm = PaymentMethod()
        pm._id = "master"
        pm.name = "Mastercard"
        pm.paymentTypeId = PaymentTypeId.CREDIT_CARD.rawValue
        
        self.paymentMethod = pm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stepsExamplesTable.delegate = self
        self.stepsExamplesTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stepsExamples.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        self.stepsExamplesTable.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = UITableViewCell()
        cell.textLabel?.text = self.stepsExamples[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.stepsExamplesTable.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
           startPaymentVault()
        case 1:
            startCardFlow()
        case 2:
            startCardForm()
            return
        case 3:
            startPaymentMethods()
        case 4:
            statIssuersStep()
        case 5:
            startInstallmentsStep()
        case 6:
            createPayment()
        default:
            break
        }
    }
    
    private func startPaymentVault(){
        let pv = MPFlowBuilder.startPaymentVaultViewController(1000, currencyId: "ARS") { (paymentMethod, token, issuer, payerCost) in
            
        }
        self.presentViewController(pv, animated: true, completion: {})
    }
    
    private func startCardFlow(){
        var cf : UINavigationController!
        cf = MPFlowBuilder.startCardFlow(amount: 1000, callback: { (paymentMethod, token, issuer, payerCost) in
           cf!.dismissViewControllerAnimated(true, completion: {})
            }, callbackCancel : {
                cf!.dismissViewControllerAnimated(true, completion: {})
        })
        self.presentViewController(cf, animated: true, completion: {})
    }
    
    private func startCardForm(){
        var cf : UINavigationController!
        cf = MPStepBuilder.startCreditCardForm(amount: 1000, callback: { (paymentMethod, token, issuer) in
            cf!.dismissViewControllerAnimated(true, completion: {})
            }, callbackCancel : {
                cf!.dismissViewControllerAnimated(true, completion: {})
        })
        
        self.presentViewController(cf, animated: true, completion: {})
    }
    
    private func startPaymentMethods(){
        //TARAN TA TAN
        let pms = MPStepBuilder.startPaymentMethodsStep(nil) { (paymentMethod) in
            
        }
        self.navigationController?.pushViewController(pms, animated: true)
    }
    
    private func statIssuersStep(){
        let issuersVC = MPStepBuilder.startIssuersStep(self.paymentMethod) { (issuer) in
            
        }
        self.navigationController?.pushViewController(issuersVC, animated: true)
        
    }
    
    private func startInstallmentsStep(){
        
        let installmentsVC = MPStepBuilder.startInstallmentsStep(amount: 10000, issuer: nil, paymentMethodId: "visa") { (payerCost) in
            
        }
        self.navigationController?.pushViewController(installmentsVC, animated: true)
        
//TODO
//        let installmentsVC = MPStepBuilder.startPayerCostForm(self.paymentMethod, issuer: nil, token: "", amount: 1000, maxInstallments: nil) { (payerCost) in
//            
//        }
//        self.presentViewController(installmentsVC, animated: true, completion: {})
//        
    }
    
    private func createPayment(){
        
        MercadoPagoContext.setBaseURL("http://server.com")
        MercadoPagoContext.setPaymentURI("/payment_uri")
        
        let item : Item = Item(_id: ExamplesUtils.ITEM_ID, title: ExamplesUtils.ITEM_TITLE, quantity: ExamplesUtils.ITEM_QUANTITY,
                               unitPrice: ExamplesUtils.ITEM_UNIT_PRICE)

        //CardIssuer is optional
        let merchantPayment : MerchantPayment = MerchantPayment(items: [item], installments: 3, cardIssuer: nil, tokenId: "tokenId", paymentMethod: self.paymentMethod, campaignId: 0)
        

        MerchantServer.createPayment(merchantPayment, success: { (payment) in
            
            }) { (error) in
            
        }
        
    }
}
