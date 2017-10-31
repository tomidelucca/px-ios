#!/bin/sh

cd ../MercadoPagoSDK

xcodebuild -workspace test 'MercadoPagoSDK.xcworkspace' -scheme MercadoPagoSDKTests -destination "platform=iOS Simulator,OS=9.3,name=iPhone 6"

xcodebuild -workspace test 'MercadoPagoSDK.xcworkspace' -scheme MercadoPagoSDKTests -destination "platform=iOS Simulator,OS=10.0,name=iPhone 6s"
