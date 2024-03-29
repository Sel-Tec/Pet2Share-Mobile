//
//  LoginTableCtrl.h
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

@interface LoginTableCtrl : UITableViewController

@property (nonatomic, weak) id<FormProtocol> formProtocol;

- (NSString *)email;
- (NSString *)password;
- (void)resignAllTextFields;
- (void)clearPasswordField;

@end
