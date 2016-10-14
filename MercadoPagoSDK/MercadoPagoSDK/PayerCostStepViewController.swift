//
//  PayerCostStepViewController.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class PayerCostStepViewController: MercadoPagoUIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var bundle : Bundle? = MercadoPago.getBundle()
    var payerCosts : [PayerCost]?
    var installment : Installment?
    var paymentMethod : PaymentMethod?
    var token : Token?
    var issuer: Issuer?
    var amount: Double!
    var callback : ((_ payerCost: PayerCost) -> Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none //sacar lineas
        loadMPStyles()
        
        //Vista azul de arriba
        var frame = self.tableView.bounds
        frame.origin.y = -frame.size.height;
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red: 0, green: 158, blue: 227)
        tableView.addSubview(view)
        
        let titleNib = UINib(nibName: "PayerCostTitleTableViewCell", bundle: self.bundle)
        self.tableView.register(titleNib, forCellReuseIdentifier: "titleNib")
        let cardNib = UINib(nibName: "PayerCostCardTableViewCell", bundle: self.bundle)
        self.tableView.register(cardNib, forCellReuseIdentifier: "cardNib")
        let rowNib = UINib(nibName: "PayerCostRowTableViewCell", bundle: self.bundle)
        self.tableView.register(rowNib, forCellReuseIdentifier: "rowNib")

    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func loadMPStyles(){
        if self.navigationController != nil {
            //Navigation bar colors
            
            self.navigationController!.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.navigationBar.tintColor = UIColor(red: 255, green: 255, blue: 255)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 158, blue: 227)
            self.navigationController?.navigationBar.removeBottomLine()
            self.navigationController?.navigationBar.isTranslucent = false
            
            self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow") //saca linea molesta
            displayBackButton()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(paymentMethod : PaymentMethod?,issuer : Issuer?, token : Token?, amount: Double?, paymentPreference: PaymentPreference?,installment: Installment?, callback: (_ payerCost: PayerCost?)->Void? ){
        //self.paymentMethod = paymentMethod
        //self.token = token!
        self.payerCosts = installment?.payerCosts
        self.installment = installment
        
        super.init(nibName: "PayerCostStepViewController", bundle: self.bundle)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0){
            return 40
            
        } else if (indexPath.section == 1){
            return 166
            
        } else {
            return 100
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1){
            return 1
        } else {
            if(self.payerCosts == nil){
                return 0
            } else {
                return (payerCosts?.count)!
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleNib", for: indexPath as IndexPath) as! PayerCostTitleTableViewCell
            titleCell.selectionStyle = .none // Sacar color cuando click
            titleCell.setTitle()
            return titleCell
            
        } else if (indexPath.section == 1){
            let cardCell = tableView.dequeueReusableCell(withIdentifier: "cardNib", for: indexPath as IndexPath) as! PayerCostCardTableViewCell
            cardCell.selectionStyle = .none // Sacar color cuando click
            cardCell.loadCard()
            //cardCell.updateCardSkin(token, paymentMethod: paymentMethod)
            return cardCell
            
        } else {
            let payerCost : PayerCost = payerCosts![indexPath.row]
            let installmentCell = tableView.dequeueReusableCell(withIdentifier: "rowNib", for: indexPath as IndexPath) as! PayerCostRowTableViewCell
            installmentCell.fillCell(payerCost: payerCost)
            drawBottomLine(layer: installmentCell.contentView.layer)
            return installmentCell
        }
    }
    
    func showNavBar() {
        //        let fadeTextAnimation = CATransition()
        //        fadeTextAnimation.duration = 0.5
        //        fadeTextAnimation.type = kCATransitionReveal
        //
        //        navigationController?.navigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText")
        self.title = "¿En cuántas cuotas?"
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.isTranslucent = false
        let font : UIFont = UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 22) ?? UIFont.systemFont(ofSize: 22)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.systemFontColor(), NSFontAttributeName: font]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    var once = false
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        var titleVisible = false
        
        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows! as? [IndexPath] {
            for index in visibleIndexPaths {
                if (index.section == 0){
                    if !once {
                        self.title = ""
                        navigationController?.navigationBar.titleTextAttributes = nil
                        titleVisible = true
                        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                        self.navigationController?.navigationBar.shadowImage = UIImage()
                        self.navigationController?.navigationBar.isTranslucent = true
                        let cellRect = tableView.rectForRow(at: index)
                        
                        if (cellRect.origin.y<tableView.contentOffset.y + (UIApplication.shared.statusBarFrame.size.height)){
                            titleVisible = false
                            once = true
                            showNavBar()
                            
                        }
                    } else {
                        let cellRect = tableView.rectForRow(at: index)
                        if (cellRect.origin.y + 20>=(UIApplication.shared.statusBarFrame.size.height)){
                            once = false
                        }
                    }
                }
            }
        }
        if !titleVisible {

        }
        
    }
    
    func drawBottomLine(layer: CALayer) -> Void{
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height))
        linePath.addLine(to: CGPoint(x: 0, y: layer.bounds.height))
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 0.6
        line.lineWidth = 0.1
        line.strokeColor = UIColor(red: 153, green: 153, blue: 153).cgColor
        layer.addSublayer(line)
    }
    
    fileprivate func getInstallments(){
        let bin = token?.getBin() ?? ""
        MPServicesBuilder.getInstallments(bin, amount: self.amount, issuer: self.issuer, paymentMethodId: self.paymentMethod!._id, success: { (installments) -> Void in
            self.installment = installments?[0]
            self.payerCosts = installments![0].payerCosts
            //TODO ISSUER
            self.tableView.reloadData()
            self.hideLoading()
        }) { (error) -> Void in
            self.requestFailure(error)
        }
    }
}
