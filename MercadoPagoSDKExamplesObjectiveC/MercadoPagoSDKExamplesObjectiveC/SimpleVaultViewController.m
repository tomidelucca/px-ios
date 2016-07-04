//
//  SimpleVaultViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 4/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "SimpleVaultViewController.h"
#import "SimpleVaultFormViewController.h" // dni man


@import MercadoPagoSDK;

@interface SimpleVaultViewController ()

@end

@implementation SimpleVaultViewController

NSArray<PaymentMethod *> *currentPaymentMethods;
PaymentMethod *selectedPaymentMethod;

- (void)viewDidLoad {
    [super viewDidLoad];
    [MPServicesBuilder getPaymentMethods:^(NSArray<PaymentMethod *> *paymentMethods) {
        currentPaymentMethods = paymentMethods;
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentPaymentMethods count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentMethod *pm = currentPaymentMethods[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPPaymentMethodSelection"];
    
    UIImageView* pmIcon = [cell viewWithTag:1];
    pmIcon.image = [MercadoPago getImage:pm._id];
    
    UILabel *pmTitle = [cell viewWithTag:2];
    pmTitle.text = pm.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedPaymentMethod = currentPaymentMethods[indexPath.row];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SimpleVaultFormViewController *simpleFormVc= (SimpleVaultFormViewController*) [segue destinationViewController];
    simpleFormVc.paymentMethod = selectedPaymentMethod;
}


@end
