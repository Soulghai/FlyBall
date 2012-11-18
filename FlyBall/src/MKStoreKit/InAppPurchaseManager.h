//
//  InAppPurchaseManager.h
//  Expand_It
//
//  Created by Mac Mini on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

#define kInAppPurchaseProUpgradeProductId @"ExpandIt_Test_IAP"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    
    NSMutableArray *purchasableObjects;
}

+(InAppPurchaseManager*) instance;

// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseItem:(NSString *)_itemID;
@end
