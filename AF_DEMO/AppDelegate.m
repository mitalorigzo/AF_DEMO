//
//  AppDelegate.m
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "iRate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize bannerView;
@synthesize observer;
@synthesize isreachble;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //---------------------------------//
    
    // RevMob
    [RevMobAds startSessionWithAppID:REVMOB_ID andDelegate:self];
    
    //---------------------------------//
    
    // Internet Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:self userInfo:nil];
    
    //---------------------------------//
    
    // iRate
    [iRate sharedInstance].applicationBundleID = @"App Bundle Id";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
    
    //--------------------------------//
    
    // Appsfire
    [AppsfireAdSDK setDelegate:self];
    
    // enable debug mode for testing
    #if DEBUG
    //#warning In Release mode, make sure to set the value below to NO.
    [AppsfireAdSDK setDebugModeEnabled:YES];
    #endif
    
    // sdk connect
    //#error Add your Appsfire SDK Token and Secret key below.
    NSError *error;
    error = [AppsfireSDK connectWithSDKToken:@"2A6CB31D3D243233C6D2CDEC0F7CA267" secretKey:@"d3982cb5c49c2f7ae3197ac8b21c6ae3" features:AFSDKFeatureMonetization parameters:nil];
    if (error != nil)
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);

    //--------------------------------//

    // InApp Purchase
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger isPurchased = [userDefaults integerForKey:@"ISPURCHASED"];
    if(isPurchased != 1)
    {
        observer = [[MyStoreObserver alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    }
    
    //--------------------------------//
    
    //iAd BannerView
    if(isreachble)
    {
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)])
        {
            bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        }
        else
        {
            bannerView = [[ADBannerView alloc] init] ;
        }
    }
    
    //--------------------------------//
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Chartboost
    [Chartboost startWithAppId:@"4f21c409cd1cb2fb7000001b" appSignature:@"92e2de2fd7070327bdeb54c15a5295309c6fcd2d" delegate:self];
    //[[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Convert HTML to PLAIN text

-(NSString *)convertHTML:(NSString *)html
{
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO)
    {
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}



#pragma mark Internet Reachability

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            isreachble = FALSE;
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            isreachble = TRUE;
            NSLog(@"The internet is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            isreachble = TRUE;
            NSLog(@"The internet is working via WWAN.");
            break;
        }
    }
}

#pragma mark MBProgressHUD

-(void)showProgressView : (NSString *)strMessage
{
    HUD = [[MBProgressHUD alloc]initWithView:self.window];
    HUD.delegate = self;
    HUD.taskInProgress = YES;
    [HUD show:YES];
    HUD.labelText = strMessage;
    [self.window addSubview:HUD];
}

-(void)hideProgressView
{
    HUD.taskInProgress = NO;
    [HUD hide:YES];
}

#pragma mark - Appsfire Ad SDK Delegate Methods

- (void)modalAdsRefreshedAndAvailable
{
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // if you want to show ads as soon as they are ready, uncomment the following lines.
    
    if ([AppsfireAdSDK isThereAModalAdAvailableForType:AFAdSDKModalTypeUraMaki] == AFAdSDKAdAvailabilityYes && ![AppsfireAdSDK isModalAdDisplayed])
    {
        [AppsfireAdSDK requestModalAd:AFAdSDKModalTypeSushi withController:[UIApplication sharedApplication].keyWindow.rootViewController withDelegate:nil];
    }
}

- (void)modalAdsRefreshedAndNotAvailable
{
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}




@end
