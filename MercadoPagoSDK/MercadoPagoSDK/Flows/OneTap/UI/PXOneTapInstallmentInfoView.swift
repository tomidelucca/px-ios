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
    private let titleLabel = UILabel()
    private let colapsedTag: Int = 2
    private var arrowImage: UIImageView = UIImageView()
    private var pagerView = FSPagerView(frame: .zero)
    var model: [PXOneTapInstallmentInfoViewModel]? {
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

    func render() {
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
        arrowImage.tag = colapsedTag

        setupTitleLabel()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleInstallments)))
    }

    private func updateArroyImage(alpha: CGFloat) {
        arrowImage.alpha = alpha
    }

    private func setupSlider() {
        addSubview(pagerView)
        pagerView.isUserInteractionEnabled = false
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
        pagerView.scrollToOffset(offset, animated: false)
    }

    @objc func toggleInstallments() {
        if tapEnabled {
            if let installmentData = model?[getCurrentIndex()].installmentData {
                if arrowImage.tag != colapsedTag {
                    delegate?.hideInstallments()
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.arrowImage.transform = CGAffineTransform.identity
                        self?.pagerView.alpha = 1
                        self?.titleLabel.alpha = 0
                    }
                    arrowImage.tag = colapsedTag
                } else {
                    delegate?.showInstallments(installmentData: installmentData)
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                        self?.pagerView.alpha = 0
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
        guard let model = model else {return 0}
        return model.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

        guard let model = model else {return FSPagerViewCell()}

        let itemModel = model[index]
        cell.removeAllSubviews()

        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.text = itemModel.leftText
        leftLabel.textAlignment = .left
        leftLabel.font = Utils.getSemiBoldFont(size: PXLayout.M_FONT)
        leftLabel.textColor = ThemeManager.shared.boldLabelTintColor()
        cell.addSubview(leftLabel)
        PXLayout.pinLeft(view: leftLabel, withMargin: PXLayout.M_MARGIN + PXLayout.XXXS_MARGIN).isActive = true
        PXLayout.pinTop(view: leftLabel, withMargin: PXLayout.S_MARGIN + 2).isActive = true

        let rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.text = itemModel.rightText
        rightLabel.textAlignment = .left
        rightLabel.font = Utils.getLightFont(size: PXLayout.XS_FONT)
        rightLabel.textColor = ThemeManager.shared.greyColor()
        cell.addSubview(rightLabel)
        PXLayout.put(view: rightLabel, rightOf: leftLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
        PXLayout.centerVertically(view: rightLabel, to: leftLabel, withMargin: 0).isActive = true

        return cell
    }
}

// MARK: Delegate
extension PXOneTapInstallmentInfoView: FSPagerViewDelegate {

    func getCurrentIndex() -> Int {
        let scrollOffset = pagerView.scrollOffset
        let floorOffset = floor(scrollOffset)
        return Int(floorOffset)
    }

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let newAlpha = 1 - (pagerView.scrollOffset - CGFloat(integerLiteral: getCurrentIndex()))
        if newAlpha < 0.5 {
            pagerView.alpha = 1 - newAlpha
        } else {
            pagerView.alpha = newAlpha
        }
    }
}
