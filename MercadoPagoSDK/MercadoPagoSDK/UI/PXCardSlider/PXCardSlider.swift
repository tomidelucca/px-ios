//
//  PXCardSlider.swift
//
//  Created by Juan sebastian Sanzone on 12/10/18.
//

import UIKit

internal typealias PXCardSliderViewModel = (cardUI: CardUI, cardData: CardData?)

protocol PXCardSliderProtocol: NSObjectProtocol {
    func newCardDidSelected(targetModel: PXCardSliderViewModel)
    func addPaymentMethodCardDidTap()
}

final class PXCardSlider: NSObject {
    private var pagerView = FSPagerView(frame: .zero)
    private var pageControl = FSPageControl(frame: .zero)
    private var model: [PXCardSliderViewModel] = [] {
        didSet {
            self.selectedIndex = 0
            self.pagerView.reloadData()
            self.pageControl.numberOfPages = self.model.count
        }
    }
    private weak var delegate: PXCardSliderProtocol?
    private var selectedIndex: Int = 0
    private let cardSliderCornerRadius: CGFloat = 11
}

// MARK: DataSource
extension PXCardSlider: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return model.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if model.indices.contains(index) {
            let targetModel = model[index]
            if let cardData = targetModel.cardData, let cell = pagerView.dequeueReusableCell(withReuseIdentifier: PXCardSliderPagerCell.identifier, at: index) as? PXCardSliderPagerCell {
                cell.render(withCard: targetModel.cardUI, cardData: cardData)
                return cell
            } else {
                // Add card scenario. // TODO: Cell for add card
                if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: PXCardSliderPagerCell.identifier, at: index) as? PXCardSliderPagerCell {
                    cell.renderEmptyCard()
                    return cell
                }
            }
        }
        return FSPagerViewCell()
    }
}

// MARK: Delegate
extension PXCardSlider: FSPagerViewDelegate {
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
        if selectedIndex != targetIndex {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
            selectedIndex = targetIndex
            if model.indices.contains(targetIndex) {
                let modelData = model[targetIndex]
                delegate?.newCardDidSelected(targetModel: modelData)
            }
        }
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if model.indices.contains(index) {
            let modelData = model[index]
            if modelData.cardData == nil {
                delegate?.addPaymentMethodCardDidTap()
            } else {
                //TODO: Remove. This is only for tets flip capability.
                if let cell = pagerView.cellForItem(at: index) as? PXCardSliderPagerCell {
                    cell.flipToBack()
                }
            }
        }
    }
}

// MARK: Publics
extension PXCardSlider {
    func render(containerView: UIView, cardSliderProtocol: PXCardSliderProtocol? = nil) {
        setupSlider(containerView)
        setupPager(containerView)
        delegate = cardSliderProtocol
    }

    func update(_ newModel: [PXCardSliderViewModel]) {
        model = newModel
    }

    func show() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.pagerView.alpha = 1
            self?.pageControl.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.pagerView.alpha = 0
            self?.pageControl.alpha = 0
        }
    }
}

// MARK: Privates
extension PXCardSlider {
    private func setupSlider(_ containerView: UIView) {
        containerView.addSubview(pagerView)
        PXLayout.setHeight(owner: pagerView, height: containerView.bounds.height).isActive = true
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
        pagerView.itemSize = PXCardSliderSizeManager.getItemSize()
    }

    private func setupPager(_ containerView: UIView) {
        let pagerYMargin: CGFloat = PXLayout.XS_MARGIN
        let pagerHeight: CGFloat = 25
        let disabledDotsColor: UIColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.1)
        pageControl.contentHorizontalAlignment = .center
        pageControl.numberOfPages = model.count
        pageControl.currentPage = 0
        pageControl.setStrokeColor(.clear, for: .normal)
        pageControl.setFillColor(disabledDotsColor, for: .normal)
        pageControl.setStrokeColor(ThemeManager.shared.getAccentColor(), for: .selected)
        pageControl.setFillColor(ThemeManager.shared.getAccentColor(), for: .selected)
        containerView.addSubview(pageControl)
        PXLayout.pinRight(view: pageControl).isActive = true
        PXLayout.pinLeft(view: pageControl).isActive = true
        PXLayout.centerHorizontally(view: pageControl).isActive = true
        PXLayout.pinBottom(view: pageControl, withMargin: -pagerYMargin).isActive = true
        PXLayout.setHeight(owner: pageControl, height: pagerHeight).isActive = true
    }
}
