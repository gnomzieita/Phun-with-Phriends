//
//  AdminCell3CollectionViewCell.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 27.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "AdminCell3CollectionViewCell.h"

@interface AdminCell3CollectionViewCell ()
{
    NSInteger gCount;
}

//@property (assign, nonatomic) NSInteger gCount;
@property (weak, nonatomic) IBOutlet UILabel *clockwiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *conterClock;

@property (weak, nonatomic) IBOutlet UILabel *howText;
@end

@implementation AdminCell3CollectionViewCell

- (void) initCell
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settings_sync_cell)
                                                 name:@"settings_sync_cell"
                                               object:nil];
    [self settings_sync_cell];
    [_playerOrder setStrokeText:@"Player Order"];
    [_rotating setStrokeText:@"Rotating"];
    [_howText setStrokeText:@"How many rotating cards?"];
    [_clockwiseLabel setStrokeText:@"Clockwise"];
    [_conterClock setStrokeText:@"Counterclock-wise"];
    

}

- (void) settings_sync_cell
{
    NSInteger Rotate_vector = [_delegat getRotate_vector];
    for (UIButton* bt in _roatingArray) {
        if (bt.tag == Rotate_vector) {
            [bt setSelected:YES];
        }
        else
        {
            [bt setSelected:NO];
        }
    }
    for (UIButton* bt in _randomArray) {
        if (bt.tag == [_delegat getUser_shuffle]) {
            [bt setSelected:YES];
        }
        else
        {
            [bt setSelected:NO];
        }
    }
    gCount = [_delegat getRotate_count];
    [_countLabelInput setText:[NSString stringWithFormat:@"%ld",(long)gCount]];
}

- (IBAction)clockTap:(id)sender
{
    for (UIButton* bt in _roatingArray) {
        if (bt == (UIButton*)sender) {
            [bt setSelected:YES];
            [_delegat setRotate_vector:((UIButton*)sender).tag];
            
        }
        else
        {
            [bt setSelected:NO];
        }
    }
}

- (IBAction)randomTap:(id)sender
{
    for (UIButton* bt in _randomArray) {
        if (bt == (UIButton*)sender) {
            [bt setSelected:YES];
            [_delegat setUser_shuffle:((UIButton*)sender).tag];
        }
        else
        {
            [bt setSelected:NO];
        }
    }
}

- (IBAction) countPlusTap:(id)sender
{
    if (gCount+1<36)
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
    [_delegat setRotate_count:gCount];
    [_countLabelInput setText:[NSString stringWithFormat:@"%ld",(long)gCount]];
}
@end
