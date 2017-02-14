//
//  CustomInflator.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 2/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MercadoPagoSDK;

@interface CustomCellProvider : NSObject<MPCellContentProvider>

@property (nonatomic, copy) void (^ _Nonnull callbackPaymentData)(PaymentData * _Nonnull);

@end
