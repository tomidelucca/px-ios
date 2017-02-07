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
                                  @"auth_code" : @"mockAuthCode"
                                  };
    ServicePreference * servicePreference = [[ServicePreference alloc] init];
    
    
    [servicePreference setCreatePaymentWithBaseURL:@"https://private-0d59c-mercadopagoexamples.apiary-mock.com" URI:@"/create_payment" additionalInfo:extraParams];
    
    [MercadoPagoCheckout setServicePreference:servicePreference];
    
    [servicePreference setGetCustomerWithBaseURL:@"https://www.mercadopago.com" URI:@"/checkout/examples/getCustomer" additionalInfo:extraParams];
    
    Item *item = [[Item alloc] initWith_id:@"itemId" title:@"item title" quantity:100 unitPrice:10 description:nil];
    Item *item2 = [[Item alloc] initWith_id:@"itemId2" title:@"item title 2" quantity:2 unitPrice:2 description:@"item description"];
    Payer *payer = [[Payer alloc] initWith_id:@"payerId" email:@"payer@email.com" type:nil identification:nil];
    
    NSArray *items = [NSArray arrayWithObjects:item, item2, nil];
    
    PaymentPreference *paymentExclusions = [[PaymentPreference alloc] init];
    paymentExclusions.excludedPaymentTypeIds = [NSSet setWithObjects:@"atm", @"ticket", nil];
    //CheckoutPreference * pref = [[CheckoutPreference alloc] initWithItems:items payer:payer paymentMethods:paymentExclusions];
    
    //CheckoutPreference * pref = [[CheckoutPreference alloc] initWithItems:<#(NSArray<Item *> * _Nonnull)#> payer:<#(Payer * _Nonnull)#> paymentMethods:<#(PaymentPreference * _Nullable)#>
    
        CheckoutPreference * pref = [[CheckoutPreference alloc] initWith_id:@"150216849-68645cbb-dfe6-4410-bfd6-6e5aa33d8a33"];
    [[[MercadoPagoCheckout alloc] initWithCheckoutPrefence:pref navigationController:self.navigationController] start];
    
    //[servicePreference setCreatePaymentWithBaseURL:@"baseUrl" URI:@"paymentUri" additionalInfo:extraParams];
   // [MercadoPagoCheckout setServicePreference:servicePreference];
    
    
   
    


}


@end
