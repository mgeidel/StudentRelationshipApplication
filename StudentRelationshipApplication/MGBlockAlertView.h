//
//  MGBlockAlertView.h
//  MGBlockAlertView
//
//  Created by mac on 05.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGBlockAlertView : UIAlertView <UIAlertViewDelegate>

- (id) initWithTitle:(NSString *)title message:(NSString *)message;
- (void) addButtonWithTitle:(NSString *)title andBlock:(dispatch_block_t) block;

@end