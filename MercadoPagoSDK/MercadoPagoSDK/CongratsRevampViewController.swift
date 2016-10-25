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
    let paymentStatus = "approved"
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
        return 200
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerNib", for: indexPath as IndexPath) as! HeaderCongratsTableViewCell
        
        
        headerCell.fillCell(paymentStatus: paymentStatus, color: color)
        return headerCell
        
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
