//
//  ViewController.h
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

#import "GADRequest.h"
#import "DFPBannerView.h"
#import "GADAdSizeDelegate.h"
#import "GADAppEventDelegate.h"
#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"

#import "Chartboost.h"


@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,ADBannerViewDelegate, SKProductsRequestDelegate, GADBannerViewDelegate,ChartboostDelegate,RevMobAdsDelegate>
{
    NSUserDefaults *userDefaults;
    SKProductsRequest *requestSK;
    NSTimer *objTimer;
    NSTimer *restoreTImer;
}

@property (nonatomic, strong) GADBannerView *sharedAdMobBannerView;

@property (nonatomic, strong)RevMobFullscreen *fullscreen;
@property (nonatomic, strong)RevMobBannerView *banner;
@property (nonatomic, strong)RevMobBanner *bannerWindow;

@property(nonatomic,retain) IBOutlet UIButton *btnWebService;
@property(nonatomic,retain) IBOutlet UIButton *btnFacebook;
@property(nonatomic,retain) IBOutlet UIButton *btnTwitter;
@property(nonatomic,retain) IBOutlet UIButton *btnMail;
@property(nonatomic,retain) IBOutlet UIButton *btnSms;
@property(nonatomic,retain) IBOutlet UIButton *btnPurchase;
@property(nonatomic,retain) IBOutlet UIButton *btnRestore;
@property(nonatomic,retain) IBOutlet UIButton *btnChartboost;

@property(nonatomic,retain) IBOutlet UIButton *btnShowRevmobFullscreen;
@property(nonatomic,retain) IBOutlet UIButton *btnShowRevmobBanner;
@property(nonatomic,retain) IBOutlet UIButton *btnHideRevmobBanner;

@property(nonatomic,retain) IBOutlet UIButton *btnClose;


-(IBAction)btnWebServiceClicked:(id)sender;
-(IBAction)btnFacebookClicked:(id)sender;
-(IBAction)btnTwitterClicked:(id)sender;
-(IBAction)btnMailClicked:(id)sender;
-(IBAction)btnSmsClicked:(id)sender;
-(IBAction)btnPurchaseClicked:(id)sender;
-(IBAction)btnRestoreClicked:(id)sender;
-(IBAction)btnChartboostClicked:(id)sender;
-(IBAction)btnShowRevmobFullscreenClicked:(id)sender;
-(IBAction)btnShowRevmobBannerClicked:(id)sender;
-(IBAction)btnHideRevmobBannerClicked:(id)sender;
-(IBAction)btnCloseClicked:(id)sender;



@end

