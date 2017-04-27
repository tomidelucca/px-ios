//
//  ContentCellRefactor.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 4/27/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class ContentCellRefactor: UIView {
    var viewModel: ContentCellRefactorViewModel!
    
    static let HEIGHT: CGFloat = 200
    var height: CGFloat = 0
    
    init(frame: CGRect, paymentResult: PaymentResult, paymentResultScreenPreference: PaymentResultScreenPreference) {
        super.init(frame: frame)
        
        self.viewModel = ContentCellRefactorViewModel(paymentResult: paymentResult, paymentResultScreenPreference: paymentResultScreenPreference)
        
        height = self.viewModel.topMargin
        
        if self.viewModel.getTitle() != "" {
            let title = MPLabel()
            title.text = self.viewModel.getTitle()
            title.font = Utils.getFont(size: 22)
            title.textColor = UIColor.px_grayDark()
            title.textAlignment = .center
            let frameLabel = CGRect(x: self.viewModel.leftMargin , y: height, width: frame.size.width - (2 * self.viewModel.leftMargin), height: title.requiredHeight())
            title.frame = frameLabel
            self.addSubview(title)
            height += title.requiredHeight()
        }
        
        height += self.viewModel.titleSubtitleMargin
        
        let subtitle = MPLabel()
        subtitle.text = "En menos de 1 hora te enviaremos por e-mail el resultado.".localized
        subtitle.font = Utils.getFont(size: 18)
        subtitle.textColor = UIColor.px_grayDark()
        subtitle.textAlignment = .center
        subtitle.frame = CGRect(x: self.viewModel.leftMargin, y: height , width: frame.size.width - (2 * self.viewModel.leftMargin), height: 0)
        let frameSubtitle = CGRect(x: self.viewModel.leftMargin, y: height , width: frame.size.width - (2 * self.viewModel.leftMargin), height: subtitle.requiredHeight())
        subtitle.frame = frameSubtitle
        subtitle.numberOfLines = 0
        self.addSubview(subtitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContentCellRefactorViewModel: NSObject {
    let topMargin: CGFloat = 50
    let leftMargin: CGFloat = 15
    let titleSubtitleMargin: CGFloat = 20
    
    let paymentResult: PaymentResult
    let paymentResultScreenPreference: PaymentResultScreenPreference
    
    let defaultTitle = "¿Qué puedo hacer?".localized
    
    init(paymentResult: PaymentResult, paymentResultScreenPreference: PaymentResultScreenPreference) {
        self.paymentResult = paymentResult
        self.paymentResultScreenPreference = paymentResultScreenPreference
    }
    
    func getTitle() -> String {
        if paymentResult.status == PaymentResultViewModel.PaymentStatus.REJECTED.rawValue {
            return getRejectedTitle()
        } else if paymentResult.status == PaymentResultViewModel.PaymentStatus.IN_PROCESS.rawValue {
            return getPendingTitle()
        }
        return defaultTitle
    }
    
    func getRejectedTitle() -> String {
        if paymentResultScreenPreference.isRejectedContentTitleDisable(){
            return ""
        } else if paymentResult.statusDetail == "cc_rejected_call_for_authorize" {
            return (paymentResult.statusDetail + "_title").localized
        } else if paymentResult.statusDetail != "" {
            return defaultTitle
        }  else if !String.isNullOrEmpty(paymentResultScreenPreference.getRejectedContetTitle()) {
            return paymentResultScreenPreference.getRejectedContetTitle()
        }
        return defaultTitle
    }
    
    func getPendingTitle() -> String {
        if !String.isNullOrEmpty(paymentResultScreenPreference.getPendingContetTitle()) {
            return paymentResultScreenPreference.getPendingContetTitle()
        }
        return defaultTitle
    }
}
