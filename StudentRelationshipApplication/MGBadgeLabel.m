//
//  MGBadgeLabel.m
//  MGBadgeView
//
//  Created by mac on 05.08.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

//Systemheader für QuartzCore importieren (zB. für die runden ecken des roten badges). muss vorher auch dem projekt hinzugefügt werden
#import <QuartzCore/QuartzCore.h>
#import "MGBadgeLabel.h"

//privat
@interface MGBadgeLabel ()
- (void) setup;
@end

@implementation MGBadgeLabel
@synthesize targetUIView = _targetUIView;

-(void) setup
{
    //Ausrichtung des Textes
    self.textAlignment = UITextAlignmentCenter;
    //Setzen des Radius im Verhältnis zur Schrift (80% von Schriftfont)
    self.layer.cornerRadius = self.font.pointSize * 0.8;
}

//awakeFromNib muss überschrieben werden, damit man die badges auch gleich im storyboard nutzen kann
- (void) awakeFromNib
{
    [self setup];
}

-(void)setText:(NSString *)text
{
    //neuen Text zeichnen. füre setText aus (Text soll dargestellt werden)
    [super setText:text];
    //breite des labels,wenn es den übergebenen text darstellen soll. Nimmt Breite des Textes, im Verhältnis zur verändernten Fontgröße (self.font)
    CGSize size = [text sizeWithFont:self.font];
    //Rahmen des Labels neu definieren. origin bedeutet, das die vordefinierten Koordinaten verwendet werden. size.width + self.font.pointSize * 0.8 -> ermittelte breite + das Verhältnis der Fontgröße.
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + self.font.pointSize * 0.8, size.height);
    
    //Darstellung des Badge an der rechten oberen Ecke des Targets (icons etc)
    CGRect badgeFrame = self.frame; //Rahmen des erstellten Badges
    CGRect targetFrame = self.targetUIView.frame; //Rahmen des Icons zb.
    //Festlegen eines neuen Rahmens.Breite:originale Breite + die Breite des zb Icons/buttons etc abzüglich der halben Breite des kleinen Badges. Höhe: genaus so.
    self.frame = CGRectMake(targetFrame.origin.x + targetFrame.size.width - badgeFrame.size.width / 2, targetFrame.origin.y - badgeFrame.size.height / 2, badgeFrame.size.width, badgeFrame.size.height);
}


@end
