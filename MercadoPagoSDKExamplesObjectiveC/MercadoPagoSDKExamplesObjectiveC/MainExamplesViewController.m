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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutFlow:(id)sender {
    


    CheckoutPreference * pref = [[CheckoutPreference alloc] initWith_id:@"223362579-96d6c137-02c3-48a2-bf9c-76e2d263c632"];
    NSDictionary *extraParams = @{
                                  @"merchant_access_token" : @"mla-cards-data"
                                  };
    ServicePreference * servpref = [[ServicePreference alloc] init];
    [servpref setGetCustomerWithBaseURL:@"https://www.mercadopago.com" URI:@"/checkout/examples/getCustomer" additionalInfo:extraParams];
    
    [MercadoPagoCheckout setServicePreference:servpref];
    [[[MercadoPagoCheckout alloc] initWithCheckoutPrefence:pref navigationController:self.navigationController] start];
}


@end
