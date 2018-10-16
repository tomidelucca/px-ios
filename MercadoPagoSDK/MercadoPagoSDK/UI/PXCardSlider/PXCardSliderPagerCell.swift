//
//  PXCardSliderPagerCell.swift
//
//  Created by Juan sebastian Sanzone on 12/10/18.
//

import UIKit

class PXCardSliderPagerCell: FSPagerViewCell {
    static let identifier = "PXCardSliderPagerCell"
    static func getCell() -> UINib {
        return UINib(nibName: PXCardSliderPagerCell.identifier, bundle: ResourceManager.shared.getBundle())
    }

    private lazy var cornerRadius: CGFloat = 11
    private var cardHeader: CardHeaderController?
    @IBOutlet weak var containerView: UIView!
    // private var containerView: UIView = UIView()

    override func prepareForReuse() {
        super.prepareForReuse()
        cardHeader?.view.removeFromSuperview()
    }
}

// MARK: Publics.
extension PXCardSliderPagerCell {
    func render(withCard: CardUI, cardData: CardData) {
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = .clear
        // setupCardContainer()
        cardHeader = CardHeaderController(withCard, cardData)
        cardHeader?.view.frame = CGRect(origin: CGPoint.zero, size: PXCardSliderSizeManager.getItemContainerSize())
        cardHeader?.animated(false)
        cardHeader?.show()
        if let headerView = cardHeader?.view {
            containerView.addSubview(headerView)
        }
    }

    func renderEmptyCard() {
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = .clear
        // setupCardContainer()
        cardHeader = CardHeaderController(EmptyCard(), PXCardDataFactory())
        cardHeader?.view.frame = CGRect(origin: CGPoint.zero, size: PXCardSliderSizeManager.getItemContainerSize())
        cardHeader?.animated(false)
        cardHeader?.show()
        if let headerView = cardHeader?.view {
            containerView.addSubview(headerView)
            let circleView = UIView()
            let circleSize: CGFloat = 60
            headerView.addSubview(circleView)
            circleView.backgroundColor = .white
            circleView.layer.shadowColor = UIColor.black.cgColor
            circleView.layer.cornerRadius = circleSize / 2
            circleView.layer.shadowRadius = 3
            circleView.layer.shadowOpacity = 0.25
            circleView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
            PXLayout.setHeight(owner: circleView, height: circleSize).isActive = true
            PXLayout.setWidth(owner: circleView, width: circleSize).isActive = true
            PXLayout.centerVertically(view: circleView, withMargin: -PXLayout.S_MARGIN).isActive = true
            PXLayout.centerHorizontally(view: circleView).isActive = true

            let label = UILabel()
            label.text = "Agregar nueva tarjeta".localized
            label.font = Utils.getFont(size: PXLayout.XXS_FONT)
            label.textColor = ThemeManager.shared.getAccentColor()
            label.textAlignment = .center
            headerView.addSubview(label)
            PXLayout.pinLeft(view: label, withMargin: 0).isActive = true
            PXLayout.pinRight(view: label, withMargin: 0).isActive = true
            PXLayout.put(view: label, onBottomOf: circleView, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.setHeight(owner: label, height: PXLayout.S_FONT).isActive = true
            PXLayout.centerHorizontally(view: label).isActive = true

            let addImage = UIImageView()
            let imageSize: CGFloat = 18
            addImage.image = ResourceManager.shared.getImage("oneTapAdd")
            addImage.contentMode = .scaleAspectFit
            circleView.addSubview(addImage)
            PXLayout.setHeight(owner: addImage, height: imageSize).isActive = true
            PXLayout.setWidth(owner: addImage, width: imageSize).isActive = true
            PXLayout.centerVertically(view: addImage).isActive = true
            PXLayout.centerHorizontally(view: addImage).isActive = true
        }
    }

    func flipToBack() {
        cardHeader?.showSecurityCode()
    }

    func flipToFront() {
        cardHeader?.animated(true)
        cardHeader?.show()
        cardHeader?.animated(false)
    }
}

extension PXCardSliderPagerCell {
    private func setupCardContainer() {
        contentView.addSubview(containerView)
        PXLayout.pinTop(view: containerView, withMargin: 5).isActive = true
        PXLayout.pinBottom(view: containerView, withMargin: 20).isActive = true
        PXLayout.pinLeft(view: containerView, withMargin: 10).isActive = true
        PXLayout.pinRight(view: containerView, withMargin: 5).isActive = true
    }
}
