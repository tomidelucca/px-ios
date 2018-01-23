//
// MLPXSpinner.h
// MLUI
//
// Created by Julieta Puente on 18/4/16.
// Copyright © 2016 MercadoLibre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPXSpinnerConfig.h"

typedef NS_ENUM (NSInteger, MLPXSpinnerStyle) {
	MLPXSpinnerStyleBlueBig,
	MLPXSpinnerStyleWhiteBig,
	MLPXSpinnerStyleBlueSmall,
	MLPXSpinnerStyleWhiteSmall
};

@interface MLPXSpinner : UIView <CAAnimationDelegate>

/**
 *  Creates a spinner with the selected style
 *
 *  @param style     spinner style
 */
- (id   _Nullable )initWithStyle:(MLPXSpinnerStyle)style __attribute__((deprecated("We recommend start using the initWithConfig:text: instead.")));

/**
 *  Creates a spinner with the selected style and text
 *
 *  @param style     spinner style
 *  @param text      spinner text
 */
- (id _Nullable )initWithStyle:(MLPXSpinnerStyle)style text:(NSString *_Nullable)text __attribute__((deprecated("We recommend start using the initWithConfig:text: instead.")));

/**
 *  Creates a spinner with the desire configuration
 *
 *  @param config    spinner style configuration
 *  @param text      spinner text
 */
- (id _Nullable )initWithConfig:(nonnull MLPXSpinnerConfig *)config text:(NSString *_Nullable)text;

/**
 *  Sets spinner text
 *
 *  @param text      spinner text
 */
- (void)setText:(NSString *_Nullable)spinnerText;

/**
 *  Sets spinner style
 *
 *  @param style     spinner style
 */
- (void)setStyle:(MLPXSpinnerStyle)style __attribute__((deprecated("We recommend start using the setUpSpinnerWithConfig: instead.")));

/**
 *  Sets spinner style configuration
 *
 *  @param config     spinner style configuration
 */
- (void)setUpSpinnerWithConfig:(MLPXSpinnerConfig *_Nullable)config;


- (void)showSpinner;
- (void)hideSpinner;

@end
