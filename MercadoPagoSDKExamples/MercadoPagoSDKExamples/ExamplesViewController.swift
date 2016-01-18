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
    "step5_title".localized, "step6_title".localized, "step7_title".localized, "step8_title".localized]
    
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

        switch indexPath.row {
        case 0:
            self.showViewController(MercadoPago.startPaymentMethodsViewController(PaymentType.allPaymentIDs, callback: { (paymentMethod: PaymentMethod) -> Void in
                self.showViewController(ExamplesUtils.startCardActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, paymentMethod: paymentMethod, callback: {(token: Token?) -> Void in
                    self.createPayment(token!._id, paymentMethod: paymentMethod, installments: 1, cardIssuer: nil, discount: nil)
                }))}))
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
            self.showViewController(MercadoPago.startVaultViewController(ExamplesUtils.AMOUNT, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: String?, issuer: Issuer?, installments: Int) -> Void in
                    self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
            }))
            
          
         
		case 5:
			self.showViewController(MercadoPago.startVaultViewController(ExamplesUtils.AMOUNT, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: {(paymentMethod: PaymentMethod, token: String?, issuer: Issuer?, installments: Int) -> Void in
				self.createPayment(token, paymentMethod: paymentMethod, installments: installments, cardIssuer: issuer, discount: nil)
			}))
		case 6:
			//self.showViewController(MercadoPago.startPromosViewController())
            self.showViewController(MPFlowBuilder.startVaultViewController(1000.0, supportedPaymentTypes: PaymentType.allPaymentIDs, callback: { (paymentMethod, tokenId, issuerId, installments) -> Void in
                print("do something")
            }))
        case 7:
            self.showViewController(MPFlowBuilder.starCheckoutViewController(ExamplesUtils.createCheckoutPreference(), callback: { (payment:Payment, paymentMethod : PaymentMethod) -> Void in
                self.showViewController(MPStepBuilder.startCongratsStep(payment, paymentMethod: paymentMethod))
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
                self.showViewController(MercadoPago.startCongratsViewController(payment, paymentMethod: paymentMethod))
            })
        } else {
            print("no tengo token")
        }
    }
	
	func showViewController(vc: UIViewController) {
		if #available(iOS 8.0, *) {
			self.showViewController(vc, sender: self)
		} else {
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
    func getDiscount() {
        
    }

}
