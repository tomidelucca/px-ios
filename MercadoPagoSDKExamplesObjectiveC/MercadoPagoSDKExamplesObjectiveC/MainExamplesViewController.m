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

    // Service Preference para seteo de servicio de pago
    ServicePreference *servicePreference = [[ServicePreference alloc] init];
    NSDictionary *extraParams = @{
                                @"key1" : @"value1",
                                @"key2" : @"value2"
    };
    [servicePreference setCreatePaymentWithBaseURL:@"baseUrl" URI:@"paymentUri" additionalInfo:extraParams];
    
    CheckoutPreference * pref = [[CheckoutPreference alloc] initWith_id:@"223362579-96d6c137-02c3-48a2-bf9c-76e2d263c632"];
    
   // [MercadoPagoCheckout setServicePreference:servicePreference];
    [[[MercadoPagoCheckout alloc] initWithCheckoutPrefence:pref navigationController:self.navigationController] start];
}


@end
