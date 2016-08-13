//
//  AdminCollectionViewCell.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 13.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "AdminCollectionViewCell.h"
#import "MyLabel.h"

@interface AdminCollectionViewCell ()
{
    NSInteger gCount;
}

//@property (assign, nonatomic) NSInteger gCount;

@end

@implementation AdminCollectionViewCell

- (void) initCell
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settings_sync_cell)
                                                 name:@"settings_sync_cell"
                                               object:nil];
    
    [_garageLabel setStrokeText:@"Garage"];

    [_classicLabel setStrokeText:@"Classic"];

    [_distanceLabel setStrokeText:@"Distance"];

    [_GameTypeLabel setStrokeText:@"Game type:"];
    [_howLabel setStrokeText:@"How many moves bofore garage appears?"];
    [self settings_sync_cell];
}

- (void) settings_sync_cell
{
    for (UIButton* bt in _buttons) {
        if (bt.tag == [_delegat getGame_type]) {
            [bt setSelected:NO];
        }
        else
        {
            [bt setSelected:YES];
        }
    }
    if ([_delegat getGame_type] == 2) {
        [_garageCount setHidden:NO];
        [_howLabel setHidden:NO];
    }
    else
    {
        [_garageCount setHidden:YES];
        [_howLabel setHidden:YES];
    }
    gCount = [_delegat getParking_count];
    [self setGCount];
}

- (IBAction)buttonTap:(id)sender
{
    for (UIButton* bt in _buttons)
    {
        if (bt == (UIButton*)sender) {
            [bt setSelected:NO];
            [_delegat setGame_type:((UIButton*)sender).tag];
        }
        else
        {
            [bt setSelected:YES];
        }
    }
    
    if (((UIButton*)sender).tag == 2) {
        [_garageCount setHidden:NO];
        [_howLabel setHidden:NO];
    }
    else
    {
        [_garageCount setHidden:YES];
        [_howLabel setHidden:YES];
    }
}

- (IBAction) countPlusTap:(id)sender
{
    if (gCount+1<16)
    {
        gCount++;
    }
    [self setGCount];
}

- (IBAction)countMinusTap:(id)sender
{
    if (gCount-1>0)
    {
        gCount--;
    }
    [self setGCount];
}

- (void) setGCount
{
    [_countLabelInput setText:[NSString stringWithFormat:@"%ld",(long)gCount]];
}
@end
