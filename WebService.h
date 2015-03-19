//
//  WebService.h
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface WebService : NSObject
{
    AFHTTPClient *client;
    AFHTTPRequestOperation *operation;
}


+ (WebService *) shareWebService;

- (void)userAuthentication:(NSDictionary *)dictParams success:(void (^)(id jsonObject))success failure:(void (^)( NSError *error))failure;


@end
