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
                               apiPath:_service.serviceAuthorize
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
    NSString *authToken = [VWWUserDefaults token];
    if (authToken.length) {
        NSDictionary* headersDict = @{@"Authorization": [NSString stringWithFormat:@"Bearer %@", authToken]};
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

-(void)setMode:(VWWRESTEngineMode)mode{
    if(mode == VWWRESTEngineModeAuthentication){
        self.apiPath = [VWWRESTConfig sharedInstance].serviceAuthorize;
    } else if(mode == VWWRESTEngineModeQuery){
        self.apiPath = [VWWRESTConfig sharedInstance].serviceQuery;
    }
}


-(MKNetworkOperation*)getTokensWithForm:(VWWCodeForm*)form
                        completionBlock:(VWWTokenBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock{
    
    @autoreleasepool {
        return [self httpPostEndpoint:[NSString stringWithFormat:@"%@", self.service.tokenURI]
                      jsonDictionary:[form httpParametersDictionary]
                     completionBlock:^(id responseJSON) {
                         [VWWRESTParser parseTokens:responseJSON completionBlock:^(VWWToken *token) {
                             completionBlock(token);
                         }];
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];
    }
}



-(MKNetworkOperation*)getAccountWithCompletionBlock:(VWWDictionaryBlock)completionBlock
                                         errorBlock:(VWWErrorStringBlock)errorBlock{
    @autoreleasepool {
        return [self httpGetEndpoint:self.service.accountMeURI
                      jsonDictionary:nil
                     completionBlock:^(id responseJSON) {
                         completionBlock(responseJSON);
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];
    }
}

// https://api.imgur.com/endpoints/account#images
// https://api.imgur.com/3/account/{username}/images/{page}
-(MKNetworkOperation*)getImagesWithForm:(VWWPaginationForm*)form
                        completionBlock:(VWWArrayBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock{
    @autoreleasepool {
        NSString *uri = [NSString stringWithFormat:@"%@/%@/%@", self.service.accountURI, [VWWUserDefaults userName], self.service.imagesURI];
        return [self httpGetEndpoint:uri
                      jsonDictionary:nil
                     completionBlock:^(id responseJSON) {
                         [VWWRESTParser parseImages:responseJSON completionBlock:^(NSArray *images) {
                             completionBlock(images);
                         }];
                         
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];

    }
}

// https://api.imgur.com/endpoints/account#albums
// https://api.imgur.com/3/account/{username}/albums/{page}
-(MKNetworkOperation*)getAlbumsWithForm:(VWWPaginationForm*)form
                        completionBlock:(VWWArrayBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock{
    
    @autoreleasepool {
        NSString *uri = [NSString stringWithFormat:@"%@/%@/%@", self.service.accountURI, [VWWUserDefaults userName], self.service.albumsURI];
        return [self httpGetEndpoint:uri
                      jsonDictionary:nil
                     completionBlock:^(id responseJSON) {
                         [VWWRESTParser parseAlbums:responseJSON completionBlock:^(NSArray *albums) {
                             completionBlock(albums);
                         }];
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];
        
    }
}


// https://api.imgur.com/endpoints/album#album-images
// https://api.imgur.com/3/album/{id}/images
-(MKNetworkOperation*)getAlbumImagesWithUUID:(NSString*)uuid
                             completionBlock:(VWWArrayBlock)completionBlock
                                  errorBlock:(VWWErrorStringBlock)errorBlock{
    @autoreleasepool {
        NSString *uri = [NSString stringWithFormat:@"%@/%@/%@", self.service.albumURI, uuid, self.service.imagesURI];
        return [self httpGetEndpoint:uri
                      jsonDictionary:nil
                     completionBlock:^(id responseJSON) {
                         [VWWRESTParser parseImages:responseJSON completionBlock:^(NSArray *images) {
                             completionBlock(images);
                         }];
                     } errorBlock:^(NSError *error, id responseJSON) {
                         errorBlock(error, responseJSON[@"message"]);
                     }];
    }
}


@end
