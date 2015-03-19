//
//  AppDelegate.h
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

#import "MBProgressHUD.h"
#import "Reachability.h"

#import "MyStoreObserver.h"

#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"

#import "Chartboost.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate,AppsfireAdSDKDelegate,ChartboostDelegate,RevMobAdsDelegate>
{
    Reachability *internetReach;
    
    MBProgressHUD *HUD;
    
    ADBannerView *bannerView;
}


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ADBannerView *bannerView;
@property (nonatomic, strong) MyStoreObserver *observer;


@property (nonatomic, assign) BOOL isreachble;
@property (nonatomic, readwrite) BOOL boolIsPurchased;
@property (nonatomic, readwrite) BOOL isAbortedByUser;
@property (readwrite, nonatomic) BOOL isErrorView;


-(NSString *)convertHTML:(NSString *)html;
-(void)showProgressView:(NSString *)strMessage;
-(void)hideProgressView;

@end

