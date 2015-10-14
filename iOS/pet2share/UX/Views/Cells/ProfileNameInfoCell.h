//
//  ProfileNameInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"
#import "CellConstants.h"
#import "CellButtonDelegate.h"

@interface ProfileNameInfoCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;
@property (nonatomic, weak) id<CellButtonDelegate> buttonDelegate;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict;

@end
