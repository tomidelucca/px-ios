//
//  InstallmentsTableViewController.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 5/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MercadoPagoSDK;

@interface InstallmentsTableViewController : UITableViewController

@property Card *card;
@property double amount;
@property PayerCost *selectedPayerCost;

@end
