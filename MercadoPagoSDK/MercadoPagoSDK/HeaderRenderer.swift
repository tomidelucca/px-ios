//
//  HeaderRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class HeaderRenderer: NSObject {

    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0

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

    func render(header: HeaderComponent ) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = header.backgroundColor
        headerView.translatesAutoresizingMaskIntoConstraints = false

        //Image
        let circleImage = buildCircleImage(with: header.productImage)
        headerView.addSubview(circleImage)
        MPLayout.centerHorizontally(view: circleImage, to: headerView).isActive = true
        MPLayout.pinTop(view: circleImage, to: headerView, withMargin: XXL_MARGIN).isActive = true

        //Badge Image
        let badgeImage = buildBudgeImage(with: header.statusImage)
        headerView.addSubview(badgeImage)
        MPLayout.pinRight(view: badgeImage, to: circleImage, withMargin: BADGE_OFFSET).isActive = true
        MPLayout.pinBottom(view: badgeImage, to: circleImage, withMargin: BADGE_OFFSET).isActive = true

        //Status Label
        let statusLabel = buildStatusLabel(with: header.labelText, in: headerView, onBottomOf: circleImage)
        MPLayout.centerHorizontally(view: statusLabel, to: headerView).isActive = true
        MPLayout.setWidth(ofView: statusLabel, asWidthOfView: headerView, percent: CONTENT_WIDTH_PERCENT).isActive = true

        //Message Label
        let messageLabel = buildMessageLabel(with: header.title)
        headerView.addSubview(messageLabel)
        MPLayout.centerHorizontally(view: messageLabel, to: headerView).isActive = true
        MPLayout.put(view: messageLabel, onBottomOf:statusLabel, withMargin: L_MARGIN).isActive = true
        MPLayout.setWidth(ofView: messageLabel, asWidthOfView: headerView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.pinBottom(view: messageLabel, to: headerView, withMargin: XL_MARGIN).isActive = true
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
            MPLayout.put(view: statusLabel, onBottomOf:upperView, withMargin: S_MARGIN).isActive = true
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
