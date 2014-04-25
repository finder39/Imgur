//
//  VWWAccount.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    data =     {
//        bio = "<null>";
//        created = 1262995200;
//        id = 10809;
//        "pro_expiration" = 0;
//        reputation = 744;
//        url = sneeden;
//    };
//    status = 200;
//    success = 1;
//}



@interface VWWAccount : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
-(NSDictionary*)dictionaryRepresentation;

@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic) NSUInteger identifier;
@property (nonatomic) NSUInteger reputation;
@property (nonatomic, strong) NSString *name;

@end
