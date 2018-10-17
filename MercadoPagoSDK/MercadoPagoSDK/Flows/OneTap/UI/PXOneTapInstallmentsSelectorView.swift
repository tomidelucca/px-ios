//
//  PXOneTapInstallmentsSelectorView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 16/10/18.
//

import UIKit

typealias PXOneTapInstallmentsSelectorData = (title: NSAttributedString, value: NSAttributedString)

final class PXOneTapInstallmentsSelectorCell: UITableViewCell {

    var data: PXOneTapInstallmentsSelectorData? = nil

    func updateData(_ data: PXOneTapInstallmentsSelectorData) {
        self.data = data

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = data.title
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        PXLayout.pinLeft(view: titleLabel, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.centerVertically(view: titleLabel).isActive = true

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.attributedText = data.value
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        PXLayout.pinRight(view: valueLabel, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.centerVertically(view: valueLabel).isActive = true
    }
}

protocol PXOneTapInstallmentsSelectorProtocol: NSObjectProtocol {
    func payerCostSelected(_ payerCost: PXPayerCost?)
}

final class PXOneTapInstallmentsSelectorViewModel {
    let installmentData: PXInstallment

    init(installmentData: PXInstallment) {
        self.installmentData = installmentData
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return installmentData.payerCosts.count
    }

    func cellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = PXOneTapInstallmentsSelectorCell()
        if let payerCost = getPayerCostForRowAt(indexPath) {
            let data = getDataFor(payerCost: payerCost)
            cell.updateData(data)
            return cell
        }
        return cell
    }

    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return PXOneTapInstallmentInfoView.DEFAULT_ROW_HEIGHT
    }

    func getDataFor(payerCost: PXPayerCost) -> PXOneTapInstallmentsSelectorData {
        let currency = SiteManager.shared.getCurrency()
        let showDescription = MercadoPagoCheckout.showPayerCostDescription()

        var title: NSAttributedString = NSAttributedString(string: "")
        var value: NSAttributedString = NSAttributedString(string: "")

        if payerCost.installments == 1 {
            value = NSAttributedString(string: "")
        } else if payerCost.hasInstallmentsRate() {
            let attributedTotal = NSMutableAttributedString(attributedString: NSAttributedString(string: "(", attributes: [NSAttributedStringKey.foregroundColor: UIColor.px_grayLight()]))
            attributedTotal.append(Utils.getAttributedAmount(payerCost.totalAmount, currency: currency, color: UIColor.px_grayLight(), fontSize: 15, baselineOffset: 3))
            attributedTotal.append(NSAttributedString(string: ")", attributes: [NSAttributedStringKey.foregroundColor: UIColor.px_grayLight()]))

            if showDescription == false {
                value = NSAttributedString(string: "")
            } else {
                value = attributedTotal
            }

        } else {
            if showDescription == false {
                value = NSAttributedString(string: "")
            } else {
                value = NSAttributedString(string: "Sin interés".localized, attributes: [NSAttributedStringKey.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()])
            }

        }
        var installmentNumber = String(format: "%i", payerCost.installments)
        installmentNumber = "\(installmentNumber) x "
        let totalAmount = Utils.getAttributedAmount(payerCost.installmentAmount, thousandSeparator: currency.getThousandsSeparatorOrDefault(), decimalSeparator: currency.getDecimalSeparatorOrDefault(), currencySymbol: currency.getCurrencySymbolOrDefault(), color: UIColor.black, centsFontSize: 14, baselineOffset: 5)

        let atribute = [NSAttributedStringKey.font: Utils.getFont(size: 20), NSAttributedStringKey.foregroundColor: UIColor.black]
        let installmentLabel = NSMutableAttributedString(string: installmentNumber, attributes: atribute)

        installmentLabel.append(totalAmount)
        title = installmentLabel

        return PXOneTapInstallmentsSelectorData(title, value)
    }

    func getPayerCostForRowAt(_ indexPath: IndexPath) -> PXPayerCost? {
        return installmentData.payerCosts[indexPath.row]
    }
}


final class PXOneTapInstallmentsSelectorView: PXComponentView, UITableViewDelegate, UITableViewDataSource {

    private var model: PXOneTapInstallmentsSelectorViewModel
    let tableView = UITableView()

    weak var delegate: PXOneTapInstallmentsSelectorProtocol?

    init(viewModel: PXOneTapInstallmentsSelectorViewModel) {
        model = viewModel
        super.init()
        render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(viewModel: PXOneTapInstallmentsSelectorViewModel) {
        model = viewModel
        render()
    }

    var tableViewHeightConstraint: NSLayoutConstraint?

    func render() {
        removeAllSubviews()
        pinContentViewToTop()
        addSubviewToBottom(tableView)

        self.backgroundColor = .clear
        tableViewHeightConstraint = PXLayout.setHeight(owner: tableView, height: 0)
        tableViewHeightConstraint?.isActive = true
        PXLayout.pinLeft(view: tableView).isActive = true
        PXLayout.pinRight(view: tableView).isActive = true
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func expand(completion: @escaping () -> ()) {
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableViewHeightConstraint?.constant = strongSelf.frame.height
        }) { (_) in
            completion()
        }
    }

    func collapse(completion: @escaping () -> ()) {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableViewHeightConstraint?.constant = 0
            strongSelf.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return model.cellForRowAt(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.heightForRowAt(indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPayerCost = model.getPayerCostForRowAt(indexPath)
        delegate?.payerCostSelected(selectedPayerCost)
    }
}
