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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        
    } callbackCancel:^{
        
    }];
    [self presentViewController:cf animated:YES completion:^{}];

}

-(void)startCardForm {
//    var cf : UINavigationController!
//    cf = MPStepBuilder.startCreditCardForm(amount: 1000, callback: { (paymentMethod, token, issuer) in
//        cf!.dismissViewControllerAnimated(true, completion: {})
//    }, callbackCancel : {
//        cf!.dismissViewControllerAnimated(true, completion: {})
//    })
//    
//    self.presentViewController(cf, animated: true, completion: {})
//}
}

- (void)startPaymentMethods {
//
//    let pms = MPStepBuilder.startPaymentMethodsStep(nil) { (paymentMethod) in
//        
//    }
//    self.navigationController?.pushViewController(pms, animated: true)
}

- (void)statIssuersStep {
//    let issuersVC = MPStepBuilder.startIssuersStep(self.paymentMethod) { (issuer) in
//        
//    }
//    self.navigationController?.pushViewController(issuersVC, animated: true)
//    
}

- (void)startInstallmentsStep{
}

- (void)createPayment{
    
//    MercadoPagoContext.setBaseURL("http://server.com")
//    MercadoPagoContext.setPaymentURI("/payment_uri")
//    
//    let item : Item = Item(_id: ExamplesUtils.ITEM_ID, title: ExamplesUtils.ITEM_TITLE, quantity: ExamplesUtils.ITEM_QUANTITY,
//                           unitPrice: ExamplesUtils.ITEM_UNIT_PRICE)
//    
//    //CardIssuer is optional
//    let merchantPayment : MerchantPayment = MerchantPayment(items: [item], installments: 3, cardIssuer: nil, tokenId: "tokenId", paymentMethod: self.paymentMethod, campaignId: 0)
//    
//    
//    MerchantServer.createPayment(merchantPayment, success: { (payment) in
//        
//    }) { (error) in
//        
//    }
    
}


@end
