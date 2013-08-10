//
//  MGBlockActionSheet.m
//  MGBlockActionSheet
//
//  Created by mac on 05.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "MGBlockActionSheet.h"

//Aufnahme eines privaten interface, um darin die privaten properties zu verwalten
@interface MGBlockActionSheet ()
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation MGBlockActionSheet
@synthesize blocks = _blocks;

- (id) initWithTitle:(NSString *)title
   cancelButtonTitle:(NSString *)cancelButtonTitle
   cancelButtonBlock:(dispatch_block_t)cancelButtonBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
destructiveButtonBlock:(dispatch_block_t)destructiveButtonBlock
otherButtonsAndBlocks:(NSString *)otherButtonsAndBlocks, ...
{
    //super initialisierer
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    //mutable array initialisieren
    if (self) {
        self.blocks = [[NSMutableArray alloc] init];
        
        //prüfung, ob cancelbuttontitle übergeben wurde und kein block enthalten ist -> leeren block anlegen und dem array "blocks" hinzufügen.
        if (cancelButtonTitle) {
            if (!cancelButtonBlock) {
                cancelButtonBlock = ^{};
            }
            [self.blocks addObject:cancelButtonBlock];
        }
        
        if (destructiveButtonTitle) {
            if (!destructiveButtonBlock) {
                destructiveButtonBlock = ^{};
            }
            [self.blocks addObject:destructiveButtonBlock];
        }
        //hier kommt quasi der ... teil -> hier können beliebiege argumente (pärchen von buttontitle und dazugehörigen block) hinzugefügt werden
        id eachObject;
        //neue variable argumenten liste
        va_list argumentList;
        //werden andere button und block pärchen übergeben, dann 
        if (otherButtonsAndBlocks) {
            //das pärchen besteht aus einem title und einem block, daher wird hier die erste stelle von otherButtonsAndBlocks (der Title) dem Title zugewiesen
            [self addButtonWithTitle:otherButtonsAndBlocks];
            //argument Liste öffnen
            va_start(argumentList, otherButtonsAndBlocks);
            //einzelne Objekte aus der argument Liste vom typ id auslesen
            while ((eachObject = va_arg (argumentList, id))) {
                //und prüfen, ob es sich um einen buttentitle handelt (also einen string)
                if ([eachObject isKindOfClass:[NSString class]]) {
                    [self addButtonWithTitle: eachObject];
                } else {
                    //andernfalls handelt es sich um einen block (ACHTUNG Blocks müssen als kopie übergeben werden), der dem blocks array angehangen wird
                    [self.blocks addObject: [eachObject copy]];
                }
            }
            //nächstes argument aus liste holen
            va_end(argumentList);
        }
    }
    return self;
}

- (void) addButtonsAndBlocksWithArray: (NSArray *) buttonsAndBlocks
{
    //erzeugen einer variable i. so lange der i kleiner anzahl buttonAndBlocks ist, gehe 2 schritte weiter
    for (NSInteger i = 0; i < buttonsAndBlocks.count; i += 2) {
        //buttontitle setzen
        [self addButtonWithTitle:[buttonsAndBlocks objectAtIndex:i]];
        //block in den blocks array schreiben
        [self.blocks addObject:[[buttonsAndBlocks objectAtIndex:i + 1] copy]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //wenn button geklickt wird,wird der dazugehörige block ausgeführt
    dispatch_block_t block = [self.blocks objectAtIndex:buttonIndex];
    block ();
}

@end
