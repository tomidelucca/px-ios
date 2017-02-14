//
//  CustomInflator.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 2/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import "CustomCellProvider.h"
#import "CustomTableViewCell.h"
@import MercadoPagoSDK;

@implementation CustomCellProvider

@synthesize delegate = _delegate;
@synthesize callbackPaymentData = _callbackPaymentData;


-(void)invokeCallback {
    
    [self.delegate invokeCallbackWithPaymentDataWithRowCallback:^(PaymentData *paymentData) {
        self.callbackPaymentData(paymentData);
    }];
}


-(void) setCallbackPaymentData:(void (^)(PaymentData * _Nonnull))callbackPaymentData{
    _callbackPaymentData = callbackPaymentData;
}

/*** MPCellContentProvider  implementation **/

-(void)fillCellWithCell:(UITableViewCell *)cell {
    CustomTableViewCell *currentCell = (CustomTableViewCell *)cell;
    currentCell.label.text = @"1562663448";
    [currentCell.button addTarget:self action:@selector(invokeCallback) forControlEvents:UIControlEventTouchUpInside];
}


-(UINib *)getNib {
    return [UINib nibWithNibName:@"CustomTableViewCell" bundle: [NSBundle mainBundle]];
}

-(CGFloat)getHeight {
    return (CGFloat)180;
}

@end
