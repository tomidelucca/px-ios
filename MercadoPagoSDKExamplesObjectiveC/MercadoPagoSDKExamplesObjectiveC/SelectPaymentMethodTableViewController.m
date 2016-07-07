//
//  SelectPaymentMethodTableViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 5/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "SelectPaymentMethodTableViewController.h"
#import "SimpleVaultViewController.h"

@interface SelectPaymentMethodTableViewController ()

@end

@implementation SelectPaymentMethodTableViewController

@synthesize allowInstallmentsSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SimpleVaultViewController *simpleVault = [segue destinationViewController];
    simpleVault.allowInstallmentsSelection = self.allowInstallmentsSelection;

}


@end
