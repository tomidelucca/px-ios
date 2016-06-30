//
//  ViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 30/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "MainExamplesViewController.h"
#import "ComponentTableViewCell.h"

@interface MainExamplesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainExamplesTable;

@end

@implementation MainExamplesViewController 

    NSArray *examplesMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    examplesMenu = [NSArray arrayWithObjects:@{@"title" : @"Checkout", @"image" : @"PlugNplay"},@{@"title" : @"ComponentsUI", @"image" : @"Puzzle"}, @{@"title" : @"Services", @"image" : @"Ninja"}, nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [examplesMenu count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComponentTableViewCell *cell = [self.mainExamplesTable dequeueReusableCellWithIdentifier:@"componentExampleCell"];
    if (cell == nil) {
        cell = [[ComponentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%i", indexPath.row]];
    }
    NSString *title = examplesMenu[indexPath.row][@"title"];
    NSString *iconName = examplesMenu[indexPath.row][@"image"];
    [cell initWith:title iconName:iconName];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
