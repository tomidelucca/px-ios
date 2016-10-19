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
    let viewModel : PayerCostViewModel!
    
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
        let rowInstallmentNib = UINib(nibName: "PayerCostRowTableViewCell", bundle: self.bundle)
        self.tableView.register(rowInstallmentNib, forCellReuseIdentifier: "rowInstallmentNib")
        let rowIssuerNib = UINib(nibName: "IssuerRowTableViewCell", bundle: self.bundle)
        self.tableView.register(rowIssuerNib, forCellReuseIdentifier: "rowIssuerNib")
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        //        self.navigationItem.leftBarButtonItem!.action = #selector(invokeCallbackCancel)
        if !self.viewModel.hasIssuer() {
            self.showLoading()
            self.getIssuers()
        } else if self.viewModel.installment == nil {
            self.showLoading()
            self.getInstallments()
        } else {
            self.viewModel.payerCosts = self.viewModel.installment!.payerCosts
        }
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
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(paymentMethod : PaymentMethod ,issuer : Issuer?, token : CardInformationForm?, amount: Double?, paymentPreference: PaymentPreference?,installment: Installment?, callback: ((_ payerCost: NSObject?)->Void)? ){
        
        self.viewModel = PayerCostViewModel(paymentMethod: paymentMethod, issuer: issuer, token: token, amount: nil, paymentPreference: paymentPreference, installment:installment, callback: callback)
        
        super.init(nibName: "PayerCostStepViewController", bundle: self.bundle)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0){
            return 40
            
        } else if (indexPath.section == 1){
            return UIScreen.main.bounds.height*0.27
            
        } else {
            if self.viewModel.hasIssuer(){
                return 100
            } else {
                return 80
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1){
            return 1
        } else {
            return self.viewModel.numberofPayerCost()
        }
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleNib", for: indexPath as IndexPath) as! PayerCostTitleTableViewCell
            titleCell.selectionStyle = .none // Sacar color cuando click
            titleCell.setTitle(string: self.viewModel.getTilte())
            
            return titleCell
            
        } else if (indexPath.section == 1){
            let cardCell = tableView.dequeueReusableCell(withIdentifier: "cardNib", for: indexPath as IndexPath) as! PayerCostCardTableViewCell
            cardCell.selectionStyle = .none // Sacar color cuando click
            cardCell.loadCard()
            cardCell.updateCardSkin(token: self.viewModel.token, paymentMethod: self.viewModel.paymentMethod)
            
            return cardCell
            
        } else {
            if self.viewModel.hasIssuer(){
                let payerCost : PayerCost = self.viewModel.payerCosts![indexPath.row]
                let installmentCell = tableView.dequeueReusableCell(withIdentifier: "rowInstallmentNib", for: indexPath as IndexPath) as! PayerCostRowTableViewCell
                installmentCell.fillCell(payerCost: payerCost)
                installmentCell.addSeparatorLineToTop(width: Double(installmentCell.contentView.frame.width))
                
                return installmentCell
            } else {
                let issuer : Issuer = self.viewModel.issuersList![indexPath.row]
                let issuerCell = tableView.dequeueReusableCell(withIdentifier: "rowIssuerNib", for: indexPath as IndexPath) as! IssuerRowTableViewCell
                issuerCell.fillCell(issuer: issuer, bundle: self.bundle!)
                issuerCell.addSeparatorLineToTop(width: Double(issuerCell.contentView.frame.width))

                return issuerCell
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2){
            if self.viewModel.hasIssuer(){
                let payerCost : PayerCost = self.viewModel.payerCosts![(indexPath as NSIndexPath).row]
                self.viewModel.callback!(payerCost)
            } else{
                let issuer : Issuer = self.viewModel.issuersList![(indexPath as NSIndexPath).row]
                self.viewModel.callback!(issuer)
            }
        }
    }
    
    func showNavBar() {
        self.title = self.viewModel.getTilte()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.isTranslucent = false
        let font : UIFont = UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 22) ?? UIFont.systemFont(ofSize: 22)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.systemFontColor(), NSFontAttributeName: font]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    var once = false
    var lastContentOffset: CGFloat = 0
    var scrollingDown = false
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        var titleVisible = false
        
        let visibleIndexPaths = self.tableView.indexPathsForVisibleRows!
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
                    
                    if (cellRect.origin.y < tableView.contentOffset.y + (UIApplication.shared.statusBarFrame.size.height)){
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
            } else if index.section == 1  {
                let card = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PayerCostCardTableViewCell
                if tableView.contentOffset.y > 0{
                    if 44/tableView.contentOffset.y < 0.265 && !scrollingDown{
                        card.fadeCard()
                    } else{
                        card.cardView.alpha = 44/tableView.contentOffset.y;
                    }
                }
            }
        }
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            scrollingDown = true
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            scrollingDown = false
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
        
    }
    
    fileprivate func getInstallments(){
        let bin = self.viewModel.token?.getCardBin() ?? ""
        MPServicesBuilder.getInstallments(bin, amount: self.viewModel.amount, issuer: self.viewModel.issuer, paymentMethodId: self.viewModel.paymentMethod!._id, success: { (installments) -> Void in
            self.viewModel.installment = installments?[0]
            self.viewModel.payerCosts = installments![0].payerCosts
            //TODO ISSUER
            self.tableView.reloadData()
            self.hideLoading()
        }) { (error) -> Void in
            self.requestFailure(error)
        }
    }
    fileprivate func getIssuers(){
        MPServicesBuilder.getIssuers(self.viewModel.paymentMethod!, bin: self.viewModel.token?.getCardBin(), success: { (issuers) -> Void in
            self.viewModel.issuersList = issuers
            self.hideLoading()
            self.tableView.reloadData()
        }) { (error) -> Void in
            // HANDLE ERROR
        }
    }
    
}
class PayerCostViewModel : NSObject {
    
    var payerCosts : [PayerCost]?
    var installment : Installment?
    var paymentMethod : PaymentMethod?
    var token : CardInformationForm?
    var issuer: Issuer?
    var amount: Double!
    var paymentPreference: PaymentPreference?
    var issuersList:[Issuer]?
    var callback : ((_ payerCost: NSObject?) -> Void)?
    
    init(paymentMethod : PaymentMethod ,issuer : Issuer?, token : CardInformationForm?, amount: Double?, paymentPreference: PaymentPreference?,installment: Installment?, callback: ((_ payerCost: NSObject?)->Void)? ){
        self.paymentMethod = paymentMethod
        self.payerCosts = installment?.payerCosts
        self.installment = installment
        self.token = token
        self.amount = amount
        self.issuer = issuer
        self.paymentPreference = paymentPreference
        self.callback = callback
        //self.callback = callback! as ((PayerCost?) -> Void)
    }
    func numberofPayerCost() -> Int{
        if hasIssuer(){
            return (self.installment?.numberOfPayerCostToShow(self.paymentPreference?.maxAcceptedInstallments))!
        }else {
            return (issuersList?.count) ?? 0
        }
    }
    func getTilte() -> String{
        if hasIssuer() {
            return "¿En cuántas cuotas?"
        } else {
            return "¿Cuál es tu banco?"
        }
    }
    func hasIssuer()-> Bool{
        if issuer == nil{
            return false
        } else {
            return true
        }
    }
    
}
