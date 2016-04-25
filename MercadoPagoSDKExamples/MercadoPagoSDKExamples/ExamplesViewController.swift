//
//  ExamplesViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class ExamplesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var tableview : UITableView!
	
    let examples : [String] = ["step1_title".localized, "step2_title".localized, "step3_title".localized, "step4_title".localized,
    "step5_title".localized, "step6_title".localized, "step7_title".localized, "step8_title".localized, "step9_title".localized, "step10_title".localized, "step11_title".localized, "step12_title".localized, "step13_title".localized]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: "ExamplesViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.translucent = false
        self.title = "MercadoPago SDK"
        self.tableview.delegate = self
        self.tableview.dataSource = self

      

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: examples[indexPath.row])
        cell.textLabel!.text = examples[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType(rawValue: UITableViewCellAccessoryType.DetailDisclosureButton.rawValue)!
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var settings = PaymentSettings(currencyId: "MXN", purchaseTitle : "purchaseTitle")
        
        switch indexPath.row {
        case 0:
            
            
            
            
            /*
            self.showViewController( MPStepBuilder.startCreditCardForm(nil , amount: 10000, callback: { (paymentMethod, token, issuer, installment) -> Void in

                self.showViewController(MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, cardToken: token!, amount: 1550, minInstallments: 1, callback: { (installment) -> Void in
                    print("OK!")
                }))
            }))
*/
            
            self.presentNavigation(MPFlowBuilder.startCardFlow(PaymentType(paymentTypeId: PaymentTypeId.CREDIT_CARD).paymentSettingAssociated().addSettings(maxAcceptedInstalment:9).addSettings(defaultInstalment:3) , amount: 10000, callback: { (paymentMethod, cardToken, issuer, payerCost) -> Void in
                print("OK!!")
            }))

        case 1:
            self.showViewController(ExamplesUtils.startSimpleVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: Token?) -> Void in
                    self.createPayment(token!._id, paymentMethod: paymentMethod, installments: 1, cardIssuer: nil, discount: nil)
            } ))
            
        case 2:
            self.showViewController(ExamplesUtils.startAdvancedVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, amount: ExamplesUtils.AMOUNT, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: String?, issuer: Issuer?, installments: Int) -> Void in
                self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
            }))
        case 3:
            self.showViewController(ExamplesUtils.startFinalVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, merchantBaseUrl: ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: ExamplesUtils.MERCHANT_MOCK_GET_CUSTOMER_URI, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN, amount: ExamplesUtils.AMOUNT, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: String?, issuer: Issuer?, installments: Int) -> Void in
                self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
            }))
        case 4:
            self.showViewController(MPFlowBuilder.startVaultViewController(ExamplesUtils.AMOUNT, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: String?, issuer: Issuer?, installments: Int) -> Void in
                    self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
            }))
		case 5:
			self.showViewController(MPFlowBuilder.startVaultViewController(ExamplesUtils.AMOUNT, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: String?, issuer: Issuer?, installments: Int) -> Void in
				self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
			}))
		case 6:
            self.showViewController(MPFlowBuilder.startVaultViewController(1000.0, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: { (paymentMethod, tokenId, issuerId, installments) -> Void in
                print("do something")
            }))
        case 7:
            self.presentNavigation(MPFlowBuilder.startCheckoutViewController(ExamplesUtils.createCheckoutPreferenceWithNoExclusions(), callback: { (payment:Payment) -> Void in
                
            }))
        case 8:
            
            self.presentNavigation(MPFlowBuilder.startPaymentVaultViewController(1.00,paymentSettings: settings , callback: { (paymentMethod, tokenId, issuer, installments) -> Void in
            }))
        case 9:
            self.presentNavigation(MPFlowBuilder.startCheckoutViewController(ExamplesUtils.createCheckoutPreference(), callback: { (MerchantPayment) -> Void in
                
            }))
        case 10:
            let excludedPaymentMethods = ["gestopago"]
            
            self.presentNavigation(MPFlowBuilder.startPaymentVaultViewController(1.00, paymentSettings: settings, callback: { (paymentMethod, tokenId, issuer, installments) -> Void in
				//   self.createPayment(tokenId, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
            }))
        case 11:
            let excludedPaymentMethods = ["serfin_ticket, banamex_ticket, bancomer_ticket", "7eleven", "telecomm", "gestopago"]
            let excludedPaymentTypes = Set([PaymentTypeId.BANK_TRANSFER, PaymentTypeId.DEBIT_CARD, PaymentTypeId.ACCOUNT_MONEY, PaymentTypeId.BITCOIN, PaymentTypeId.TICKET, PaymentTypeId.PREPAID_CARD])
            
            self.presentNavigation(MPFlowBuilder.startPaymentVaultViewController(1.00, paymentSettings: settings, callback: { (paymentMethod, tokenId, issuer, installments) -> Void in
                
            }))
        case 12:
            let excludedPaymentMethods = ["bancomer_bank_transfer", "banamex_bank_transfer"]
            let excludedPaymentTypes = Set([PaymentTypeId.CREDIT_CARD, PaymentTypeId.DEBIT_CARD, PaymentTypeId.ACCOUNT_MONEY, PaymentTypeId.BITCOIN, PaymentTypeId.TICKET, PaymentTypeId.PREPAID_CARD])
            
            let preference = ExamplesUtils.createCheckoutPreference()
        //    preference.paymentMethods?.excludedPaymentMethods = excludedPaymentMethods
        //    preference.paymentMethods!.excludedPaymentTypes = excludedPaymentTypes

            
            self.presentNavigation(MPFlowBuilder.startCheckoutViewController(preference, callback: { (payment) -> Void in

            }))
        default:
            print("Otra opcion")
        }
    }
	
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let message : String = "step\(indexPath.row+1)_description".localized

        let alert = UIAlertView()
        alert.title = "Información".localized
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()

    }

    func createPayment(token: String?, paymentMethod: PaymentMethod, installments: Int, cardIssuer: Issuer?, discount: Discount?) {
        if token != nil {
            ExamplesUtils.createPayment(token!, installments: installments, cardIssuer: cardIssuer, paymentMethod: paymentMethod, callback: { (payment: Payment) -> Void in
                self.showViewController(MPStepBuilder.startCongratsStep(payment, paymentMethod: paymentMethod))
            })
        } else {
            print("no tengo token")
        }
    }
	
	func showViewController(vc: UIViewController) {
		if #available(iOS 8.0, *) {
			self.showViewController(vc, sender: self)
		} else {
            vc.navigationController!.pushViewController(vc, animated: false)
		}
        
	}
    
    func presentNavigation(vc: UINavigationController) {
        self.presentViewController(vc, animated: true) { () -> Void in
        
        }
    }
	
    func getDiscount() {
        
    }

}
