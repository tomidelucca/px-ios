//
//  PXProgressView.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 27/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

protocol ProgressViewDelegate {
    func didFinishProgress()
    func progressTimeOut()
}

final class ProgressView: UIView {

    fileprivate var timer: Timer?

    fileprivate let progressAlpha: CGFloat = 0.35
    fileprivate let deltaIncrementFraction: CGFloat = 18

    fileprivate let progressViewHeight: CGFloat
    fileprivate let progressViewEndX: CGFloat
    fileprivate var progressViewDeltaIncrement: CGFloat = 0

    var progressDelegate: ProgressViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(forView: UIView, loadingColor: UIColor = UIColor.white) {
        progressViewHeight = forView.frame.height
        progressViewEndX = forView.frame.width
        progressViewDeltaIncrement = progressViewEndX / deltaIncrementFraction

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: progressViewHeight))

        self.backgroundColor = loadingColor
        self.layer.cornerRadius = forView.layer.cornerRadius
        self.alpha = progressAlpha

        forView.layer.masksToBounds = true
        forView.addSubview(self)

        initTimer(customSelector: #selector(ProgressView.increment))
    }

    @objc fileprivate func increment() {

        let newWidth =  self.frame.width + deltaIncrementFraction

        let newFrame = CGRect(x: 0, y: 0, width: (self.frame.width + deltaIncrementFraction), height: self.frame.height)

        UIView.animate(withDuration: 0.3, animations: {
            self.frame = newFrame
        }) { completed in
            if newWidth >= self.progressViewEndX {
                self.stopTimer()
                self.progressDelegate?.progressTimeOut()
            }
        }
    }
}

// MARK: Timer.
extension ProgressView {

    fileprivate func initTimer(everySecond: TimeInterval = 0.6, customSelector: Selector) {
        timer = Timer.scheduledTimer(timeInterval: everySecond, target: self,   selector: customSelector, userInfo: nil, repeats: true)
    }

    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

//MARK: Public methods.
extension ProgressView {

    func doReset() {
        let newFrame = CGRect(x: 0, y: 0, width: 0, height: self.frame.height)
        self.frame = newFrame
    }

    func doComplete(completion: @escaping (_ finish: Bool) -> Void) {
        let newFrame = CGRect(x: 0, y: 0, width: progressViewEndX, height: self.frame.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = newFrame
        }) { completed in
            self.stopTimer()
            self.progressDelegate?.didFinishProgress()
            completion(true)
        }
    }
}


