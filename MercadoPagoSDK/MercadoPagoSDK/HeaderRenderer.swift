//
//  HeaderRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class HeaderRenderer: NSObject {

    //Image
    let IMAGE_WIDTH: CGFloat = 90.0
    let IMAGE_HEIGHT: CGFloat = 90.0

    let BADGE_IMAGE_SIZE: CGFloat = 30.0
    let BADGE_OFFSET: CGFloat = -6.0

    //Image Title
    let STATUS_TITLE_HEIGHT: CGFloat = 18.0
    static let LABEL_FONT_SIZE: CGFloat = 16.0

    //Text
    static let TITLE_FONT_SIZE: CGFloat = 26.0

    let CONTENT_WIDTH_PERCENT: CGFloat = 86.0

    func render(header: PXHeaderComponent ) -> HeaderView {
        let headerView = HeaderView()
        headerView.backgroundColor = header.props.backgroundColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        //Image
        headerView.circleImage = buildCircleImage(with: header.props.productImage)
        headerView.addSubview(headerView.circleImage!)
        MPLayout.centerHorizontally(view: headerView.circleImage!, to: headerView).isActive = true
        MPLayout.pinTop(view: headerView.circleImage!, to: headerView, withMargin: MPLayout.XXXL_MARGIN).isActive = true

        //Badge Image
        headerView.badgeImage = buildBudgeImage(with: header.props.statusImage)
        headerView.addSubview(headerView.badgeImage!)
        MPLayout.pinRight(view: headerView.badgeImage!, to: headerView.circleImage!, withMargin: BADGE_OFFSET).isActive = true
        MPLayout.pinBottom(view: headerView.badgeImage!, to: headerView.circleImage!, withMargin: BADGE_OFFSET).isActive = true

        //Status Label
        headerView.statusLabel = buildStatusLabel(with: header.props.labelText, in: headerView, onBottomOf: headerView.circleImage!)
        MPLayout.centerHorizontally(view: headerView.statusLabel!, to: headerView).isActive = true
        MPLayout.setWidth(ofView: headerView.statusLabel!, asWidthOfView: headerView, percent: CONTENT_WIDTH_PERCENT).isActive = true

        //Message Label
        headerView.messageLabel = buildMessageLabel(with: header.props.title)
        headerView.addSubview(headerView.messageLabel!)
        MPLayout.centerHorizontally(view: headerView.messageLabel!, to: headerView).isActive = true
        MPLayout.put(view: headerView.messageLabel!, onBottomOf:headerView.statusLabel!, withMargin: MPLayout.M_MARGIN).isActive = true
        MPLayout.setWidth(ofView: headerView.messageLabel!, asWidthOfView: headerView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.pinBottom(view: headerView.messageLabel!, to: headerView, withMargin: MPLayout.XL_MARGIN).isActive = true

        return headerView
    }

    func buildCircleImage(with image: UIImage?) -> UIImageView {
        let circleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: IMAGE_WIDTH, height: IMAGE_HEIGHT))
        circleImage.layer.masksToBounds = false
        circleImage.layer.cornerRadius = circleImage.frame.height/2
        circleImage.clipsToBounds = true
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        circleImage.image = image
        MPLayout.setHeight(owner: circleImage, height: IMAGE_WIDTH).isActive = true
        MPLayout.setWidth(owner: circleImage, width: IMAGE_HEIGHT).isActive = true
        return circleImage
    }

    func buildBudgeImage(with image: UIImage?) -> UIImageView {
        let badgeImage = UIImageView()
        badgeImage.translatesAutoresizingMaskIntoConstraints = false
        badgeImage.image = image
        MPLayout.setHeight(owner: badgeImage, height: BADGE_IMAGE_SIZE).isActive = true
        MPLayout.setWidth(owner: badgeImage, width: BADGE_IMAGE_SIZE).isActive = true
        return badgeImage
    }
    func buildStatusLabel(with text: NSAttributedString?, in superView: UIView, onBottomOf upperView: UIView) -> UILabel {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.textColor = .pxWhite
        superView.addSubview(statusLabel)
        if text != nil {
            MPLayout.put(view: statusLabel, onBottomOf:upperView, withMargin: MPLayout.S_MARGIN).isActive = true
            statusLabel.attributedText = text
            MPLayout.setHeight(owner: statusLabel, height: STATUS_TITLE_HEIGHT).isActive = true
        }else {
            MPLayout.put(view: statusLabel, onBottomOf:upperView).isActive = true
            MPLayout.setHeight(owner: statusLabel, height: 0).isActive = true
        }
        return statusLabel
    }

    func buildMessageLabel(with text: NSAttributedString) -> UILabel {
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.attributedText = text
        messageLabel.textColor = .pxWhite
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100
        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE), inWidth: screenWidth)
        MPLayout.setHeight(owner: messageLabel, height: height).isActive = true
        return messageLabel
    }
}

public class HeaderView: UIView {
    public var circleImage: UIImageView?
    public var badgeImage: UIImageView?
    public var statusLabel: UILabel?
    public var messageLabel: UILabel?
}
