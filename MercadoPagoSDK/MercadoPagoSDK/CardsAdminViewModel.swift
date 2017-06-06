//
//  CardsAdminViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/20/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class CardsAdminViewModel: NSObject {

    var cards: [Card]?
    var customerId: String?
    var extraOptionTitle: String?
    var confirmPromptText: String?
    var titleScreen = "¿Con qué tarjeta?".localized
    var extaOptionNode: ExtraOptionNode?
    fileprivate let itemsPerRow: CGFloat = 2

    public init(cards: [Card]? = nil, extraOptionTitle: String? = nil, confirmPromptText: String? = nil) {
        self.cards = cards
        self.extraOptionTitle = extraOptionTitle
        self.confirmPromptText = confirmPromptText

        if let extraOptionTitle = extraOptionTitle {
            self.extaOptionNode = ExtraOptionNode(extraOptionTitle: extraOptionTitle)
        }
    }

    func numberOfOptions() -> Int {
        var count = 0

        if hasCards() {
            count += cards!.count
        }
        return hasExtraOption() ? count + 1 : count
    }

    func hasExtraOption() -> Bool {
        return !String.isNullOrEmpty(extraOptionTitle)
    }

    func hasCards() -> Bool {
        return !Array.isNullOrEmpty(cards)
    }

    public func setTitle(title: String) {
        self.titleScreen = title
    }

    func calculateHeight(indexPath: IndexPath, numberOfCells: Int) -> CGFloat {
        if numberOfCells == 0 {
            return 0
        }

        let section: Int
        let row = indexPath.row
        if row % 2 == 1 {
            section = (row - 1) / 2
        } else {
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

    var sectionHeight: CGSize?

    func maxHegithRow(indexPath: IndexPath) -> CGFloat {
        if hasCards() || hasExtraOption(){
            return self.calculateHeight(indexPath: indexPath, numberOfCells: numberOfOptions())
        }
        return 0
    }

    func heightOfItem(indexItem: Int) -> CGFloat {
        if isCardItemFor(indexPath: IndexPath(row: indexItem, section: 1)) {
            return PaymentSearchCollectionViewCell.totalHeight(drawablePaymentOption : cards![indexItem])
        } else if isExtraOptionItemFor(indexPath: IndexPath(row: indexItem, section: 1)) {
            return PaymentSearchCollectionViewCell.totalHeight(drawablePaymentOption : extaOptionNode!)
        }
        return 0
    }
    func numberOfSections() -> Int {
        return 2
    }

    public func numberOfItemsInSection (section: Int) -> Int {
        if self.isHeaderSection(section: section) {
            return 1
        }
        return self.numberOfOptions()
    }

    public func sizeForItemAt(indexPath: IndexPath) -> CGSize {

        let paddingSpace = CGFloat(32.0)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let availableWidth = screenWidth - paddingSpace

        let titleCellHeight: CGFloat = 82.0
        if self.isHeaderSection(section: indexPath.section) {
            return CGSize(width : screenWidth, height : titleCellHeight)
        }
        let widthPerItem = availableWidth / self.itemsPerRow
        return CGSize(width: widthPerItem, height: self.maxHegithRow(indexPath:indexPath)  )
    }

    func isCardItemFor(indexPath: IndexPath) -> Bool {
        if !hasCards() {
            return false
        } else if self.isCardsSection(section: indexPath.section) && cards!.count > indexPath.row{
            return true
        }
        return false
    }

    func isExtraOptionItemFor(indexPath: IndexPath) -> Bool {
        if isCardItemFor(indexPath: indexPath){
            return false

        } else if isCardsSection(section: indexPath.section) && hasExtraOption() {
            return true
        }
        return false
    }
}

public class ExtraOptionNode: NSObject, PaymentOptionDrawable{
    let title: String

    init (extraOptionTitle: String){
        title = extraOptionTitle
    }

    public func getTitle() -> String {
        return title
    }

    public func getSubtitle() -> String? {
        return nil
    }

    public func getImageDescription() -> String {
        return ""
    }
}
