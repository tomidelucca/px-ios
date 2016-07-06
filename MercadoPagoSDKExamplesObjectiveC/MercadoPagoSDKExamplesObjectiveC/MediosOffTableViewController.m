//
//  MediosOffTableViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Demian Tejo on 7/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "MediosOffTableViewController.h"


@implementation MediosOffTableViewController

@synthesize mediosOffArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSMutableSet* conjunto = [[NSMutableSet alloc] init];
    [conjunto addObject:@"credit_card"];
    [conjunto addObject:@"debit_card"];

    
    
   
    [MPServicesBuilder getPaymentMethods:^(NSArray<PaymentMethod *> *paymentMethods) {
        self.mediosOffArray = [[NSMutableArray alloc]init];
        
        [paymentMethods enumerateObjectsUsingBlock:^(PaymentMethod * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(obj.paymentTypeId);
            if (![conjunto containsObject:obj.paymentTypeId]){
                [self.mediosOffArray addObject:obj];
            }
        }];
        [[self tableView] reloadData];
    } failure:^(NSError *error) {
        
    }];
    
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

    return mediosOffArray.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediosOffCell" forIndexPath:indexPath];
   
    UIImageView* image = [cell viewWithTag:1];
    UILabel* label = [cell viewWithTag:2];
    
    label.text = [[self.mediosOffArray objectAtIndex:indexPath.row] name];
    image.image = [MercadoPago getImage:[self.mediosOffArray objectAtIndex:indexPath.row]._id];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog([[self.mediosOffArray objectAtIndex:indexPath.row] name]);
    
    [self performSegueWithIdentifier:@"unwindFromOff" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
