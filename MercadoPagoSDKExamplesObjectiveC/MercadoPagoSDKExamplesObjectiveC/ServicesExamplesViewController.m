//
//  ServicesExamplesViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "ServicesExamplesViewController.h"
#import "SavedCardsTableViewController.h"

@interface ServicesExamplesViewController ()

@end

@implementation ServicesExamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self startPaymentMethodsVault];
            break;
        case 1:
            [self startSimpleVault];
            break;
        case 2:
            [self startAdvancedVault];
            break;
        case 3:
            [self startFinalVault];
            break;
        default:
            break;
    }
}

-(void) startPaymentMethodsVault{
    //TODO !!!!!!
    
}

-(void) startSimpleVault{
    
    
//    let simpleVault = ExamplesUtils.startSimpleVaultActivity(MercadoPagoContext.publicKey(), merchantBaseUrl:  ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: MercadoPagoContext.customerURI(), merchantAccessToken: MercadoPagoContext.merchantAccessToken(), paymentPreference: nil) { (paymentMethod, token) in
//        
//    }
//    
//    self.navigationController?.pushViewController(simpleVault, animated: true)
}

-(void) startAdvancedVault{
//    let advancedVault = ExamplesUtils.startAdvancedVaultActivity(MercadoPagoContext.publicKey(), merchantBaseUrl:  ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: MercadoPagoContext.customerURI(), merchantAccessToken: MercadoPagoContext.merchantAccessToken(), amount: 1000, paymentPreference: nil, callback: { (paymentMethod, token, issuer, installments) in
//        
//    })
//    
//    self.navigationController?.pushViewController(advancedVault, animated: true)
}


-(void) startFinalVault{
//    let finalVault = ExamplesUtils.startFinalVaultActivity(MercadoPagoContext.publicKey(), merchantBaseUrl:  ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantGetCustomerUri: MercadoPagoContext.customerURI(), merchantAccessToken: MercadoPagoContext.merchantAccessToken(), amount: 1000, paymentPreference: nil) { (paymentMethod, token, issuer, installments) in
//        
//    }
//    allowInstallmentsSegue
//    self.navigationController?.pushViewController(finalVault, animated: true)
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier  isEqual: @"allowInstallmentsSegue"]) {
        SavedCardsTableViewController *savedCardsVC = [segue destinationViewController];
        savedCardsVC.allowInstallmentsSeletion = YES;
    }
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

@end
