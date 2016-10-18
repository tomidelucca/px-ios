//
//  CountdownTimer.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 10/17/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class CountdownTimer: NSObject {

    var timer : Timer!
    var secondsLeft = 0
    var label : UILabel!
    var timeoutCallback : (Void) -> Void?
    
    
    public init(_ seconds : Int, timeoutCallback : @escaping (Void) -> Void){
        self.secondsLeft = seconds
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 58, height: 20))
        self.label!.backgroundColor = MercadoPagoContext.getPrimaryColor()
        self.label!.textColor = MercadoPagoContext.getTextColor()
        self.timeoutCallback = timeoutCallback
    }
    
    open func startTimer() {
        self.displayTiming()
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(self.updateTimer),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    open func updateTimer(){
        secondsLeft -= 1
        self.displayTiming()
        if !(secondsLeft > 0) {
            stopTimer()
            timeoutCallback()
        }
    }
    
    open func stopTimer() {
        self.label.text = ""
        self.timer.invalidate()
    }
    
    private func displayTiming() {
        var minutesStr = "", secondsStr = ""
        
        let minutes = secondsLeft / 60
        
        if minutes < 10 {
            minutesStr = "0"
        }
        minutesStr += String(minutes)
        
        let seconds = secondsLeft % 60
        if seconds < 10 {
            secondsStr = "0"
        }
        secondsStr += String(seconds)
        self.label!.text = minutesStr + " : " + secondsStr
    }
    

}
