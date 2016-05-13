//
//  IssuerCardViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 5/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class IssuerCardViewController: MercadoPagoUIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : (( issuer: Issuer) -> Void)?
    
    var cardToken : CardToken?
    var paymentMethod : PaymentMethod?
    var issuerList : [Issuer]?
    var cardFront : CardFrontView?
    let defaultColorText = UIColor(netHex:0x333333)

    
    public init(paymentMethod: PaymentMethod,  cardToken: CardToken , issuerList: [Issuer]? = nil, callback : (( issuer: Issuer) -> Void)) {
        
        super.init(nibName: "IssuerCardViewController", bundle: MercadoPago.getBundle())
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.cardToken = cardToken
        self.callback = callback
        self.paymentMethod = paymentMethod
        self.issuerList = issuerList
        if(issuerList == nil){
            MPServicesBuilder.getIssuers(paymentMethod,bin: cardToken.getBin(), success: { (issuers) -> Void in
                self.issuerList = issuers
                self.tableView.reloadData()
                }) { (error) -> Void in
                    print("error")
            }
        }else{
            self.tableView.reloadData()
        }
        
        
        
    }
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cardView.addSubview(cardFront!)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let issuerNib = UINib(nibName: "IssuerTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(issuerNib, forCellReuseIdentifier: "issuerCell")
        cardFront = CardFrontView(frame: self.cardView.bounds)
        cardFront?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.updateCardSkin()
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
        
        if(self.issuerList == nil){
            return 0
        }else{
            return (issuerList?.count)!
        }
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let issuerCell : IssuerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("issuerCell") as! IssuerTableViewCell
        
        let issuer : Issuer = issuerList![indexPath.row]
        issuerCell.fillWithIssuer(issuer)
        return issuerCell
    }

    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(issuer: self.issuerList![indexPath.row])
    }
    public func updateCardSkin() {
        
        if(self.paymentMethod != nil){
            
            self.cardFront?.cardLogo.image =  MercadoPago.getImageFor(self.paymentMethod!)
            self.cardView.backgroundColor = MercadoPago.getColorFor(self.paymentMethod!)
            self.cardFront?.cardLogo.alpha = 1
            
            
            cardFront?.cardNumber.text = (self.cardToken?.getBin())! as String
            
            cardFront?.cardName.text = self.cardToken?.cardholder!.name
            cardFront?.cardExpirationDate.text = self.cardToken?.getExpirationDateFormated() as? String
            
            cardFront?.cardNumber.textColor =  defaultColorText
            cardFront?.cardName.textColor =  defaultColorText
            cardFront?.cardExpirationDate.textColor =  defaultColorText
            
        }
        
    }

}
