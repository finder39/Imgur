//
//  VWWRESTEngine.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWRESTEngine.h"
#import "VWWImgurControllerConfig.h"
#import "VWWRESTParser.h"



static NSString* VWWHTTPRequstTypePost = @"POST";
static NSString* VWWHTTPRequstTypeGet = @"GET";
static NSString* VWWHTTPRequstTypePut = @"PUT";
static NSString* VWWHTTPRequstTypeDelete = @"DELETE";


@implementation VWWRESTEngine

+(VWWRESTEngine*)sharedInstance{
    static VWWRESTEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWRESTEngine alloc]init];
    });
    return instance;
}

-(id)init{
    if(self){

        _service = [VWWRESTConfig sharedInstance];
        self = [super initWithHostName:_service.serviceEndpoint
                               apiPath:_service.serviceVersion
                    customHeaderFields:nil];
        
    }
    return self;
}

//-(void)enableCaching:(BOOL)enable{
//// This is causing issues where completion blocks are called twice. Yes that's what it is supposed to do, but
//// is not always desired.
//    [self useCache];
//}
//-(void)clearCachedData{
//    [self clearCache];
//}

-(void)prepareHeaders:(MKNetworkOperation *)operation {
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:VWWTokenAccessTokenKey];
    if (authToken.length) {
        NSDictionary* headersDict = @{@"Authorization:": [NSString stringWithFormat:@"Bearer %@", authToken]};
        [operation addHeaders:headersDict];
    }
    
    [super prepareHeaders:operation];
    
}


#pragma mark Private Methods

-(void)printHTTPSuccess:(MKNetworkOperation*)completedOperation{
#if defined(VWW_LOG_CURL_COMMANDS)
    VWW_LOG_INFO(@"\n---------- HTTP %@ %ld -----------------------"
                @"\n----- CURL:\n%@ | pbcopy"
                @"\n----- RESPONSE:\n%@"
                @"\n---------- END HTTP %@ -----------------------",
                completedOperation.HTTPMethod, (long)completedOperation.HTTPStatusCode,
                completedOperation.curlCommandLineString,
                completedOperation.responseJSON,
                completedOperation.HTTPMethod);
    
#endif
}

-(void)printHTTPError:(MKNetworkOperation*)completedOperation error:(NSError*)error{
    VWW_LOG_WARNING(@"\n~~~~~~~~~~ HTTP %@ %ld ~~~~~~~~~~~~~~~~~~~~"
                   @"\n~~~~~ CURL:\n%@ | pbcopy"
                   @"\n~~~~~ RESPONSE Object:\n%@"
                   @"\n~~~~~ RESPONSE JSON:\n%@"
                   @"\n~~~~~ ERROR: %@"
                   @"\n~~~~~~~~~~ END HTTP %@ ~~~~~~~~~~~~~~~~~~~~",
                   completedOperation.HTTPMethod, (long)completedOperation.HTTPStatusCode,
                   completedOperation.curlCommandLineString,
                   completedOperation.readonlyResponse,
                   completedOperation.responseJSON,
                   error.localizedDescription,
                   completedOperation.HTTPMethod);
}


-(MKNetworkOperation*) httpGetEndpoint:(NSString*)endpoint
                        jsonDictionary:(NSDictionary*)jsonDictionary
                       completionBlock:(VWWJSONBlock)completionBlock
                            errorBlock:(VWWErrorStringBlock)errorBlock{
    MKNetworkOperation* operation = [self operationWithPath:endpoint
                                                     params:jsonDictionary
                                                 httpMethod:VWWHTTPRequstTypeGet
                                                        ssl:self.service.serviceSecure];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self printHTTPSuccess:completedOperation];
        completionBlock(completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self printHTTPError:completedOperation error:error];
        errorBlock(error, completedOperation.responseJSON);
    }];
    
    [self enqueueOperation:operation];
    return operation;
}


-(MKNetworkOperation*) httpPostEndpoint:(NSString*)endpoint
                         jsonDictionary:(NSDictionary*)jsonDictionary
                        completionBlock:(VWWJSONBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock{
    
    MKNetworkOperation* operation = [self operationWithPath:endpoint
                                                     params:jsonDictionary
                                                 httpMethod:VWWHTTPRequstTypePost
                                                        ssl:self.service.serviceSecure];
    
    
    [operation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self printHTTPSuccess:completedOperation];
        completionBlock(completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self printHTTPError:completedOperation error:error];
        errorBlock(error, completedOperation.responseJSON);
    }];
    
    [self enqueueOperation:operation];
    return operation;
}


-(MKNetworkOperation*) httpPutEndpoint:(NSString*)endpoint
                        jsonDictionary:(NSDictionary*)jsonDictionary
                       completionBlock:(VWWJSONBlock)completionBlock
                            errorBlock:(VWWErrorStringBlock)errorBlock{
    
    MKNetworkOperation* operation = [self operationWithPath:endpoint
                                                     params:jsonDictionary
                                                 httpMethod:VWWHTTPRequstTypePut
                                                        ssl:self.service.serviceSecure];
    [operation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self printHTTPSuccess:completedOperation];
        completionBlock(completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self printHTTPError:completedOperation error:error];
        errorBlock(error, completedOperation.responseJSON);
    }];
    
    [self enqueueOperation:operation];
    return operation;
}

-(MKNetworkOperation*) httpDeleteEndpoint:(NSString*)endpoint
                           jsonDictionary:(NSDictionary*)jsonDictionary
                          completionBlock:(VWWJSONBlock)completionBlock
                               errorBlock:(VWWErrorStringBlock)errorBlock{
    
    MKNetworkOperation* operation = [self operationWithPath:endpoint
                                                     params:jsonDictionary
                                                 httpMethod:VWWHTTPRequstTypeDelete
                                                        ssl:self.service.serviceSecure];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self printHTTPSuccess:completedOperation];
        completionBlock(completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self printHTTPError:completedOperation error:error];
        errorBlock(error, completedOperation.responseJSON);
    }];
    
    [self enqueueOperation:operation];
    return operation;
    
}


#pragma mark Public methods


-(MKNetworkOperation*)getTokensWithForm:(VWWCodeForm*)form
                        completionBlock:(VWWTokenBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock{
    
    @autoreleasepool {
        return [self httpPostEndpoint:[NSString stringWithFormat:@"%@", self.service.tokenURI]
                      jsonDictionary:[form httpParametersDictionary]
                     completionBlock:^(id responseJSON) {
                         VWW_LOG_TRACE;
                         [VWWRESTParser parseTokens:responseJSON completionBlock:^(VWWToken *token) {
                             completionBlock(token);
                         }];
                         
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];
    }
}


// https://api.imgur.com/3/account/me/images
-(MKNetworkOperation*)getAccountImagesWithCompletionBlock:(VWWArrayBlock)completionBlock
                                               errorBlock:(VWWErrorStringBlock)errorBlock{
    
    @autoreleasepool {
        self.hostName = @"api.imgur.com/3/account/me";
        
        return [self httpGetEndpoint:@"images"
                      jsonDictionary:nil
                     completionBlock:^(id responseJSON) {
                         
                         NSArray *images = responseJSON[@"data"];
                         
                         VWW_LOG_TRACE;
                         completionBlock(images);
//                         [SMRESTParser parseAssets:responseJSON completionBlock:^(SMPagination *page, NSArray *array) {
//                             completionBlock(page, array);
//                         }];
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];
    }
}

@end
