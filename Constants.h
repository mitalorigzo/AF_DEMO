//
//  Constants.h
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//



//----------------------------------------------------------------------------------------//

#define THIS            ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define FIRST_VIEW      [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"]

//----------------------------------------------------------------------------------------//

#define ALERT(Text)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:Text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];\
[alert show];

//----------------------------------------------------------------------------------------//

#define IS_IPHONE     (([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound ) || ( [[[UIDevice currentDevice] model] rangeOfString:@"iPod"].location != NSNotFound ))

#define IS_IPAD       ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

#define StoryboardScreen ( IS_IPAD ? @"Main_iPad" : @"Main_iPhone" )

//----------------------------------------------------------------------------------------//

#define IPHONE_4  (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IPHONE_5  (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IPHONE_6  (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

//----------------------------------------------------------------------------------------//

#define IS_OS_7    ([[[UIDevice currentDevice] systemVersion] floatValue] == 7.0)
#define IS_OS_8    ([[[UIDevice currentDevice] systemVersion] floatValue] == 8.0)

//----------------------------------------------------------------------------------------//

#define IS_SIMULATOR ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound)

#define ADMOB_IPAD2_TESTID @"06bc413c5fdeb79a38e864d5bc0fa473"
#define ADMOB_IPADMINI_TESTID @"a140b4b6ba677558569d7857531b978e"
#define ADMOB_IPHONE5_TESTID @"848ed3dae7527b3a790d9f0ae2d4de2c"
#define ADMOB_IPHONE4_TESTID @"0a46a202fb3c3a13ef20b3d9f5468add"
#define ADMOB_IPOD_TESTID @"d8b148737b13234af6ca6a4c00dbd56b"

//----------------------------------------------------------------------------------------//















