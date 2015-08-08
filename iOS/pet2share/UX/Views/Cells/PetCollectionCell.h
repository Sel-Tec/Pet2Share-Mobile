//
//  PetCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/8/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParsePet;

@interface PetCollectionCell : UICollectionViewCell

+ (CGFloat)cellHeight;
- (void)setUpView:(ParsePet *)pet;

@end
