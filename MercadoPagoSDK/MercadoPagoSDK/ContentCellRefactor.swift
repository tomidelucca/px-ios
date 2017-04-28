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

    var height: CGFloat = 0
    var rect =  CGRect(x: 0, y: 0, width : UIScreen.main.bounds.width, height : 0)
    
    init(paymentResult: PaymentResult, paymentResultScreenPreference: PaymentResultScreenPreference) {
        super.init(frame: rect)
        
        self.viewModel = ContentCellRefactorViewModel(paymentResult: paymentResult, paymentResultScreenPreference: paymentResultScreenPreference)
        
        height = self.viewModel.topMargin
        
        if self.viewModel.hasTitle() {
            makeLabel(text: self.viewModel.getTitle(), fontSize: 22)
        }
        
        if self.viewModel.hasSubtitle() {
            height += self.viewModel.titleSubtitleMargin
            makeLabel(text: self.viewModel.getSubtitle(), fontSize: 18)
        }
        self.frame = CGRect(x: 0, y: 0, width : UIScreen.main.bounds.width, height : height + viewModel.topMargin)
    }
    
    func makeLabel(text: String, fontSize: CGFloat, color: UIColor = UIColor.px_grayDark()) {
        let label = MPLabel()
        label.text = text
        label.font = Utils.getFont(size: fontSize)
        label.textColor = color
        label.textAlignment = .center
        label.frame = CGRect(x: self.viewModel.leftMargin, y: height , width: frame.size.width - (2 * self.viewModel.leftMargin), height: 0)
        let frameLabel = CGRect(x: self.viewModel.leftMargin , y: height, width: frame.size.width - (2 * self.viewModel.leftMargin), height: label.requiredHeight())
        label.frame = frameLabel
        label.numberOfLines = 0
        height += label.requiredHeight()
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getHeight(frameWidth: CGFloat = UIScreen.main.bounds.width, paymentResult: PaymentResult, paymentResultScreenPreference: PaymentResultScreenPreference) -> CGFloat {
        
        let viewModel = ContentCellRefactorViewModel(paymentResult: paymentResult, paymentResultScreenPreference: paymentResultScreenPreference)
        var height = viewModel.topMargin
        
        if viewModel.hasTitle() {
            let label = MPLabel()
            label.text = viewModel.getTitle()
            label.frame = CGRect(x: viewModel.leftMargin, y: height , width: frameWidth - (2 * viewModel.leftMargin), height: 0)
            height += label.requiredHeight()
        }
        
        if viewModel.hasSubtitle() {
            height += viewModel.titleSubtitleMargin
            let label = MPLabel()
            label.text = viewModel.getSubtitle()
            label.frame = CGRect(x: viewModel.leftMargin, y: height , width: frameWidth - (2 * viewModel.leftMargin), height: 0)
            height += label.requiredHeight()
        }
        return height + viewModel.topMargin
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
    
    func hasTitle() -> Bool {
        return !paymentResultScreenPreference.isRejectedContentTitleDisable() && getTitle() != ""
    }
    
    func hasSubtitle() -> Bool {
        return ((!paymentResultScreenPreference.isRejectedContentTextDisable() && paymentResult.status == "rejected") || (!paymentResultScreenPreference.isPendingContentTextDisable() && paymentResult.status == PaymentResultViewModel.PaymentStatus.IN_PROCESS.rawValue)) && getSubtitle() != ""
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
        if paymentResult.statusDetail == "cc_rejected_call_for_authorize" {
            return (paymentResult.statusDetail + "_title").localized
        } else if paymentResult.statusDetail != "" {
            return defaultTitle
        }  else if !String.isNullOrEmpty(paymentResultScreenPreference.getRejectedContetTitle()) {
            return paymentResultScreenPreference.getRejectedContetTitle()
        }
        return defaultTitle
    }
    
    func getPendingTitle() -> String {
        if !String.isNullOrEmpty(paymentResultScreenPreference.getPendingContetTitle()) && paymentResult.statusDetail == ""{
            return paymentResultScreenPreference.getPendingContetTitle()
        }
        return defaultTitle
    }
    
    func getSubtitle() -> String {
        if paymentResult.status == PaymentResultViewModel.PaymentStatus.REJECTED.rawValue {
            return getRejectedSubtitle()
        } else if paymentResult.status == PaymentResultViewModel.PaymentStatus.IN_PROCESS.rawValue {
            return getPendingSubtitle()
        }
        return ""
    }
    
    func getRejectedSubtitle() -> String {
        if paymentResult.statusDetail == "cc_rejected_call_for_authorize" {
            return ""
        } else if paymentResult.statusDetail != "" {
            
            let paymentTypeID = paymentResult.paymentData?.paymentMethod.paymentTypeId ?? "credit_card"
            let subtitle = (paymentResult.statusDetail + "_subtitle_" + paymentTypeID)
            
            if subtitle.existsLocalized() {
                let paymentMethodName = paymentResult.paymentData?.paymentMethod.name.localized ?? ""
                return (subtitle.localized as NSString).replacingOccurrences(of: "%0", with: "\(paymentMethodName)")
            }
        }  else if !String.isNullOrEmpty(paymentResultScreenPreference.getRejectedContentText()) {
            return paymentResultScreenPreference.getRejectedContentText()
        }
        return ""
    }
    
    func getPendingSubtitle() -> String {
        if paymentResult.statusDetail == "pending_contingency"{
            return "En menos de 1 hora te enviaremos por e-mail el resultado.".localized
            
        } else if paymentResult.statusDetail == "pending_review_manual"{
            return "En menos de 2 días hábiles te diremos por e-mail si se acreditó o si necesitamos más información.".localized
        } else if !String.isNullOrEmpty(paymentResultScreenPreference.getPendingContentText()) {
            return paymentResultScreenPreference.getPendingContentText()
        }
        return ""
    }
}
