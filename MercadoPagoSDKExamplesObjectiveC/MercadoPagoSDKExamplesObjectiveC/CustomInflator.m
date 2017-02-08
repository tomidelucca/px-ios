//
//  CustomInflator.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 2/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import "CustomInflator.h"
#import "CustomTableViewCell.h"
@import MercadoPagoSDK;


@implementation CustomInflator

-(void)fillCellWithCell:(MPCustomTableViewCell *)cell {
    CustomTableViewCell *currentCell = (CustomTableViewCell *)cell;
    currentCell.label.text = @"override";
}


@end
