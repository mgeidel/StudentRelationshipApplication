//
//  MGBlockAlertView.m
//  MGBlockAlertView
//
//  Created by mac on 05.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "MGBlockAlertView.h"

@interface MGBlockAlertView ()
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation MGBlockAlertView
@synthesize blocks = _blocks;

- (id) initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        self.blocks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addButtonWithTitle:(NSString *)title andBlock:(dispatch_block_t) block
{
    //ist block nicht übergeben,dann wird ein leerer block initialisiert
    if (!block) {
        block = ^{};
    }
    //block kann nicht nil sein,wenn er in ein array soll und er muss auch erst kopiert werden
    [self addButtonWithTitle:title];
    [self.blocks addObject:[block copy]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    dispatch_block_t block = [self.blocks objectAtIndex:buttonIndex];
    block ();
}
@end
