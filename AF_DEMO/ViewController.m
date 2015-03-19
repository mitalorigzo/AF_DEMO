//
//  ViewController.m
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//


/*-------------------------------------------------------
 
 This Demo contains:-
 
 -> Web Service Communication Class using AFNetworking
 -> Convert HTML to PLAIN text
 -> MBProgressHUD
 -> Reachability
 -> Facebook, Twitter, Mail & Message Sharing
 -> iRate
 -> AppsFire
 -> Ad Mob
 -> iAd
 -> Chartboost
 -> inApp Purchase
 -------------------------------------------------------*/


#import "ViewController.h"
#import "WebService.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "CJSONDeserializer.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize sharedAdMobBannerView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Ad Mob
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger isPurchased = [userDefaults integerForKey:@"ISPURCHASED"];
    if (isPurchased != 1)
    {
        [self loadGadRequest];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // iAd bannerView
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger isPurchased = [userDefaults integerForKey:@"ISPURCHASED"];
    if(isPurchased != 1)
    {
        THIS.bannerView.delegate = self;
        
        if (IS_IPAD)
        {
            THIS.bannerView.frame = CGRectMake(0, 958, 768, 50);
        }
        else
        {
            if(IPHONE_5)
            {
                THIS.bannerView.frame = CGRectMake(0, 518, 320, 50);
            }
            else
            {
                THIS.bannerView.frame = CGRectMake(0, 430, 320, 50);
            }
        }
        
        THIS.bannerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:THIS.bannerView];
        [self.view bringSubviewToFront:THIS.bannerView];
    }
    else
    {
        THIS.bannerView.hidden = TRUE;
        sharedAdMobBannerView.hidden = TRUE;
    }
}

#pragma mark ----- Web Service Call -----

-(IBAction)btnWebServiceClicked:(id)sender
{
    if(THIS.isreachble == FALSE)
    {
        ALERT(@"Please check your internet connection.");
    }
    else
    {
        [THIS showProgressView:@"Loading"];
        
        NSMutableDictionary *reqDict = [[NSMutableDictionary alloc]init];
        [reqDict setObject:@"admin" forKey:@"username"];
        [reqDict setObject:@"admin" forKey:@"password"];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [[WebService shareWebService] userAuthentication:reqDict success:^(id jsonObject)
            {
                 [THIS hideProgressView];
                 
                 CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
                 
                 NSMutableDictionary *resDict = [[NSMutableDictionary alloc]initWithDictionary:[jsonDeserializer deserializeAsDictionary:jsonObject error:nil]];
                 
                 NSLog(@"Response Dict--->%@",resDict);
            }
            failure:^(NSError *error)
            {
                 ALERT(@"Error");
                 [THIS hideProgressView];
                 NSLog(@"Error--->%@",error);
            }];
        });
    }
}


#pragma mark ----- Facebook Sharing -----

-(IBAction)btnFacebookClicked:(id)sender
{
    if(THIS.isreachble == FALSE)
    {
        ALERT(@"Please check your internet connection.");
    }
    else
    {
        SLComposeViewController *fbObj = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Failure");
            }
            else
            {
                NSLog(@"Success");
            }
            [fbObj dismissViewControllerAnimated:YES completion:nil];
        };
        
        fbObj.completionHandler =myBlock;
        
        [fbObj setInitialText:@"Test"];
        [fbObj addURL:[NSURL URLWithString:@"http://www.test.com"]];
        [fbObj addImage:[UIImage imageNamed:@"facebook.png"]];

        
        [self presentViewController:fbObj animated:YES completion:nil];
    }
}

#pragma mark ----- Twitter Sharing -----

-(IBAction)btnTwitterClicked:(id)sender
{
    if(THIS.isreachble == FALSE)
    {
        ALERT(@"Please check your internet connection.");
    }
    else
    {
        SLComposeViewController *twtObj = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twtObj setInitialText:@"test"];
        [self presentViewController:twtObj animated:YES completion:nil];
    }
}

#pragma mark ----- Mail Sharing -----

-(IBAction)btnMailClicked:(id)sender
{
    if(THIS.isreachble == FALSE)
    {
        ALERT(@"Please check your internet connection.");
    }
    else
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailObj = [[MFMailComposeViewController alloc] init];
            mailObj.mailComposeDelegate = self;
            [mailObj setSubject:@"Subject"];
            //[mailObj setMessageBody:@"Body" isHTML:NO];
            //[mailObj setToRecipients:@[@"test@gmail.com"]];
            
            [self presentViewController:mailObj animated:YES completion:nil];
        }
        else
        {
            ALERT(@"This device cannot send email.");
        }
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ----- Message Sharing -----

-(IBAction)btnSmsClicked:(id)sender
{
    if(THIS.isreachble == FALSE)
    {
        ALERT(@"Please check your internet connection.");
    }
    else
    {
        if(![MFMessageComposeViewController canSendText])
        {
            ALERT(@"Your device doesn't support SMS!");
            return;
        }
    
        NSArray *recipents = @[@"9999988888", @"8888877777"];
        NSString *message = @"Test SMS!";
    
        MFMessageComposeViewController *messageObj = [[MFMessageComposeViewController alloc] init];
        messageObj.messageComposeDelegate = self;
        [messageObj setRecipients:recipents];
        [messageObj setBody:message];
    
        [self presentViewController:messageObj animated:YES completion:nil];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            ALERT(@"Failed to send SMS!");
            break;
        }
            
        case MessageComposeResultSent:
        {
            ALERT(@"Successfully sent SMS!");
            break;
        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----- inApp Purchase -----

-(IBAction)btnRestoreClicked:(id)sender
{
    if(THIS.isreachble)
    {
        [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
        
        if (restoreTImer || [restoreTImer isValid])
        {
            [restoreTImer invalidate];
            restoreTImer = nil;
        }
        
        THIS.boolIsPurchased = FALSE;
        THIS.isAbortedByUser = FALSE;
        
        [THIS showProgressView:@""];
        
        self.view.userInteractionEnabled = FALSE;
        
        restoreTImer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(restoreTransaction) userInfo:nil repeats:YES];
    }
    else
    {
        ALERT(@"Internet Connection is not available..!");
    }
}

-(IBAction)btnPurchaseClicked:(id)sender
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger isPurchased = [userDefaults integerForKey:@"ISPURCHASED"];
    if(isPurchased == 1)
    {
        ALERT(@"You have already Purchased!");
    }
    else
    {
        if(THIS.isreachble)
        {
            NSLog(@"\n purchaseButtonClicked");
            
            THIS.boolIsPurchased = FALSE;
            THIS.isAbortedByUser = FALSE;
            
            [THIS showProgressView:@""];
            
            self.view.userInteractionEnabled = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startPurchase) userInfo:nil repeats:NO];
        }
        else
        {
            ALERT(@"Internet Connection is not available..!");
        }
    }
}

-(void)restoreTransaction
{
    if(THIS.boolIsPurchased)
    {
        NSLog(@"\n item ispurchased properly..%d", THIS.boolIsPurchased);
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:1 forKey:@"ISPURCHASED"];
        [userDefaults synchronize];
        
        THIS.bannerView.hidden = TRUE;
        
        
        [self.view sendSubviewToBack:THIS.bannerView];
        
        NSInteger isPurchased = [userDefaults integerForKey:@"ISPURCHASED"];
        NSLog(@"\n isPurchased..%ld", (long)isPurchased);
        
        [THIS hideProgressView];
        [restoreTImer invalidate];
        restoreTImer = nil;
        
        self.view.userInteractionEnabled = TRUE;
        
        //btnPurchase.hidden = TRUE;
        //btnRestore.hidden = TRUE;
    }
    else
    {
        if(THIS.isAbortedByUser == 1 || !THIS.isreachble)
        {
            NSLog(@"\n objAppDelegate.isAbortedByUser");
            
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
            
            [THIS hideProgressView];
            
            self.view.userInteractionEnabled = TRUE;
            
            [restoreTImer invalidate];
            restoreTImer = nil;
        }
    }
}

-(void)startPurchase
{
    NSLog(@"\n start Purchase");
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveResponse) name:@"didReciveResponse" object:nil ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReciveResponse" object:self];
}

-(void)didReciveResponse
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReciveResponse" object:nil];
    
    NSLog(@"\n didReciveResponse");
    
    THIS.boolIsPurchased = FALSE;
    
    [self requestProductData];
    
    if (objTimer || [objTimer isValid])
    {
        [objTimer invalidate];
        objTimer = nil;
    }
    
    objTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(isPurchaseCompleted) userInfo:nil repeats:YES];
}

-(void)requestProductData
{
    NSLog(@"\n requestProductData");
    
    if ([SKPaymentQueue canMakePayments])
    {
        requestSK = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:ProductIdentifier]];
        requestSK.delegate = self;
        [requestSK start];
    }
    else
    {
        [THIS hideProgressView];
        
        self.view.userInteractionEnabled = TRUE;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"InApp Purchase is disabled on your device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        if (objTimer || [objTimer isValid])
        {
            [objTimer invalidate];
            objTimer = nil;
        }
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"\n didReceiveResponse");
    
    NSArray *invalidProudcts = response.invalidProductIdentifiers;
    
    NSLog(@"\n Products = %@", response.products);
    NSLog(@"\n isAccessibilityElement = %d", response.isAccessibilityElement);
    NSLog(@"\n invalidProudcts = %@", invalidProudcts);
    
    if ([invalidProudcts count] != 0)
    {
        [THIS hideProgressView];
        
        self.view.userInteractionEnabled = TRUE;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Product" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"Products inValid");
        
        THIS.isAbortedByUser = 1;
        
        if ( objTimer || [objTimer isValid])
        {
            [objTimer invalidate];
            objTimer = nil;
        }
        
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    }
    else
    {
        NSLog(@"\n valid product.. = %@", invalidProudcts);
        
        SKPayment *payment;
        payment = [SKPayment paymentWithProductIdentifier:ProductIdentifier];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        NSLog(@"Products Valid");
    }
}

-(void)isPurchaseCompleted
{
    if(THIS.boolIsPurchased)
    {
        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:1 forKey:@"ISPURCHASED"];
        [userDefaults synchronize];
        
        NSInteger isPurchased = [userDefaults integerForKey:@"ISPURCHASED"];
        NSLog(@"\n isPurchased..%ld", (long)isPurchased);
        
        THIS.bannerView.hidden = TRUE;
        
        [self.view sendSubviewToBack:THIS.bannerView];
        
        [THIS hideProgressView];
        
        self.view.userInteractionEnabled = TRUE;
        
        [objTimer invalidate];
        objTimer = nil;
    }
    else
    {
        if(THIS.isAbortedByUser == 1 || !THIS.isreachble)
        {
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
            
            [THIS hideProgressView];
            
            [objTimer invalidate];
            objTimer = nil;
            
            self.view.userInteractionEnabled = TRUE;
        }
    }
}

#pragma mark ----- iAd Methods -----

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"\n bannerViewDidLoadAd");
    
    THIS.bannerView.hidden = FALSE;
    sharedAdMobBannerView.hidden = TRUE;
    [sharedAdMobBannerView setBackgroundColor:[UIColor clearColor]];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"\n didFailToReceiveAdWithError = %@",[error description]);
    
    THIS.bannerView.hidden = TRUE;
    sharedAdMobBannerView.hidden = FALSE;
    [THIS.bannerView setBackgroundColor:[UIColor clearColor]];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"\n bannerViewActionShouldBegin");
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"\n bannerViewActionDidFinish");
}

#pragma mark ----- AdMob Methods -----

-(void)loadGadRequest
{
    sharedAdMobBannerView = [[GADBannerView alloc]init];
    
    if (IS_IPAD)
    {
        sharedAdMobBannerView.frame = CGRectMake(0, 958, 768, 50);
    }
    else
    {
        if(IPHONE_5)
        {
            sharedAdMobBannerView.frame = CGRectMake(0, 518, 320, 50);
        }
        else
        {
            sharedAdMobBannerView.frame = CGRectMake(0, 430, 320, 50);
        }
    }
    
    sharedAdMobBannerView.adUnitID = GAD_AD_ID;
    sharedAdMobBannerView.rootViewController = self;
    sharedAdMobBannerView.delegate = self;
    sharedAdMobBannerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:sharedAdMobBannerView];
    [self.view bringSubviewToFront:sharedAdMobBannerView];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID, ADMOB_IPAD2_TESTID, ADMOB_IPADMINI_TESTID, ADMOB_IPHONE5_TESTID,ADMOB_IPHONE4_TESTID, ADMOB_IPOD_TESTID];
    [sharedAdMobBannerView loadRequest:request];
}

-(void)adViewDidReceiveAd:(DFPBannerView *)adView
{
    NSLog(@"Received ad successfully");
}

-(void)adView:(DFPBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#pragma mark ----- Chartboost Method -----

-(IBAction)btnChartboostClicked:(id)sender
{
    [[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
}

#pragma mark ----- Chartboost Method -----

-(IBAction)btnCloseClicked:(id)sender
{
    exit(0);
}

#pragma mark ----- Revmob Methods -----

-(IBAction)btnShowRevmobFullscreenClicked:(id)sender
{
    [[RevMobAds session] showFullscreen];
}

-(IBAction)btnShowRevmobBannerClicked:(id)sender
{
    [[RevMobAds session] showBanner];
}

-(IBAction)btnHideRevmobBannerClicked:(id)sender
{
    [[RevMobAds session] hideBanner];
}

- (void)startSession
{
    [RevMobAds startSessionWithAppID:REVMOB_ID
                  withSuccessHandler:^{
                      NSLog(@"Session started with block");
                  } andFailHandler:^(NSError *error) {
                      NSLog(@"Session failed to start with block");
                  }];
}

#pragma mark - RevMobAdsDelegate methods

- (void)revmobSessionIsStarted {
    NSLog(@"[RevMob Sample App] Session started again.");
}

- (void)revmobSessionNotStarted:(NSError *)error {
    NSLog(@"[RevMob Sample App] Session not started again: %@", error);
}

- (void)revmobAdDidReceive {
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);
}

- (void)revmobAdDisplayed {
    NSLog(@"[RevMob Sample App] Ad displayed.");
}

- (void)revmobUserClosedTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the close button.");
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the Ad.");
}

- (void)installDidReceive {
    NSLog(@"[RevMob Sample App] Install did receive.");
}

- (void)installDidFail {
    NSLog(@"[RevMob Sample App] Install did fail.");
}

@end
