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

UINib *customCellNib = nil;

-(id)initWithUINib:(UINib*)nib{
    self = [super init];
    if (self) {
        customCellNib = nib;
    }
    return self;
    
}
-(void)fillCellWithCell:(MPCustomTableViewCell *)cell {
    CustomTableViewCell *currentCell = (CustomTableViewCell *)cell;
    currentCell.label.text = @"override";
}

-(UINib *)getNib {
    return [UINib nibWithNibName:@"CustomTableViewCell" bundle: [NSBundle mainBundle]];
}

-(CGFloat *)getHeigth {
    return 100;
}


@end
