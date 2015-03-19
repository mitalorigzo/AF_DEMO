//
//  MyStoreObserver.h
//  StoreKit
//
//  Created by Nirav_@_Origzo on 18/07/14.
//  Copyright (c) 2014 Sunshine Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class CarBuilderAppDelegate;

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver>
{
    CarBuilderAppDelegate *objAppDelegate;
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)recordTransaction:(SKPaymentTransaction *)transaction;

@end