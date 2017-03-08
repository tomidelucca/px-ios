//
//  CardAdditionalStep.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class CardAdditionalViewController: MercadoPagoUIScrollViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bundle : Bundle? = MercadoPago.getBundle()
//    let viewModel : CardAdditionalStepViewModel!
    let viewModel : AdditionalStepViewModel!
    
    
    override open var screenName : String { get{
//        if viewModel.hasPayerCost() {
//            return "PAYER_COST"
//        } else if viewModel.hasPaymentMethod(){
//            return "ISSUER"
//        } else {
//            return "CARD_TYPE"
//        }

        return viewModel.getScreenName()
        } }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        loadMPStyles()
        
        var upperFrame = UIScreen.main.bounds
        upperFrame.origin.y = -upperFrame.size.height;
        let upperView = UIView(frame: upperFrame)
        upperView.backgroundColor = UIColor.primaryColor()
        tableView.addSubview(upperView)
        
        self.showNavBar()
        loadCells()
    }
    
    func loadCells() {
        let titleNib = UINib(nibName: "PayerCostTitleTableViewCell", bundle: self.bundle)
        self.tableView.register(titleNib, forCellReuseIdentifier: "titleNib")
        let cardNib = UINib(nibName: "PayerCostCardTableViewCell", bundle: self.bundle)
        self.tableView.register(cardNib, forCellReuseIdentifier: "cardNib")
//        let bodyCell = UINib(nibName: viewModel.getCellName(), bundle: self.bundle)
//        self.tableView.register(bodyCell, forCellReuseIdentifier: "bodyCell")

        
        let totalRowNib = UINib(nibName: "TotalPayerCostRowTableViewCell", bundle: self.bundle)
        self.tableView.register(totalRowNib, forCellReuseIdentifier: "totalRowNib")

        
//        let rowInstallmentNib = UINib(nibName: "PayerCostRowTableViewCell", bundle: self.bundle)
//        self.tableView.register(rowInstallmentNib, forCellReuseIdentifier: "rowInstallmentNib")
//        let rowIssuerNib = UINib(nibName: "IssuerRowTableViewCell", bundle: self.bundle)
//        self.tableView.register(rowIssuerNib, forCellReuseIdentifier: "rowIssuerNib")
//        let cardTypeNib = UINib(nibName: "CardTypeTableViewCell", bundle: self.bundle)
//        self.tableView.register(cardTypeNib, forCellReuseIdentifier: "cardTypeNib")
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavBar()
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = ""
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.titleCellHeight = 44
        
    }
    
    override func loadMPStyles(){
        if self.navigationController != nil {
            self.navigationController!.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.navigationBar.tintColor = UIColor(red: 255, green: 255, blue: 255)
            self.navigationController?.navigationBar.barTintColor = UIColor.primaryColor()
            self.navigationController?.navigationBar.removeBottomLine()
            self.navigationController?.navigationBar.isTranslucent = false
            
            displayBackButton()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(viewModel : AdditionalStepViewModel, callback: @escaping ((_ callbackData: NSObject?)-> Void)) {
        self.viewModel = viewModel
        self.viewModel.callback = callback
        super.init(nibName: "CardAdditionalViewController", bundle: self.bundle)
    }
    
//    public init(viewModel : CardAdditionalStepViewModel, collectPayerCostCallback: @escaping ((_ payerCost: PayerCost?)->Void) ) {
//        self.viewModel = viewModel
//        self.viewModel.callbackPayerCost = collectPayerCostCallback
//        super.init(nibName: "CardAdditionalViewController", bundle: self.bundle)
//    }
//    
//    public init(viewModel : CardAdditionalStepViewModel, collectPaymentMethodCallback: @escaping ((_ paymentMethod: PaymentMethod?)->Void) ) {
//        self.viewModel = viewModel
//        self.viewModel.callbackPaymentMethod = collectPaymentMethodCallback
//        super.init(nibName: "CardAdditionalViewController", bundle: self.bundle)
//    }
//    
//    public init(viewModel : CardAdditionalStepViewModel,  collectIssuerCallback: @escaping ((_ issuer: Issuer?)->Void) ) {
//        self.viewModel = viewModel
//        self.viewModel.callbackIssuer = collectIssuerCallback
//        super.init(nibName: "CardAdditionalViewController", bundle: self.bundle)
//    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return self.titleCellHeight
        case 1:
            return self.viewModel.getCardSectionCellHeight()
        case 2:
            return self.viewModel.getBodyCellHeight(row: indexPath.row)
            
        default:
            return 60
        }
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.showCardSection() == false{
            if section == 0{
                return 1
            }else if section == 1{
                return 0
            }else{
                return self.viewModel.numberOfCellsInBody()
            }
        } else{
            if (section == 0 || section == 1){
                return 1
            } else {
                return self.viewModel.numberOfCellsInBody()
            }
        }
        
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleNib", for: indexPath as IndexPath) as! PayerCostTitleTableViewCell
            titleCell.selectionStyle = .none
            titleCell.setTitle(string: self.getNavigationBarTitle())
            titleCell.backgroundColor = UIColor.primaryColor()
            self.titleCell = titleCell
            
            return titleCell
            
        } else if (indexPath.section == 1){
            if viewModel.showCardSection(){
                let cellView = viewModel.getCardSectionView()
                
                let cardSectionCell = tableView.dequeueReusableCell(withIdentifier: "cardNib", for: indexPath as IndexPath) as! PayerCostCardTableViewCell
                cardSectionCell.loadCellView(View: cellView)
                cardSectionCell.selectionStyle = .none
                cardSectionCell.updateCardSkin(token: self.viewModel.token, paymentMethod: self.viewModel.paymentMethods[0])
                cardSectionCell.backgroundColor = UIColor.primaryColor()
                
                return cardSectionCell
            
            }else{
                let cellView = viewModel.getCardSectionView()
                let cardSectionCell = tableView.dequeueReusableCell(withIdentifier: "cardNib", for: indexPath as IndexPath) as! PayerCostCardTableViewCell
                cardSectionCell.loadCellView(View: nil)
                cardSectionCell.selectionStyle = .none
                cardSectionCell.updateCardSkin(token: self.viewModel.token, paymentMethod: self.viewModel.paymentMethods[0])
                cardSectionCell.backgroundColor = UIColor.primaryColor()
                return cardSectionCell
            }
            
            
        } else {
            
//            if cellWidth != nil && cellMaxY != nil{
//                let cell = self.viewModel.dataSource[indexPath.row].getCell(width: Double(cellWidth!), y: Float(cellMaxY!))
//                return cell
//            }

            if self.viewModel.showTotalRow(){
                if indexPath.row == 0 {
                    let totalCell = tableView.dequeueReusableCell(withIdentifier: "totalRowNib", for: indexPath as IndexPath) as! TotalPayerCostRowTableViewCell
                    totalCell.fillCell(total: self.viewModel.amount)
                    return totalCell as UITableViewCell
                } else{
                    let cell = self.viewModel.dataSource[indexPath.row-1].getCell()
                    //let cell = self.viewModel.getCell(dataSource: dataSource[indexPath.row-1])
                    return cell
                }
            } else{
            
                let cell = self.viewModel.dataSource[indexPath.row].getCell()
                return cell
            }
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if (indexPath.section == 2){
            if self.viewModel.showTotalRow(){
                if indexPath.row != 0{
                    let callbackData: NSObject = self.viewModel.dataSource[indexPath.row - 1] as! NSObject
                    self.showLoading()
                    self.viewModel.callback!(callbackData)
                }
            } else{
                let callbackData: NSObject = self.viewModel.dataSource[indexPath.row] as! NSObject
                self.viewModel.callback!(callbackData)
            }
//            if self.viewModel.hasPayerCost(){
//                if indexPath.row != 0 {
//                    let payerCost : PayerCost = self.viewModel.payerCosts![(indexPath as NSIndexPath).row - 1]
//                    self.showLoading()
//                    self.viewModel.callbackPayerCost!(payerCost)
//                }
//            } else if self.viewModel.hasPaymentMethod(){
//                let issuer : Issuer = self.viewModel.issuersList![(indexPath as NSIndexPath).row]
//                self.showLoading()
//                self.viewModel.callbackIssuer!(issuer)
//            } else {
//                let paymentMethod : PaymentMethod = self.viewModel.paymentMethods[(indexPath as NSIndexPath).row]
//                self.showLoading()
//                self.viewModel.callbackPaymentMethod!(paymentMethod)
//            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        self.didScrollInTable(scrollView)
        let visibleIndexPaths = tableView.indexPathsForVisibleRows!
        for index in visibleIndexPaths {
            if index.section == 1  {
                if let card = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PayerCostCardTableViewCell{
                    if tableView.contentOffset.y > 0{
                        if 44/tableView.contentOffset.y < 0.265 && !scrollingDown{
                            card.fadeCard()
                        } else{
                            card.cellView.alpha = 44/tableView.contentOffset.y;
                        }
                    }
                }
            }
        }
        
    }
    
    override func getNavigationBarTitle() -> String {
        return self.viewModel.getTitle()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideLoading()
    }
    
}
open class CardAdditionalStepViewModel : NSObject {
    
    var payerCosts : [PayerCost]?
    var installment : Installment?
    var paymentMethods : [PaymentMethod]
    var token : CardInformationForm?
    var issuer: Issuer?
    var amount: Double!
    var paymentPreference: PaymentPreference?
    var issuersList:[Issuer]?
    var cardInformation : CardInformation?
    var callback : ((_ result: NSObject?) -> Void)?
    
    var callbackIssuer : ((_ issuer: Issuer?) -> Void)?
    var callbackPayerCost : ((_ payerCost: PayerCost?) -> Void)?
    var callbackPaymentMethod : ((_ paymentMethod: PaymentMethod?) -> Void)?
    
    init(cardInformation : CardInformation? = nil, paymentMethods : [PaymentMethod] ,issuer : Issuer?, token : CardInformationForm?, amount: Double?, paymentPreference: PaymentPreference?,installment: Installment?, issuersList: [Issuer]?, callback: ((_ payerCost: NSObject?)->Void)? ){
        self.paymentMethods = paymentMethods
        self.payerCosts = installment?.payerCosts
        self.installment = installment
        self.token = token
        self.amount = amount
        self.issuer = issuer
        self.paymentPreference = paymentPreference
        self.cardInformation = cardInformation
        self.issuersList = issuersList
        self.callback = callback
    }
    
    func numberOfCellsInBody() -> Int{
        if hasPayerCost() {
            if let maxInstallmentsAccepted = self.installment?.numberOfPayerCostToShow(self.paymentPreference?.maxAcceptedInstallments) {
                return maxInstallmentsAccepted + 1
            }
            return  0
            
        } else if hasPaymentMethod() {
            return (issuersList?.count) ?? 0
            
        } else {
            return paymentMethods.count
        }
    }
    
    func getTitle() -> String{
        if hasPayerCost() {
            return "¿En cuántas cuotas?".localized
        } else if hasPaymentMethod(){
            return "¿Quién emitió tu tarjeta?".localized
        } else {
            return "¿Qué tipo de tarjeta es?".localized
        }
    }
    func hasPayerCost()-> Bool{
        if (self.cardInformation != nil) {
            return !self.cardInformation!.isIssuerRequired()
        }
        return (issuer != nil || (token != nil && !token!.isIssuerRequired()))
    }
    func hasPaymentMethod()->Bool{
        if (paymentMethods.count)>1{
            return false
        } else {
            return true
        }
    }
    func getCardCellHeight() -> CGFloat {
        return UIScreen.main.bounds.width*0.50
    }
    func getRowCellHeight(row: Int) -> CGFloat {
        if hasPayerCost() {
            if row == 0 {
                return 42
            } else {
                return 60
            }
        } else {
            return 80
        }
    }
    
}
