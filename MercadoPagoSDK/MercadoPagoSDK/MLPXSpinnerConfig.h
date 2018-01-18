//
//  MLPXSpinnerConfig.h
//  Pods
//
//  Created by Cristian Leonel Gibert on 11/17/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, MLPXSpinnerSize) {
	MLPXSpinnerSizeBig,
	MLPXSpinnerSizeSmall
};

/**
 *  Use this interface to create the spinner custom style configuration
 */
@interface MLPXSpinnerConfig : NSObject

@property (nonatomic, strong) UIColor * _Nullable primaryColor;
@property (nonatomic, strong) UIColor * _Nullable secondaryColor;
@property (nonatomic) MLPXSpinnerSize spinnerSize;

- (id _Nullable )init __attribute__((unavailable("Must use initWithSize:primaryColor:secondaryColor: instead.")));

- (instancetype _Nullable )initWithSize:(MLPXSpinnerSize)size primaryColor:(nonnull UIColor *)primaryColor secondaryColor:(nonnull UIColor *)secondaryColor;

@end
