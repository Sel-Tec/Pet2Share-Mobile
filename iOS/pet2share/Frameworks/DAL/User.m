//
//  User.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "User.h"

@implementation SUser : RepositoryObject

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"Id": @"identifier",
                                 @"Name": @"name",
                                 @"ProfilePictureURL": @"profilePictureUrl",
                                 @"Username": @"userName"}];
}

- (BOOL)isValidate
{
    return (self.identifier != -1) ? YES : NO;
}

@end

@implementation User

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"Id": @"identifier",
                                 @"Username": @"username",
                                 @"Password": @"password",
                                 @"IsAuthenticated": @"isAuthenticated",
                                 @"P": @"person",
                                 @"Email": @"email",
                                 @"AlternateEmail": @"alternateEmail",
                                 @"SocialMediaSource": @"socialMediaSource",
                                 @"SocialMediaId": @"socialMediaId",
                                 @"SocialMediaName": @"socialMediaName",
                                 @"Phone": @"phone",
                                 @"UType": @"userType",
                                 @"Pets": @"pets",
                                 @"DateAdded": @"dateAdded",
                                 @"DateModified": @"dateModified",
                                 @"IsActive": @"isActive"}];
}

- (BOOL)isValidate
{
    return (self.identifier != -1 /*&& self.username*/) ? YES : NO;
}

@end

@implementation UserType

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"name": @"name"}];
}

- (BOOL)isValidate
{
    return self.identifier != -1 ? YES : NO;
}

@end

@implementation SocialMediaSource

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"name": @"name"}];
}

- (BOOL)isValidate
{
    return self.identifier != -1 ? YES : NO;
}

@end