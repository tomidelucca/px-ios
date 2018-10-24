//
//  PXOneTapInstallmentInfoView.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/10/18.
//

import UIKit

protocol PXOneTapInstallmentInfoViewProtocol: NSObjectProtocol {
    func hideInstallments()
    func showInstallments(installmentData: PXInstallment?)
}

final class PXOneTapInstallmentInfoView: PXComponentView {
    static let DEFAULT_ROW_HEIGHT: CGFloat = 50
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    private let titleLabel = UILabel()
    private let colapsedTag: Int = 2
    private var arrowImage: UIImageView = UIImageView()
    private var pagerView = FSPagerView(frame: .zero)
    var model: PXOneTapInstallmentInfoViewModel?
    var testModel: [PXOneTapInstallmentInfoViewModel]? {
        didSet {
            pagerView.reloadData()
        }
    }

    weak var delegate: PXOneTapInstallmentInfoViewProtocol?

    private var tapEnabled = true

    func disableTap() {
        tapEnabled = false
    }

    func enableTap() {
        tapEnabled = true
    }

    func updateViewModel(_ viewModel: PXOneTapInstallmentInfoViewModel, updateAnimation: UIView.AnimationOptions? = nil) {
        model = viewModel
//        var animation: UIView.AnimationOptions = .transitionCrossDissolve
//        if let customAnimation = updateAnimation {
//            animation = customAnimation
//        }
//
//        if viewModel.installmentData != nil {
//            if arrowImage.alpha != 1 {
//                UIView.animate(withDuration: 0.20) { [weak self] in
//                    self?.arrowImage.alpha = 1
//                }
//            }
//        } else {
//            UIView.animate(withDuration: 0.20) { [weak self] in
//                self?.arrowImage.alpha = 0
//            }
//        }
//        
//        UIView.transition(with: self.rightLabel, duration: 0.25, options: animation, animations: { [weak self] in
//            self?.rightLabel.text = self?.model?.rightText
//        }, completion: nil)
//        UIView.transition(with: self.leftLabel, duration: 0.25, options: animation, animations: { [weak self] in
//            self?.leftLabel.text = self?.model?.leftText
//        }, completion: nil)
    }

    func render() {
//        guard let model = model else {return}
        removeAllSubviews()
        setupSlider()
        PXLayout.setHeight(owner: self, height: PXOneTapInstallmentInfoView.DEFAULT_ROW_HEIGHT).isActive = true

        addSubview(arrowImage)
        arrowImage.contentMode = UIViewContentMode.scaleAspectFit
        arrowImage.image = ResourceManager.shared.getImage("oneTapDownArrow")
        PXLayout.pinTop(view: arrowImage, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.setWidth(owner: arrowImage, width: 14).isActive = true
        PXLayout.setHeight(owner: arrowImage, height: 14).isActive = true
        PXLayout.pinRight(view: arrowImage, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true


//
//        leftLabel.translatesAutoresizingMaskIntoConstraints = false
//        leftLabel.text = model.leftText
//        leftLabel.textAlignment = .left
//        leftLabel.font = Utils.getSemiBoldFont(size: PXLayout.M_FONT)
//        leftLabel.textColor = ThemeManager.shared.boldLabelTintColor()
//        addSubview(leftLabel)
//        PXLayout.pinLeft(view: leftLabel, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
//        PXLayout.pinTop(view: leftLabel, withMargin: PXLayout.S_MARGIN + 2).isActive = true
//
//        rightLabel.translatesAutoresizingMaskIntoConstraints = false
//        rightLabel.text = model.rightText
//        rightLabel.textAlignment = .left
//        rightLabel.font = Utils.getLightFont(size: PXLayout.XS_FONT)
//        rightLabel.textColor = ThemeManager.shared.greyColor()
//        addSubview(rightLabel)
//        PXLayout.put(view: rightLabel, rightOf: leftLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
//        PXLayout.centerVertically(view: rightLabel, to: leftLabel, withMargin: 0).isActive = true
//
//        addSubview(arrowImage)
//        arrowImage.contentMode = UIViewContentMode.scaleAspectFit
//        arrowImage.image = ResourceManager.shared.getImage("oneTapDownArrow")
//        PXLayout.pinTop(view: arrowImage, withMargin: PXLayout.M_MARGIN).isActive = true
//        PXLayout.setWidth(owner: arrowImage, width: 14).isActive = true
//        PXLayout.setHeight(owner: arrowImage, height: 14).isActive = true
//        PXLayout.pinRight(view: arrowImage, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
//
//        arrowImage.tag = colapsedTag
//        if model.installmentData == nil {
//            arrowImage.alpha = 0
//        }
//
//        setupTitleLabel()
//
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleInstallments)))
    }

    private func updateArroyImage(model: PXOneTapInstallmentInfoViewModel) {
        addSubview(arrowImage)
        arrowImage.contentMode = UIViewContentMode.scaleAspectFit
        arrowImage.image = ResourceManager.shared.getImage("oneTapDownArrow")
        PXLayout.pinTop(view: arrowImage, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.setWidth(owner: arrowImage, width: 14).isActive = true
        PXLayout.setHeight(owner: arrowImage, height: 14).isActive = true
        PXLayout.pinRight(view: arrowImage, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true

        arrowImage.tag = colapsedTag
        if model.installmentData == nil {
            arrowImage.alpha = 0
        }
    }

    private func setupSlider() {
        addSubview(pagerView)
//        pagerView.layer.borderWidth = 4
        PXLayout.setHeight(owner: pagerView, height: PXOneTapInstallmentInfoView.DEFAULT_ROW_HEIGHT).isActive = true
        PXLayout.pinLeft(view: pagerView).isActive = true
        PXLayout.pinRight(view: pagerView).isActive = true
        PXLayout.matchWidth(ofView: pagerView).isActive = true
        PXLayout.pinTop(view: pagerView).isActive = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(PXCardSliderPagerCell.getCell(), forCellWithReuseIdentifier: PXCardSliderPagerCell.identifier)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.isInfinite = false
        pagerView.automaticSlidingInterval = 0
        pagerView.bounces = true
        pagerView.interitemSpacing = 0
        pagerView.decelerationDistance = 1
        pagerView.itemSize = CGSize(width: PXCardSliderSizeManager.getItemSize().width, height: PXOneTapInstallmentInfoView.DEFAULT_ROW_HEIGHT)
    }

    func setSliderOffset(offset: CGPoint) {
        pagerView.scrollToOffset(offset)
    }

    @objc func toggleInstallments() {
        if tapEnabled {
            if let installMentData = model?.installmentData {
                if arrowImage.tag != colapsedTag {
                    delegate?.hideInstallments()
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.arrowImage.transform = CGAffineTransform.identity
                        self?.rightLabel.alpha = 1
                        self?.leftLabel.alpha = 1
                        self?.titleLabel.alpha = 0
                    }
                    arrowImage.tag = colapsedTag
                } else {
                    delegate?.showInstallments(installmentData: installMentData)
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                        self?.rightLabel.alpha = 0
                        self?.leftLabel.alpha = 0
                        self?.titleLabel.alpha = 1
                    }
                    arrowImage.tag = 1
                }
            }
        }
    }
}

extension PXOneTapInstallmentInfoView {
    private func setupTitleLabel() {
        titleLabel.alpha = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Selecciona la cuota".localized
        titleLabel.textAlignment = .left
        titleLabel.font = Utils.getFont(size: PXLayout.XS_FONT)
        titleLabel.textColor = ThemeManager.shared.greyColor()
        addSubview(titleLabel)
        PXLayout.pinLeft(view: titleLabel, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
        PXLayout.pinTop(view: titleLabel, withMargin: PXLayout.S_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
    }
}

// MARK: DataSource
extension PXOneTapInstallmentInfoView: FSPagerViewDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let testModel = testModel else {return 0}
        return testModel.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? FSPagerViewCell else {
            return FSPagerViewCell()
        }

        guard let testModel = testModel else {return FSPagerViewCell()}

        let model = testModel[index]
        cell.removeAllSubviews()

//        cell.layer.borderWidth = 2
//        PXLayout.matchWidth(ofView: cell).isActive = true
//        PXLayout.setWidth(owner: cell, width: PXLayout.getScreenWidth()).isActive = true
//        PXLayout.setHeight(owner: cell, height: PXOneTapInstallmentInfoView.DEFAULT_ROW_HEIGHT).isActive = true

        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.text = model.leftText
        leftLabel.textAlignment = .left
        leftLabel.font = Utils.getSemiBoldFont(size: PXLayout.M_FONT)
        leftLabel.textColor = ThemeManager.shared.boldLabelTintColor()
        cell.addSubview(leftLabel)
        PXLayout.pinLeft(view: leftLabel, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
        PXLayout.pinTop(view: leftLabel, withMargin: PXLayout.S_MARGIN + 2).isActive = true

        let rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.text = model.rightText
        rightLabel.textAlignment = .left
        rightLabel.font = Utils.getLightFont(size: PXLayout.XS_FONT)
        rightLabel.textColor = ThemeManager.shared.greyColor()
        cell.addSubview(rightLabel)
        PXLayout.put(view: rightLabel, rightOf: leftLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
        PXLayout.centerVertically(view: rightLabel, to: leftLabel, withMargin: 0).isActive = true

//        addSubview(arrowImage)
//        arrowImage.contentMode = UIViewContentMode.scaleAspectFit
//        arrowImage.image = ResourceManager.shared.getImage("oneTapDownArrow")
//        PXLayout.pinTop(view: arrowImage, withMargin: PXLayout.M_MARGIN).isActive = true
//        PXLayout.setWidth(owner: arrowImage, width: 14).isActive = true
//        PXLayout.setHeight(owner: arrowImage, height: 14).isActive = true
//        PXLayout.pinRight(view: arrowImage, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
//
//        arrowImage.tag = colapsedTag
//        if model.installmentData == nil {
//            arrowImage.alpha = 0
//        }

//        setupTitleLabel()

//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleInstallments)))







//        if model.indices.contains(index) {
//            let targetModel = model[index]
//            if let cardData = targetModel.cardData, let cell = pagerView.dequeueReusableCell(withReuseIdentifier: PXCardSliderPagerCell.identifier, at: index) as? PXCardSliderPagerCell {
//                if targetModel.cardUI is AccountMoneyCard {
//                    // AM card.
//                    cell.renderAccountMoneyCard(balanceText: cardData.name)
//                } else {
//                    // Other cards.
//                    cell.render(withCard: targetModel.cardUI, cardData: cardData)
//                }
//                return cell
//            } else {
//                // Add new card scenario.
//                if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: PXCardSliderPagerCell.identifier, at: index) as? PXCardSliderPagerCell {
//                    cell.renderEmptyCard()
//                    return cell
//                }
//            }
//        }
        return cell
    }
}

// MARK: Delegate
extension PXOneTapInstallmentInfoView: FSPagerViewDelegate {

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        print(pagerView.scrollOffset)
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        if selectedIndex != targetIndex {
//            PXFeedbackGenerator.selectionFeedback()
//            selectedIndex = targetIndex
//            if model.indices.contains(targetIndex) {
//                let modelData = model[targetIndex]
//                delegate?.newCardDidSelected(targetModel: modelData)
//            }
//        }
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        if model.indices.contains(index) {
//            let modelData = model[index]
//            if modelData.cardData == nil {
//                delegate?.addPaymentMethodCardDidTap()
//            } else {
//                //TODO: Remove. This is only for tets flip capability.
//                if let cell = pagerView.cellForItem(at: index) as? PXCardSliderPagerCell {
//                    cell.flipToBack()
//                }
//            }
//        }
    }
}
