//
//  SimpleVaultFormViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 4/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "SimpleVaultFormViewController.h"
#import "InstallmentsTableViewController.h"

@implementation SimpleVaultFormViewController 

@synthesize paymentMethod;
@synthesize customerCard;
@synthesize allowInstallmentsSelection;
@synthesize amount;
@synthesize selectedPayerCost;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = (allowInstallmentsSelection) ? 1 : 0;
    if (self.customerCard != nil) {
        return rows + 2;
    }
    return rows + 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            if (self.customerCard == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPCardNumber"];
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPCustomerCard"];
            return cell;
        }
            break;
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPSecurityCode"];
            return cell;
        }
            break;
        case 2:{
            if (self.customerCard == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPExpirationDate"];
                return cell;
            } else if (self.selectedPayerCost == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallmentsSelection"];
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallment"];
            cell.textLabel.text = self.selectedPayerCost.recommendedMessage;
            return cell;

        }
            break;
        case 3:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPCardholderName"];
            return cell;
        }
            break;
        case 4:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPIdentification"];
            return cell;
        }
            break;
        case 5:{
            if (self.selectedPayerCost == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallmentsSelection"];
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallment"];
            cell.textLabel.text = self.selectedPayerCost.recommendedMessage;
            return cell;
            
        }
        break;
        default:
            break;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"displayInstallmentsSegue"]) {
        InstallmentsTableViewController *installmentsVC = [segue destinationViewController];
        installmentsVC.card = customerCard;
        installmentsVC.amount = self.amount;
    }
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    InstallmentsTableViewController *installmentsVC = [segue sourceViewController];
    self.selectedPayerCost = installmentsVC.selectedPayerCost;
    [[self tableView] reloadData];
    
}


@end
