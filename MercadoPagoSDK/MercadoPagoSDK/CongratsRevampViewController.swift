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
    let paymentStatus = "rejected"
    var color:UIColor!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        super.init(nibName: "CongratsRevampViewController", bundle : bundle)
        self.color = getColor(paymentStatus: paymentStatus)
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
        if indexPath.section == 0{
            if paymentStatus == "approved"{
            return UIScreen.main.bounds.height*0.33
            }
            else {
              return UIScreen.main.bounds.height*0.40
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0{
                return 420
            } else {
                return 60
            }
        }
        else {
            return 80
        }
    }
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 2
        } else {
            return 1
        }
    }
    
    func getColor(paymentStatus:String)->UIColor{
        if paymentStatus == "approved" {
            return UIColor(red: 59, green: 194, blue: 128)
        } else if paymentStatus == "pending" {
            return UIColor(red: 255, green: 161, blue: 90)
        } else if paymentStatus == "rejected" {
            return UIColor(red: 255, green: 89, blue: 89)
        }
        return UIColor()
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerNib") as! HeaderCongratsTableViewCell
            headerCell.fillCell(paymentStatus: paymentStatus, color: color)
            headerCell.selectionStyle = .none
            return headerCell
        } else if indexPath.section == 1 {
            if indexPath.row == 0{
                let approvedCell = self.tableView.dequeueReusableCell(withIdentifier: "approvedNib") as! ApprovedTableViewCell
                approvedCell.selectionStyle = .none
                return approvedCell
            }
            else {
                let confirmEmailCell = self.tableView.dequeueReusableCell(withIdentifier: "emailNib") as! ConfirmEmailTableViewCell
                confirmEmailCell.fillCell(string: "Te enviaremos este comprobante a nombre.apellido@correo.com")
                confirmEmailCell.selectionStyle = .none
                return confirmEmailCell
            }
        } else {
            let footerNib = self.tableView.dequeueReusableCell(withIdentifier: "footerNib") as! FooterTableViewCell
            footerNib.selectionStyle = .none
            return footerNib
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
