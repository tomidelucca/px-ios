//
// MPSDKLoadingView.h
// MercadoPago
//
// Created by Matias Casanova on 02/10/14.
// Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoadingViewTag 1000

@interface MPSDKLoadingView : UIView

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;
- (id)initWithLoadingColor:(UIColor *)loadingColor;

@end
