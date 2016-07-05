//
//  SimpleVaultViewController.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 4/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MercadoPagoSDK;

@interface SimpleVaultViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) PaymentMethod *selectedPaymentMethod;
@property Card *customerCard;
@property bool allowInstallmentsSelection;

@end
