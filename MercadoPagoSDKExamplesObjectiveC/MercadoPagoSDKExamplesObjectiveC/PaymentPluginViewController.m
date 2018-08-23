//
//  PaymentPluginViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Juan sebastian Sanzone on 18/12/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import "PaymentPluginViewController.h"
#import "MercadoPagoSDKExamplesObjectiveC-Swift.h"

@interface PaymentPluginViewController ()

@property (strong, nonatomic) PXPaymentPluginNavigationHandler * paymentNavigationHandler;

@end

@implementation PaymentPluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)doPayment {
    [self.paymentNavigationHandler showLoading];

    double delay = 3.0;
    dispatch_time_t tm = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(tm, dispatch_get_main_queue(), ^(void) {

        [self.paymentNavigationHandler hideLoading];

        CustomComponentText* component = [[CustomComponentText alloc] init];
        PXComponentAction* popeame = [[PXComponentAction alloc] initWithLabel:@"Continuar" action:^{
            //[self.paymentNavigationHandler cancel];
        }];
        PXComponentAction* printeaEnConsola = [[PXComponentAction alloc] initWithLabel:@"Intentar nuevamente" action:^{
            NSLog(@"print !!! action!!");
        }];

        PXBusinessResult* businessResult = [[PXBusinessResult alloc] initWithReceiptId:@"1879867544" status:PXBusinessResultStatusAPPROVED title:@"¡Listo! Ya pagaste en YPF" subtitle:nil icon:[UIImage imageNamed:@"ypf"] mainAction:nil secondaryAction:nil helpMessage:nil showPaymentMethod:YES statementDescription:nil imageUrl:@"https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/YPF.svg/2000px-YPF.svg.png" topCustomView:[component render] bottomCustomView: nil paymentStatus:@"" paymentStatusDetail:@""];
        [self.paymentNavigationHandler didFinishPaymentWithBusinessResult:businessResult];
    });
}

#pragma mark - Payment Plugin implementation.
- (UIView * _Nullable)paymentProcessorView {
    return nil;
    // return self.view;
}

- (BOOL)supportWithCheckoutStore:(PXCheckoutStore *)checkoutStore {
    return true;
}

- (void)paymentNavigationHandlerWithNavigationHandler:(PXPaymentPluginNavigationHandler *)navigationHandler {
    self.paymentNavigationHandler = navigationHandler;
    [self doPayment];
}

-(void)createPaymentWithCheckoutStore:(PXCheckoutStore * _Nonnull)store handler:(id <PXPaymentFlowHandlerProtocol>)handler successWithBusinessResult:(void (^)(PXBusinessResult *))successWithBusinessResult successWithPaymentResult:(void (^)(PXPaymentPluginResult *))successWithPaymentResult {
    PXPaymentPluginResult* result = [[PXPaymentPluginResult alloc] initWithStatus:@"approved" statusDetail:@"" receiptId: @""];
    successWithPaymentResult(result);
}

@end
