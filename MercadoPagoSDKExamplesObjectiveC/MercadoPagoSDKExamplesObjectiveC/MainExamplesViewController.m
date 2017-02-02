//
//  MainExamplesViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "MainExamplesViewController.h"
#import "ExampleUtils.h"
@import MercadoPagoSDK;


@implementation MainExamplesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [MercadoPagoContext setPublicKey:TEST_PUBLIC_KEY];
    [MercadoPagoContext setAccountMoneyAvailableWithAccountMoneyAvailable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutFlow:(id)sender {
    
    Item *item = [[Item alloc] initWith_id:@"peti item" title:@"peti title" quantity:1 unitPrice:10 description:nil];
    Payer *payer = [[Payer alloc] initWith_id:@"payerId" email:@"petiemail@mail.com" type:nil identification:nil];
    
    CheckoutPreference * pref = [[CheckoutPreference alloc] initWithItems:[NSArray arrayWithObject:item] payer:payer paymentMethods:nil];
    [[[MercadoPagoCheckout alloc] initWithCheckoutPrefence:pref navigationController:self.navigationController] start];
}


@end
