//
//  WebService.m
//  AF_DEMO
//
//  Created by Pratik Pujara on 25/02/15.
//  Copyright (c) 2015 Pratik Pujara. All rights reserved.
//

#import "WebService.h"

@implementation WebService

static WebService *shareWebService = nil;

+ (WebService *) shareWebService
{
	if(!shareWebService)
		shareWebService = [[WebService alloc] init];
    
	return shareWebService;
}


-(void)userAuthentication:(NSDictionary *)dictParams success:(void (^)(id jsonObject))success failure:(void (^)( NSError *error))failure
{
    client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"http://192.168.3.61:8080/Service.svc/json/"]];
    
    [client setParameterEncoding:AFJSONParameterEncoding];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [client postPath:@"Authentication" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if(success)
            success(responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if(error)
            failure(error);
    }];
    
    [operation start];
}



@end
