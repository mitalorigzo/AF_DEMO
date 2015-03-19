//
//  MyStoreObserver.m
//  StoreKit
//
//  Created by Nirav_@_Origzo on 18/07/14.
//  Copyright (c) 2014 Sunshine Infotech. All rights reserved.
//

#import "MyStoreObserver.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation MyStoreObserver

#pragma mark - SKPaymentTransactionObserver Required Method Here.....

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

#pragma mark - Complete Transaction Method Here.....

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];

    NSLog(@"\n transaction = %@",transaction.payment.productIdentifier);
    
	THIS.boolIsPurchased = TRUE;
	
    [self recordTransaction: transaction];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - Restore Transaction Method Here.....

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];

    NSLog(@"\n transaction = %@",transaction.payment.productIdentifier);
    
    [self recordTransaction: transaction];
	
    THIS.boolIsPurchased = TRUE;
   
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - Failed Transaction Method Here.....

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
	THIS.isAbortedByUser = TRUE;
	
	if (transaction.error.code != SKErrorPaymentCancelled)
    {
        if (!THIS.isErrorView)
        {
            THIS.isErrorView = TRUE;
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",transaction.error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
		return;
    }
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - SKPaymentTransactionObserver Optional Method Here.....

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    THIS.isAbortedByUser = TRUE;
    NSLog(@"\n restoreCompletedTransactionsFailedWithError = %@",[error localizedDescription]);
}

#pragma mark - Record Transaction Method Here.....

- (void)recordTransaction:(SKPaymentTransaction *)transaction 
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end