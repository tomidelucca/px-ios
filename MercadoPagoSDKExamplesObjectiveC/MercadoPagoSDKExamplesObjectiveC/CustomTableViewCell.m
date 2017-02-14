//
//  CustomTableViewCell.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 2/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import "CustomTableViewCell.h"
@import MercadoPagoSDK;

@implementation CustomTableViewCell 

-(UINib *)getNib {
    return [UINib nibWithNibName:@"CustomTableViewCell" bundle: [NSBundle mainBundle]];
}

-(CGFloat)getHeigth {
    return (CGFloat)180;
}

@end
