#!/bin/sh

cd ../MercadoPagoSDK

xcodebuild -workspace MercadoPagoSDK.xcworkspace clean test -scheme MercadoPagoSDKTests -destination "platform=iOS Simulator,OS=10.3.1,name=iPhone SE"

#xcodebuild -workspace MercadoPagoSDK.xcworkspace clean test -scheme MercadoPagoSDKTests -destination "platform=iOS Simulator,OS=10.0,name=iPhone 6s"
