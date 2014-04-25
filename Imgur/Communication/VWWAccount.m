//
//  VWWAccount.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAccount.h"



@implementation VWWAccount
-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if(self){
        NSDictionary *data = dictionary[@"data"];
        if(data){
            
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

        }
    }
    return self;
}
-(NSDictionary*)dictionaryRepresentation{
    return @{};
}


@end
