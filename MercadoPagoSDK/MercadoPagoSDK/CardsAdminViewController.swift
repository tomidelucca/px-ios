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
    fileprivate var loadingGroups = true
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var defaultOptionSelected = false;
    
    fileprivate var callback : ((_ selectedCard : Card? ) -> Void)!

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initCommon(){
        
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()
        self.currency = MercadoPagoContext.getCurrency()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        
        var upperFrame = self.collectionSearch.bounds
        upperFrame.origin.y = -upperFrame.size.height + 10;
        upperFrame.size.width = UIScreen.main.bounds.width
        let upperView = UIView(frame: upperFrame)
        upperView.backgroundColor = UIColor.primaryColor()
        collectionSearch.addSubview(upperView)
        
        if self.title == nil || self.title!.isEmpty {
            self.title = "¿Cómo quiéres pagar?".localized
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


    fileprivate func registerAllCells(){
        
        let collectionSearchCell = UINib(nibName: "PaymentSearchCollectionViewCell", bundle: self.bundle)
        self.collectionSearch.register(collectionSearchCell, forCellWithReuseIdentifier: "searchCollectionCell")
        
        let paymentVaultTitleCollectionViewCell = UINib(nibName: "PaymentVaultTitleCollectionViewCell", bundle: self.bundle)
        self.collectionSearch.register(paymentVaultTitleCollectionViewCell, forCellWithReuseIdentifier: "paymentVaultTitleCollectionViewCell")

        
    }
    override func getNavigationBarTitle() -> String {
        if self.titleSectionReference != nil {
            self.titleSectionReference.title.text = ""
        }
        return "Administrador de tarjetas".localized
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.loadingGroups {
            return 0
        }
        return 2
    }

    func isHeaderSection(section: Int) -> Bool {
        return section == 0
    }
    func isCardsSection(section: Int) -> Bool {
        
        return section == 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCardsSection(section: indexPath.section) {
            guard let cards = self.viewModel.cards , let callback = self.callback else{
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.allowsSelection = false
            let card = cards[indexPath.row]
            callback(card)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        
        if (loadingGroups) {
            return 0
        }
        
        if (isHeaderSection(section: section)){
            return 1
        }
 
        guard let cards = self.viewModel.cards else{
            return 0
        }
        
        return cards.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionCell",
                                                      
                                                      for: indexPath) as! PaymentSearchCollectionViewCell
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentVaultTitleCollectionViewCell",
                                                          
                                                          for: indexPath) as! PaymentVaultTitleCollectionViewCell
            self.titleSectionReference = cell
            titleCell = cell
            return cell
        } else if isCardsSection(section: indexPath.section){
            guard let card = self.viewModel.cards?[indexPath.row] else {
                return cell
            }
            cell.fillCell(drawablePaymentOption: card)
        }
        return cell
        
    }
    fileprivate let itemsPerRow: CGFloat = 2
    
    var sectionHeight : CGSize?
    
    override func scrollPositionToShowNavBar () -> CGFloat {
        return titleCellHeight - navBarHeigth - statusBarHeigth
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = CGFloat(32.0)
        let availableWidth = view.frame.width - paddingSpace
        
        titleCellHeight = 82
        if isHeaderSection(section: indexPath.section) {
            return CGSize(width : view.frame.width, height : titleCellHeight)
        }
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: maxHegithRow(indexPath:indexPath)  )
    }
    
    
    private func maxHegithRow(indexPath: IndexPath) -> CGFloat{
        guard let cards = self.viewModel.cards else {
            return 0
        }
        return self.calculateHeight(indexPath: indexPath, numberOfCells: cards.count)
    }
    
    private func calculateHeight(indexPath : IndexPath, numberOfCells : Int) -> CGFloat {
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
    
    func heightOfItem(indexItem : Int) -> CGFloat {
        guard let cards = self.viewModel.cards else {
            return 0
        }
        return PaymentSearchCollectionViewCell.totalHeight(drawablePaymentOption : cards[indexItem])
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
    

    
    
}


class CardsAdminViewModel : NSObject {
    
    var cards : [Card]?
    var callback : ((_ paymentMethod: PaymentMethod, _ token:Token?, _ issuer: Issuer?, _ payerCost: PayerCost?) -> Void)!
    var callbackCancel : ((Void) -> Void)? = nil
    
    
    init(cards : [Card]?, callbackCancel : ((Void) -> Void)? = nil, couponCallback: ((DiscountCoupon) -> Void)? = nil){
        self.cards = cards
    }
    
    
}

