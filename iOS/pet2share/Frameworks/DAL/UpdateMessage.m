//
//  UpdateMessage.m
//  pet2share
//
//  Created by Tony Kieu on 10/9/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "UpdateMessage.h"

@implementation UpdateMessage

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"IsSuccessful": @"isSuccessful",
              @"Message": @"message",
              @"UpdateId": @"updateId"}];
}

- (BOOL)isValidate
{
    return YES;
}

@end
