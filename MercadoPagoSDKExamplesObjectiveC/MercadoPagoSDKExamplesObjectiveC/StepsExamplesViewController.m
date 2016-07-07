//
//  StepsExamplesViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "StepsExamplesViewController.h"
#import "ExampleUtils.h"
@import MercadoPagoSDK;

@interface StepsExamplesViewController ()

@end

@implementation StepsExamplesViewController

PaymentMethod *paymentMethod;

- (void)viewDidLoad {
    [super viewDidLoad];
    paymentMethod = [[PaymentMethod alloc] init];
    paymentMethod._id = @"visa";
    paymentMethod.name = @"visa";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self startPaymentVault];
            break;
        case 1:
            [self startCardFlow];
            break;
        case 2:
            [self startCardForm];
            break;
        case 3:
            [self startPaymentMethods];
            break;
        case 4:
            [self statIssuersStep];
            break;
        case 5:
            [self startInstallmentsStep];
            break;
        case 6:
            [self createPayment];
            break;
        default:
            break;
    }
}

- (void)startPaymentVault {
    UIViewController *paymentVaultVC = [MPFlowBuilder startPaymentVaultViewController:AMOUNT currencyId:CURRENCY paymentPreference:nil callback:^(PaymentMethod *paymentMethod, Token *token, Issuer *issuer, PayerCost *payerCost) {
        
    }];
    [self presentViewController:paymentVaultVC animated:YES completion:^{}];

}

- (void)startCardFlow {
    UIViewController *cf = [MPFlowBuilder startCardFlow:nil amount:AMOUNT paymentMethods:nil callback:^(PaymentMethod *paymentMethod, Token *token, Issuer *issuer, PayerCost *payerCost) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } callbackCancel:^{
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    [self presentViewController:cf animated:YES completion:^{}];

}

-(void)startCardForm {
    UINavigationController *cf = [MPStepBuilder startCreditCardForm:nil amount:1000 paymentMethods:nil token:nil callback:^(PaymentMethod *pm, Token *token, Issuer *issuer) {
         [self dismissViewControllerAnimated:YES completion:^{}];
    } callbackCancel:^{
       [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    [self presentViewController:cf animated:YES completion:^{}];
    
}

- (void)startPaymentMethods {
    
    UIViewController *paymentsStep = [MPStepBuilder startPaymentMethodsStep:nil callback:^(PaymentMethod *paymentMethod) {
      
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:paymentsStep animated:YES];

}

- (void)statIssuersStep {
    UIViewController *issuersVC = [MPStepBuilder startIssuersStep:paymentMethod callback:^(Issuer *issuer) {
      // [self dismissViewControllerAnimated:YES completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:issuersVC animated:YES];
    
}

- (void)startInstallmentsStep{
    
     UIViewController *installmentVC =[MPStepBuilder startInstallmentsStep:nil paymentPreference:nil amount:10000 issuer:nil paymentMethodId:@"visa" callback:^(PayerCost * _Nullable payerCost) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
     [self.navigationController pushViewController:installmentVC animated:YES];
}

- (void)createPayment {
    
    [MercadoPagoContext setPublicKey:MERCHANT_PUBLIC_KEY];
    [MercadoPagoContext setBaseURL:MERCHANT_MOCK_BASE_URL];
    [MercadoPagoContext setPaymentURI:MERCHANT_MOCK_CREATE_PAYMENT_URI];
    
    Item *item = [[Item alloc] initWith_id:ITEM_ID title:ITEM_TITLE quantity:ITEM_QUANTITY unitPrice:ITEM_UNIT_PRICE];


    MerchantPayment *merchantPayment = [[MerchantPayment init] alloc];
    merchantPayment.items = [NSArray arrayWithObject:item];
    merchantPayment.installments = 3;
    merchantPayment.issuer = nil;;
    merchantPayment.cardTokenId = @"cardTokenId";
    
    [MerchantServer createPayment:merchantPayment success:^(Payment *payment) {
        
    } failure:^(NSError *error) {
        
    }];
    
}


@end
