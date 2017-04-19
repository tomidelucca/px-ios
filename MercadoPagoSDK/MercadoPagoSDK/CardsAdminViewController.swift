//
//  CardsAdminViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class CardsAdminViewController: MercadoPagoUIScrollViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionSearch: UICollectionView!
    
    override open var screenName : String { get { return "CARDS_ADMIN" } }
    
    static let VIEW_CONTROLLER_NIB_NAME : String = "CardsAdminViewController"
    
    
    var merchantBaseUrl : String!
    var merchantAccessToken : String!
    var publicKey : String!
    var currency : Currency!
    var defaultInstallments : Int?
    var installments : Int?
    var viewModel : CardsAdminViewModel!
    
    var bundle = MercadoPago.getBundle()
    
    var titleSectionReference : PaymentVaultTitleCollectionViewCell!
    
    fileprivate var tintColor = true

    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var defaultOptionSelected = false;
    
    fileprivate var callback : ((_ selectedCard : Card? ) -> Void)!

    
    init(viewModel : CardsAdminViewModel, callback : @escaping (_ selectedCard : Card?) -> Void) {
        super.init(nibName: CardsAdminViewController.VIEW_CONTROLLER_NIB_NAME, bundle: bundle)
        self.initCommon()
        self.viewModel = viewModel
        self.callback = callback
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initCommon(){
        
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()
        self.currency = MercadoPagoContext.getCurrency()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavBar()
        if let button = self.navigationItem.leftBarButtonItem{
            self.navigationItem.leftBarButtonItem!.action = #selector(invokeCallbackCancelShowingNavBar)
        }
        
        self.navigationController!.navigationBar.shadowImage = nil
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
       // self.showLoading()
        
        var upperFrame = self.collectionSearch.bounds
        upperFrame.origin.y = -upperFrame.size.height + 10;
        upperFrame.size.width = UIScreen.main.bounds.width
        let upperView = UIView(frame: upperFrame)
        upperView.backgroundColor = UIColor.primaryColor()
        collectionSearch.addSubview(upperView)
        
        if self.title == nil || self.title!.isEmpty {
            self.title = self.viewModel.titleScreen
        }
        
        self.registerAllCells()
        
        if callbackCancel == nil {
            self.callbackCancel = {(Void) -> Void in
                if self.navigationController?.viewControllers[0] == self {
                    self.dismiss(animated: true, completion: {
                        
                    })
                } else {
                    self.navigationController!.popViewController(animated: true)
                }
            }
        } else {
            self.callbackCancel = callbackCancel
        }
        self.collectionSearch.backgroundColor = UIColor.px_white()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionSearch.allowsSelection = true
        self.getCustomerCards()
        self.hideNavBarCallback = self.hideNavBarCallbackDisplayTitle()
    }

    fileprivate func registerAllCells(){
        let collectionSearchCell = UINib(nibName: "PaymentSearchCollectionViewCell", bundle: self.bundle)
        self.collectionSearch.register(collectionSearchCell, forCellWithReuseIdentifier: "searchCollectionCell")
        let paymentVaultTitleCollectionViewCell = UINib(nibName: "PaymentVaultTitleCollectionViewCell", bundle: self.bundle)
        self.collectionSearch.register(paymentVaultTitleCollectionViewCell, forCellWithReuseIdentifier: "paymentVaultTitleCollectionViewCell")
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
       return self.viewModel.numberOfSections()
    }

    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.viewModel.isCardsSection(section: indexPath.section) {
            collectionView.deselectItem(at: indexPath, animated: true)
            if let cards = self.viewModel.cards , let callback = self.callback {
                if cards.count > indexPath.row {
                    let card = cards[indexPath.row]
                    callback(card)
                }else {
                    callback(nil)
                }
            }else{
                callback(nil)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section: section)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionCell",
                                                      
                                                      for: indexPath) as! PaymentSearchCollectionViewCell
        
        if self.viewModel.isHeaderSection(section: indexPath.section) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentVaultTitleCollectionViewCell",
                                                          
                                                          for: indexPath) as! PaymentVaultTitleCollectionViewCell
             cell.title.text = self.viewModel.titleScreen
            self.titleSectionReference = cell
            titleCell = cell
            return cell
        }else if self.viewModel.isCardItemFor(indexPath: indexPath){
            cell.fillCell(drawablePaymentOption: self.viewModel.cards![indexPath.row])
        }else if self.viewModel.isExtraOptionItemFor(indexPath: indexPath){
            cell.fillCell(optionText:self.viewModel.extraOptionTitle!)
        }else {
            if let extraOptionTitle = self.viewModel.extraOptionTitle {
                cell.fillCell(optionText:extraOptionTitle)
            }
        }

        return cell
        
    }

    
    override func scrollPositionToShowNavBar () -> CGFloat {
        return titleCellHeight - navBarHeigth - statusBarHeigth
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    

    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        self.didScrollInTable(scrollView)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    fileprivate func getCustomerCards(){
        if self.viewModel!.shouldGetCustomerCardsInfo() {
            self.showLoading()
            MerchantServer.getCustomer({ (customer: Customer) -> Void in
                 self.hideLoading()
                self.viewModel.customerId = customer._id
                self.viewModel.cards = customer.cards
                self.collectionSearch.delegate = self
                self.collectionSearch.dataSource = self
                self.viewModel.loadingCards = false
                self.collectionSearch.reloadData()
            }, failure: { (error: NSError?) -> Void in
                 self.hideLoading()
            })
        }
    }

    fileprivate func hideNavBarCallbackDisplayTitle() -> ((Void) -> (Void)) {
        return { Void -> (Void) in
            if self.titleSectionReference != nil {
                self.titleSectionReference.fillCell()
                self.titleSectionReference.title.text = self.viewModel.titleScreen
            }
        }
    }
    
    override func getNavigationBarTitle() -> String {
        if self.titleSectionReference != nil {
            self.titleSectionReference.title.text = ""
        }
        return self.viewModel.titleScreen
    }
    
}


class CardsAdminViewModel : NSObject {
    
    var cards : [Card]?
    var customerId : String?
    var extraOptionTitle : String?
    var titleScreen = "¿Con qué tarjeta?".localized
    var loadingCards = true
    
    init(cards : [Card]? = nil,  extraOptionTitle : String? = nil){
        self.cards = cards
        self.extraOptionTitle = extraOptionTitle
    }
    
    func shouldGetCustomerCardsInfo() -> Bool {
        return cards == nil
    }
    
    func numberOfOptions() -> Int {
        if let _ = self.extraOptionTitle {
            if let cards = cards{
                return cards.count + 1
            }else{
                return 1
            }
        }else{
            if let cards = cards{
                return cards.count
            }else{
                return 0
            }
        }
    }
    
    func setTitle(title : String){
        self.titleScreen = title
    }
    


    func calculateHeight(indexPath : IndexPath, numberOfCells : Int) -> CGFloat {
        if numberOfCells == 0 {
            return 0
        }
        
        let section : Int
        let row = indexPath.row
        if row % 2 == 1{
            section = (row - 1) / 2
        }else{
            section = row / 2
        }
        let index1 = (section  * 2)
        let index2 = (section  * 2) + 1
        
        if index1 + 1 > numberOfCells {
            return 0
        }
        
        let height1 = heightOfItem(indexItem: index1)
        
        if index2 + 1 > numberOfCells {
            return height1
        }
        
        let height2 = heightOfItem(indexItem: index2)
        
        
        return height1 > height2 ? height1 : height2
        
    }
    
    func isHeaderSection(section: Int) -> Bool {
        return section == 0
    }
    func isCardsSection(section: Int) -> Bool {
        
        return section == 1
    }
    fileprivate let itemsPerRow: CGFloat = 2
    
    var sectionHeight : CGSize?
    
    func maxHegithRow(indexPath: IndexPath) -> CGFloat{
        guard let cards = self.cards else {
            return 0
        }
        return self.calculateHeight(indexPath: indexPath, numberOfCells: cards.count)
    }
    
    
    func heightOfItem(indexItem : Int) -> CGFloat {
        guard let cards = self.cards else {
            return 0
        }
        return PaymentSearchCollectionViewCell.totalHeight(drawablePaymentOption : cards[indexItem])
    }
    func numberOfSections() -> Int {
        if self.loadingCards {
            return 0
        }
        return 2
    }
    
    public func numberOfItemsInSection (section: Int) -> Int {
        if (self.loadingCards) {
            return 0
        }
        if (self.isHeaderSection(section: section)){
            return 1
        }
        return self.numberOfOptions()
        
    }
    
    
    public func sizeForItemAt (indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = CGFloat(32.0)
        let screenSize : CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let availableWidth = screenWidth - paddingSpace
        
        let titleCellHeight : CGFloat = 82.0
        if self.isHeaderSection(section: indexPath.section) {
            return CGSize(width : screenWidth, height : titleCellHeight)
        }
        let widthPerItem = availableWidth / self.itemsPerRow
        return CGSize(width: widthPerItem, height: self.maxHegithRow(indexPath:indexPath)  )
    }

    func isCardItemFor(indexPath: IndexPath) -> Bool{
        guard let cards = cards else{
            return false
        }
        if !self.isCardsSection(section: indexPath.section){
            return false
        }else if cards.count > indexPath.row {
            return true
        }else{
            return false
        }
    }
    
    func isExtraOptionItemFor(indexPath: IndexPath) -> Bool{
        guard let cards = cards else{
            return ( (self.isCardsSection(section: indexPath.section)) && (self.extraOptionTitle != nil) )
        }
        
        if !self.isCardsSection(section: indexPath.section){
            return false
        }else if cards.count > indexPath.row {
            return false
        }else{
            return (self.extraOptionTitle != nil)
        }
    }
    
}

