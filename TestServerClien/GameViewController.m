//
//  GameViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 07.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "GameViewController.h"
#import "GameCardView.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet GameCardView *card_1;
@property (weak, nonatomic) IBOutlet GameCardView *card_2;
@property (weak, nonatomic) IBOutlet GameCardView *card_3;
@property (strong, nonatomic) IBOutlet GameCardView *selectCard;

- (IBAction)card_1_tap:(id)sender;
- (IBAction)card_2_tap:(id)sender;
- (IBAction)card_3_tap:(id)sender;

- (IBAction)ok:(id)sender;

- (IBAction)left_tap:(id)sender;
- (IBAction)right_tap:(id)sender;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_card_1 setType:GameCardType_2 startRoad:1 rotate:0];
    [_card_2 setType:GameCardType_2 startRoad:1 rotate:1];
    [_card_3 setType:GameCardType_2 startRoad:1 rotate:2];

    [_selectCard setType:GameCardType_2 startRoad:1 rotate:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)card_1_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_selectCard.rotate+2];
        
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}

- (IBAction)card_2_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (IBAction)card_3_tap:(id)sender
{
    [_selectCard setType:_card_3.cardType startRoad:_card_3.startRoad rotate:_card_3.rotate];
}

- (IBAction)ok:(id)sender
{
    
}

- (IBAction)left_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_selectCard.rotate-1];
        
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}

- (IBAction)right_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_selectCard.rotate+1];
        
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}
@end
