//
//  AdminCollectionViewCell.h
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 13.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

@interface AdminCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *garageLabel;
@property (weak, nonatomic) IBOutlet UILabel *classicLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *GameTypeLabel;


@property (strong, nonatomic) id<SettingsProtocol> delegat;

- (void) initCell;

- (IBAction) buttonTap:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (weak, nonatomic) IBOutlet UIView *garageCount;

- (IBAction)countMinusTap:(id)sender;
- (IBAction)countPlusTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *howLabel;

@property (weak, nonatomic) IBOutlet UITextField *countLabelInput;

@end
