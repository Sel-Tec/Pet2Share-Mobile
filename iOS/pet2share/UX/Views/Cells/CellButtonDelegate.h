//
//  CellButtonDelegate.h
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

@protocol CellButtonDelegate <NSObject>

@optional
- (void)mainButtonTapped:(id)sender;
- (void)actionButtonTapped:(id)sender identifier:(NSInteger)identifier;

@end
