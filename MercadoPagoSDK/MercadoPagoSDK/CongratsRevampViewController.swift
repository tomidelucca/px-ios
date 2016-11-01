//
//  CongratsRevampViewController.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/25/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class CongratsRevampViewController: MercadoPagoUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var bundle = MercadoPago.getBundle()
    var color: UIColor!
    var payment: Payment!
    var paymentMethod: PaymentMethod?
    var callback: ((_ payment : Payment, _ status : MPStepBuilder.CongratsState) -> Void)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60
        self.tableView.separatorStyle = .none
        
        self.color = self.getColor(payment: payment!)
        
        var frame = self.tableView.bounds
        frame.origin.y = -frame.size.height;
        let view = UIView(frame: frame)
        view.backgroundColor = self.color
        tableView.addSubview(view)
        
        let headerNib = UINib(nibName: "HeaderCongratsTableViewCell", bundle: self.bundle)
        self.tableView.register(headerNib, forCellReuseIdentifier: "headerNib")
        let emailNib = UINib(nibName: "ConfirmEmailTableViewCell", bundle: self.bundle)
        self.tableView.register(emailNib, forCellReuseIdentifier: "emailNib")
        let approvedNib = UINib(nibName: "ApprovedTableViewCell", bundle: self.bundle)
        self.tableView.register(approvedNib, forCellReuseIdentifier: "approvedNib")
        let rejectedNib = UINib(nibName: "RejectedTableViewCell", bundle: self.bundle)
        self.tableView.register(rejectedNib, forCellReuseIdentifier: "rejectedNib")
        let callFAuthNib = UINib(nibName: "CallForAuthTableViewCell", bundle: self.bundle)
        self.tableView.register(callFAuthNib, forCellReuseIdentifier: "callFAuthNib")
        let footerNib = UINib(nibName: "FooterTableViewCell", bundle: self.bundle)
        self.tableView.register(footerNib, forCellReuseIdentifier: "footerNib")
        
        
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil && self.navigationController?.navigationBar != nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            ViewUtils.addStatusBar(self.view, color: self.color)
        }
        
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    init(payment: Payment?, paymentMethod : PaymentMethod?, callback : @escaping (_ payment : Payment, _ status : MPStepBuilder.CongratsState) -> Void){
        self.payment = payment
        self.paymentMethod = paymentMethod
        self.callback = callback
        super.init(nibName: "CongratsRevampViewController", bundle : bundle)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideNavBar(){
        self.title = ""
        navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            if payment.status == "approved" || callForAuth() {
                return 2
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func getColor(payment: Payment)->UIColor{
        if payment.status == "approved" {
            return UIColor(red: 59, green: 194, blue: 128)
        } else if payment.status == "in_process" {
            return UIColor(red: 255, green: 161, blue: 90)
        } else if callForAuth() {
            return UIColor(red: 58, green: 184, blue: 239)
        } else if payment.status == "rejected"{
            return UIColor(red: 255, green: 89, blue: 89)
        }
        return UIColor()
    }
    func callForAuth() ->Bool{
        if payment.statusDetail == "cc_rejected_call_for_authorize"{
            return true
        } else {
            return false
        }
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerNib") as! HeaderCongratsTableViewCell
            headerCell.fillCell(payment: payment!, paymentMethod: paymentMethod!, color: color)
            headerCell.selectionStyle = .none
            return headerCell
        } else if indexPath.section == 1 {
            if payment.status == "approved"{
                if indexPath.row == 0{
                    let approvedCell = self.tableView.dequeueReusableCell(withIdentifier: "approvedNib") as! ApprovedTableViewCell
                    approvedCell.selectionStyle = .none
                    approvedCell.fillCell(payment: payment! )
                    approvedCell.addSeparatorLineToTop(width: Double(UIScreen.main.bounds.width), y: Int(390))
                    
                    return approvedCell
                }
                else {
                    let confirmEmailCell = self.tableView.dequeueReusableCell(withIdentifier: "emailNib") as! ConfirmEmailTableViewCell
                    confirmEmailCell.fillCell(payment: payment!)
                    confirmEmailCell.selectionStyle = .none
                    confirmEmailCell.addSeparatorLineToTop(width: Double(UIScreen.main.bounds.width), y: Int(60))
                    
                    return confirmEmailCell
                }
            } else if callForAuth(){
                if indexPath.row == 0{
                    let callFAuthCell = self.tableView.dequeueReusableCell(withIdentifier: "callFAuthNib") as! CallForAuthTableViewCell
                    callFAuthCell.selectionStyle = .none
                    callFAuthCell.addSeparatorLineToTop(width: Double(UIScreen.main.bounds.width), y: Int(callFAuthCell.contentView.bounds.maxY))
                    return callFAuthCell
                }
                else {
                    let rejectedCell = self.tableView.dequeueReusableCell(withIdentifier: "rejectedNib") as! RejectedTableViewCell
                    rejectedCell.setCallback(callback: callback)
                    rejectedCell.selectionStyle = .none
                    rejectedCell.fillCell(payment: payment)
                    return rejectedCell
                }
                
            } else if payment.status == "in_process"{
                let pendingCell = self.tableView.dequeueReusableCell(withIdentifier: "rejectedNib") as! RejectedTableViewCell
                pendingCell.awakeFromNib()
                pendingCell.selectionStyle = .none
                pendingCell.fillCell(payment: payment)
                return pendingCell
            } else {
                let rejectedCell = self.tableView.dequeueReusableCell(withIdentifier: "rejectedNib") as! RejectedTableViewCell
                rejectedCell.selectionStyle = .none
                rejectedCell.fillCell(payment: payment!)
                return rejectedCell
                
            }
        } else {
            let footerNib = self.tableView.dequeueReusableCell(withIdentifier: "footerNib") as! FooterTableViewCell
            footerNib.selectionStyle = .none
            return footerNib
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            callback(payment, MPStepBuilder.CongratsState.ok)
        }
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
