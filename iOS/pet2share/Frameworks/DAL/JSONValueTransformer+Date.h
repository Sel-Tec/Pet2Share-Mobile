//
//  JSONValueTransformer+Date.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (Date)

- (NSDate *)DateFromNSString:(NSString *)string;

@end
