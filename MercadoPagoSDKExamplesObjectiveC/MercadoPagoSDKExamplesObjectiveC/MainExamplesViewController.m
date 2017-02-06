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

    // Decoration Preference con colores custom
    DecorationPreference *decorationPreference = [[DecorationPreference alloc] initWithBaseColor:[UIColor greenColor] fontName:@"fontName"];
    [MercadoPagoCheckout setDecorationPreference:decorationPreference];
    
    // Service Preference para seteo de servicio de pago
    NSDictionary *extraParams = @{
                                  @"merchant_access_token" : @"mla-cards-data"
                                  };
    ServicePreference * servicePreference = [[ServicePreference alloc] init];
    [servicePreference setGetCustomerWithBaseURL:@"https://www.mercadopago.com" URI:@"/checkout/examples/getCustomer" additionalInfo:extraParams];
    
    [MercadoPagoCheckout setServicePreference:servicePreference];
    
    //Item *item = [[Item alloc] initWith_id:ITEM_ID title:ITEM_TITLE quantity:ITEM_QUANTITY unitPrice:ITEM_UNIT_PRICE description:nil];
    
    //[CheckoutPreference alloc] initWithItems:NSArray payer:<#(Payer * _Nonnull)#> paymentMethods:<#(PaymentPreference * _Nonnull)#>
    CheckoutPreference * pref = [[CheckoutPreference alloc] initWith_id:@"150216849-c9727554-8d7e-4984-9205-e9fec5b553f9"];
    [[[MercadoPagoCheckout alloc] initWithCheckoutPrefence:pref navigationController:self.navigationController] start];
    
    //[servicePreference setCreatePaymentWithBaseURL:@"baseUrl" URI:@"paymentUri" additionalInfo:extraParams];
   // [MercadoPagoCheckout setServicePreference:servicePreference];
    
    
   
    


}


@end
