//
//  main.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 12/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

//
// main.swift
//
import UIKit

private func delegateClassName() -> String? {
    let kUITestingLaunchArgument = "UITestingEnabled"
    
    
    if (NSProcessInfo.processInfo().arguments.contains(kUITestingLaunchArgument)) {
        return NSStringFromClass(TestAppDelegate)
    }
    
    return NSStringFromClass(AppDelegate)
}

UIApplicationMain(Process.argc, Process.unsafeArgv, nil, delegateClassName())
