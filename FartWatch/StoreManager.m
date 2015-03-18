//
//  StoreManager.m
//  Impression
//
//  Created by Jason Fieldman on 4/15/14.
//  Copyright (c) 2014 Jason Fieldman. All rights reserved.
//

#import "StoreManager.h"
#import "MainViewController.h"
#import <UIAlertView+BlocksKit.h>

@implementation SKProduct (pricing)
- (NSString*) priceWithSymbol {
	if ([self.price floatValue] == 0) return @"FREE";
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:self.priceLocale];
	return [numberFormatter stringFromNumber:self.price];
}
@end

@implementation StoreManager

SINGLETON_IMPL(StoreManager);

- (id) init {
	if ((self = [super init])) {
		/* Payments */
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}


- (BOOL)adsPurchased {
//	PersistentDictionary *dic = [PersistentDictionary dictionaryWithName:@"savemenu"];
//	return [dic.dictionary[@"save"] boolValue];
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"adsPurchased"];
}

- (void)setAdsPurchased:(BOOL)adsPurchased {
//	PersistentDictionary *dic = [PersistentDictionary dictionaryWithName:@"savemenu"];
//	dic.dictionary[@"save"] = @(YES);
//	[dic saveToFile];
    
    [[NSUserDefaults standardUserDefaults] setBool:adsPurchased forKey:@"adsPurchased"];
}


- (void) updatePurchaseInfo {
	/* Don't need to do this if already purchased */
	if (self.adsPurchased && self.customPurchased) return;
	
	SKProductsRequest *productsRequest;
	NSSet *productIdentifiers = [NSSet setWithObjects: @"CustomMessages", @"RemoveAds", nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
	
//	EXLog(PURCHASE, INFO, @"Sent in-app purchase item verification");
}

//- (void) initiatePurchase {
//
//	SKPayment *payment = [SKPayment paymentWithProduct:_saveMenuProduct];
//	[[SKPaymentQueue defaultQueue] addPayment:payment];
//	
//	//[Flurry logEvent:@"InitiatePackPurchase" withParameters:@{ @"packId":packId }];
//}


-(void) purchaseAds
{
    SKPayment *payment = [SKPayment paymentWithProduct:_adsProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
#warning track data
    	//[Flurry logEvent:@"InitiatePackPurchase" withParameters:@{ @"packId":packId }];
}

-(void) purchaseCustom
{
    SKPayment *payment = [SKPayment paymentWithProduct:_customProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    //[Flurry logEvent:@"InitiatePackPurchase" withParameters:@{ @"packId":packId }];
}


- (void) restorePurchase {
//	EXLog(PURCHASE, INFO, @"In-app purchase restore");
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
	
	//[Flurry logEvent:@"InitiateRestorePurchase"];
}



#pragma mark SKProductsRequestDelegate methods


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
		
//	EXLog(PURCHASE, INFO, @"Received in-app purchase item verification");
	
    NSArray *products = response.products;
	for (SKProduct *product in products) {
//		EXLog(PURCHASE, INFO, @"> %@: %@", product.productIdentifier, [product priceWithSymbol]);
        
        if ([product.productIdentifier isEqualToString:@"RemoveAds"])
        {
            _adsPrice = [product priceWithSymbol];
            _adsProduct = product;
        }
        else if([product.productIdentifier isEqualToString:@"CustomMessages"])
        {
            _customPrice = [product priceWithSymbol];
            _customProduct = product;
        }
	}
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
}



#pragma mark SKPaymentTransactionObserver methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	
	for (SKPaymentTransaction *transaction in transactions) {
		
//		EXLog(PURCHASE, INFO, @"Processing transaction for [%@]: %d", transaction.payment.productIdentifier, (int)transaction.transactionState);
		
		if (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored) {
			
            if([transaction.payment.productIdentifier isEqualToString:@"RemoveAds"])
            {
                self.adsPurchased = YES;
                
                [UIAlertView bk_showAlertViewWithTitle:@"Ads Removed" message:@"Removed all ads from the app!" cancelButtonTitle:@"Awesome!" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    NSLog(@"Ads Purchased");
                }];
                
            }
            else if([transaction.payment.productIdentifier isEqualToString:@"CustomMessages"])
            {
                self.customPurchased = YES;
                
                [UIAlertView bk_showAlertViewWithTitle:@"Custom Messages" message:@"You can now send custom messages with your farts!" cancelButtonTitle:@"Awesome!" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    NSLog(@"Custom Messages Purchased");
                }];
            }
            else { NSLog(@"ERROR"); }

            
//			EXLog(PURCHASE, ERR, @"> Transaction complete");
//			[[MainViewController sharedInstance] showModalMessage:@"Save Menu Unlocked!"];
//			self.saveMenuPurchased = YES;
//			[Flurry logEvent:@"Purchase_Successful"];
				
		} else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
//#warning send block alert maybe
            
            [UIAlertView bk_showAlertViewWithTitle:@"Purchase Failed" message:@"Failed to purchase" cancelButtonTitle:@"Okay" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                NSLog(@"Purchase Failed");
            }];
            
//			EXLog(PURCHASE, ERR, @"> Transaction error: %@", transaction.error);
//			[[MainViewController sharedInstance] showModalMessage:@"Purchase failed :("];
			
		}
        
		if (transaction.transactionState != SKPaymentTransactionStatePurchasing) {
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		}
		
	}

}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
//	EXLog(PURCHASE, ERR, @"paymentQueue:restoreCompletedTransactionsFailedWithError: %@", error);
	    
    [UIAlertView bk_showAlertViewWithTitle:@"Restore Purchases Failed" message:@"Failed to restore any purchases" cancelButtonTitle:@"Okay" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"Restore Failed");
    }];
    
//	[[MainViewController sharedInstance] showModalMessage:@"Restore failed :("];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
//	EXLog(PURCHASE, DBG, @"paymentQueueRestoreCompletedTransactionsFinished:");
    
    [UIAlertView bk_showAlertViewWithTitle:@"Restore Purchases" message:@"Restored your purchases" cancelButtonTitle:@"Awesome!" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"Restore Successful");
    }];
    
//	[[MainViewController sharedInstance] showModalMessage:@"Purchase Restored!"];
//	self.saveMenuPurchased = YES;
//	[Flurry logEvent:@"Restore_Successful"];
}


@end
