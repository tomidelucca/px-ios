//
//  PXTimerManager.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 24/4/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

protocol PXTimerChangesDelegate: NSObjectProtocol {
    func timerValueDidChange(timerDisplayValue: String)
}

protocol PXTimerLifecycleDelegate: NSObjectProtocol {
    func didFinishTimer()
}

class PXTimerManager {

    fileprivate lazy var timer = Timer()
    fileprivate lazy var seconds: Int = 0
    fileprivate var timeOutCallback : (() -> Void)?

    lazy var isRunning = false
    weak var changesDelegate: PXTimerChangesDelegate?
    weak var lifecycleDelegate: PXTimerLifecycleDelegate?

    init(withSeconds: Int, callback: (() -> Void)?) {
        seconds = withSeconds
        timeOutCallback = callback
    }

    func startTimer() {
        if seconds > 0 {
            if !isRunning {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(PXTimerManager.updateTimer)), userInfo: nil, repeats: true)
                isRunning = true
            }
        }
    }

    func stopTimer() {
        timer.invalidate()
        lifecycleDelegate = nil
        changesDelegate = nil
        isRunning = false
    }

    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            lifecycleDelegate?.didFinishTimer()
            isRunning = false
            timeOutCallback?()
        } else {
            seconds -= 1
            let newValue = getDisplayValue(forTime: TimeInterval(seconds))
            changesDelegate?.timerValueDidChange(timerDisplayValue: newValue)
        }
    }

    fileprivate func getDisplayValue(forTime: TimeInterval) -> String {
        let minutes = Int(forTime) / 60 % 60
        let seconds = Int(forTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
