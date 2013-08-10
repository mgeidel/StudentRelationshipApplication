//
//  MGBlockActionSheet.h
//  MGBlockActionSheet
//
//  Created by mac on 05.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGBlockActionSheet : UIActionSheet <UIActionSheetDelegate>

 //... steht dafür, dass methode beliebeige anzahl an parametern verwalten kann
- (id) initWithTitle:(NSString *)title
   cancelButtonTitle:(NSString *)cancelButtonTitle
   cancelButtonBlock:(dispatch_block_t)cancelButtonBlock
   destructiveButtonTitle:(NSString *)destructiveButtonTitle
   destructiveButtonBlock:(dispatch_block_t)destructBlocks
   otherButtonsAndBlocks:(NSString *)otherButtonsAndBlocks, ...;


- (void) addButtonsAndBlocksWithArray: (NSArray *) buttonsAndBlocks;

@end
