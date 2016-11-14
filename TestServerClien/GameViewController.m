//
//  GameViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 07.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "GameViewController.h"
#import "GameCardView.h"
#import "API.h"
#import <Chartboost/Chartboost.h>
#import "ViewController.h"
#import "MyLabel.h"
#import "WCScanViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface GameViewController ()
{
    NSArray* arrayOfCard;
    NSArray* rotateArray;
    UIColor* roadColor;
}
@property (weak, nonatomic) IBOutlet UIImageView *gameEndImage;

- (IBAction)mainMenuButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;

- (IBAction)newGameButtonTab:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nGameButton;

@property (weak, nonatomic) IBOutlet GameCardView *card_1;
@property (weak, nonatomic) IBOutlet GameCardView *card_2;
@property (weak, nonatomic) IBOutlet GameCardView *card_3;
@property (strong, nonatomic) IBOutlet GameCardView *selectCard;

@property (weak, nonatomic) IBOutlet UILabel *NextStepName;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;

@property (weak, nonatomic) IBOutlet GameCardView *cardTemp;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic) IBOutlet UIView *gameWinView;

@property (assign, nonatomic) CGRect tempRect;
@property (assign, nonatomic) NSInteger roadStart;
@property (assign, nonatomic) NSInteger rotate;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

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
    NSLog(@"GameViewController viewDidLoad");
    NSDictionary *typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:17.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor colorWithRed:255.0f/255.0f green:140.0f/255.0f blue:24.0f/255.0f alpha:1.0f],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                                       };
    NSAttributedString *str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(@"Main Menu",@"Main Menu")
                               attributes:typingAttributes];
    
    [_mainMenuButton setAttributedTitle:str forState:UIControlStateNormal];
    
    typingAttributes = @{
                         NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:17.0f],
                         NSForegroundColorAttributeName : [UIColor whiteColor],
                         NSStrokeColorAttributeName : [UIColor colorWithRed:95.0f/255.0f green:22.0f/255.0f blue:161.0f/255.0f alpha:1.0f],
                         NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                         };
    str = [[NSAttributedString alloc]
           initWithString:NSLocalizedString(@"New Game",@"New Game")
           attributes:typingAttributes];
    
    [_nGameButton setAttributedTitle:str forState:UIControlStateNormal];
    
    [_congratsLabel setStrokeText:@"Congrats! You’ve made it."];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    _okButton.layer.cornerRadius = 10.f;
    arrayOfCard = [NSArray arrayWithObjects:_card_1,_card_2,_card_3, nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification:)
                                                 name:@"cardInit"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameEnd:)
                                                 name:@"end_game"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(game_over:)
                                                 name:@"game_over"
                                               object:nil];
    
    [[API sharedController] sendMessage:[[API sharedController] objectToJSONString:@{@"command":@"action",@"game_cmd":@"info"}]];
}

- (void) gameEnd:(NSNotification *) notification
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Game over!",@"Game over!") message:NSLocalizedString(@"Server left the game!",@"Server left the game!") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionButtonOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //[[[[self presentingViewController] presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        
        [self dismisExit];
        
    }];
    
    [alertController addAction:actionButtonOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) game_over:(NSNotification *) notification
{
    BOOL isWinn = [[[notification userInfo] objectForKey:@"game_over"] boolValue];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Game over!",@"Game over!") message:isWinn?NSLocalizedString(@"Вы выиграли!",@"Вы выиграли!"):NSLocalizedString(@"Вы проиграли!",@"Вы проиграли!") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionButtonOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];

        [self dismisExit];
    }];
    
    [alertController addAction:actionButtonOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) dismisExit
{
    UIViewController* view = [self presentingViewController];
    while (![view isKindOfClass:[ViewController class]]) {
        view = [view presentingViewController];
    }
    [view dismissViewControllerAnimated:YES completion:^{
        
        [Chartboost cacheRewardedVideo:CBLocationMainMenu];
        
    }];
}
-(void) gameInitNotification:(NSNotification *) notification {
    /*
     {"admin":true,"card":[10,22,7],"color":-769226,"cur_user":"Samsung","game_cmd":"info","game_over":true,"path":8,"response":"action","rotating":[false,false,false],"step":false,"user_win":true}
     */
    NSLog(@"gameInitNotification: %@",notification.userInfo);
    [_activity stopAnimating];
    
    if ([[notification.userInfo objectForKey:@"game_over"] boolValue]) {
        [_selectCard removeFromSuperview];
        if ([[notification.userInfo objectForKey:@"user_win"] boolValue])
        {
            [_congratsLabel setHidden:NO];
            [_gameEndImage setImage:[UIImage imageNamed:@"game_win"]];
            if (![[notification.userInfo objectForKey:@"admin"] boolValue]) {
                [_nGameButton setHidden:YES];
                [_mainMenuButton setHidden:YES];
            }
            [_gameWinView setHidden:NO];
        }
        else
        {
            [_congratsLabel setHidden:YES];
            [_gameEndImage setImage:[UIImage imageNamed:@"game_end"]];
            if (![[notification.userInfo objectForKey:@"admin"] boolValue]) {
                [_nGameButton setHidden:YES];
                [_mainMenuButton setHidden:YES];
            }
            [_gameWinView setHidden:NO];
        }
    }
    else
    {
        NSLog(@"User info %@", notification.userInfo);
        NSArray* cardArray = [NSArray arrayWithArray:[notification.userInfo objectForKey:@"card"]];
        NSLog(@"cardArray %@", cardArray);
        _rotate = 0;
        _cardArray = cardArray;
        rotateArray = [NSArray arrayWithArray:[notification.userInfo objectForKey:@"rotating"]];
        _roadStart = [[notification.userInfo objectForKey:@"path"] integerValue];
        //
        if ([[notification.userInfo objectForKey:@"step"] boolValue]) {
            [_NextStepName setText:[NSString stringWithFormat:NSLocalizedString(@"Select Card",@"Select Card")]];
            [_okButton setHidden:NO];
        }
        else
        {
            [_NextStepName setText:[NSString stringWithFormat:NSLocalizedString(@"Waiting for %@",@"Waiting for %@"),[notification.userInfo objectForKey:@"cur_user"]]];
            [_okButton setHidden:YES];
        }
        
        roadColor = UIColorFromRGB([[notification.userInfo objectForKey:@"color"] integerValue]);
        [self.view setBackgroundColor:roadColor];
        _card_1.roadColor = roadColor;
        _card_2.roadColor = roadColor;
        _card_3.roadColor = roadColor;
        _selectCard.roadColor = roadColor;
        [self loadCard];
    }
}

- (void) loadCard
{
//    NSArray* arrayOfCard = [NSArray arrayWithObjects:_card_1,_card_2,_card_3,_selectCard, nil];
//
//    for (int i = 0; i<4; i++) {
//        
//        [self reloadCard:((GameCardView*)[arrayOfCard objectAtIndex:i]) oldCard:((GameCardView*)[arrayOfCard objectAtIndex:i]) withType:[[_cardArray objectAtIndex:i%3] integerValue]];
////        GameCardView* tempvw = ((GameCardView*)[arrayOfCard objectAtIndex:i]);
////        GameCardView* view = [[GameCardView alloc] initWithFrame:tempvw.frame];
////        [view setType:[[_cardArray objectAtIndex:0] integerValue] startRoad:_roadStart rotate:_rotate];
////        
////        [((GameCardView*)[arrayOfCard objectAtIndex:i]) removeFromSuperview];
////        
////        [self.view addSubview:view];`
////        tempvw = view;
//    }
    _card_1.isRotatingCard = [[rotateArray objectAtIndex:0] boolValue];
    [_card_1 setType:[[_cardArray objectAtIndex:0] integerValue] startRoad:_roadStart rotate:_rotate];
    
    _card_2.isRotatingCard = [[rotateArray objectAtIndex:1] boolValue];
    [_card_2 setType:[[_cardArray objectAtIndex:1] integerValue] startRoad:_roadStart rotate:_rotate];
    
    _card_3.isRotatingCard = [[rotateArray objectAtIndex:2] boolValue];
    [_card_3 setType:[[_cardArray objectAtIndex:2] integerValue] startRoad:_roadStart rotate:_rotate];
    
    _selectCard.isRotatingCard = [[rotateArray objectAtIndex:0] boolValue];
    [_selectCard setType:[[_cardArray objectAtIndex:0] integerValue] startRoad:_roadStart rotate:_rotate];
    
    [self setSelectedCard:_card_1];
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

//- (void) reloadCard:(GameCardView*)gameCard oldCard:(GameCardView*)oldCard withType:(GameCardType)cardType
//{
//    GameCardView* view = [[GameCardView alloc] initWithFrame:oldCard.frame];
//    [view setType:cardType startRoad:_roadStart rotate:_rotate];
//    
//    [oldCard removeFromSuperview];
//    oldCard = nil;
//    [self.view addSubview:view];
//    oldCard = view;
//}

- (void) setSelectedCard:(GameCardView *)selectCard
{
    for (GameCardView* tempCard in arrayOfCard) {
        if (tempCard == selectCard) {
            tempCard.layer.borderColor = [UIColor blueColor].CGColor;
            tempCard.layer.borderWidth = 4.5f;
            
        }
        else
        {
            tempCard.layer.borderColor = [UIColor blackColor].CGColor;
            tempCard.layer.borderWidth = 1;
        }
    }
}
- (IBAction)card_1_tap:(id)sender
{
        _rotate = 0;
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_card_1.cardType startRoad:_card_1.startRoad rotate:_rotate];
        view.isRotatingCard = _card_1.isRotatingCard;
        view.roadColor = _card_1.roadColor;
    
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    [self setSelectedCard:_card_1];
}

- (IBAction)card_2_tap:(id)sender
{
        _rotate = 0;
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_card_2.cardType startRoad:_card_2.startRoad rotate:_rotate];
        view.isRotatingCard = _card_2.isRotatingCard;
    view.roadColor = _card_2.roadColor;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    [self setSelectedCard:_card_2];
}

- (IBAction)card_3_tap:(id)sender
{
        _rotate = 0;
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_card_3.cardType startRoad:_card_3.startRoad rotate:_rotate];
        view.isRotatingCard = _card_3.isRotatingCard;
    view.roadColor = _card_3.roadColor;
    
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    [self setSelectedCard:_card_3];
}

- (IBAction)ok:(id)sender
{
    [[API sharedController] sendCard:_selectCard.cardType angle:_rotate];
    [_activity startAnimating];
}

- (IBAction)left_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _rotate = _rotate-1<0?3:_rotate-1;
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_rotate];
        view.isRotatingCard = _selectCard.isRotatingCard;
        view.roadColor = _selectCard.roadColor;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}

- (IBAction)right_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(M_PI_2);
        _rotate = _rotate+1>3?0:_rotate+1;
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_rotate];
        view.isRotatingCard = _selectCard.isRotatingCard;
        view.roadColor = _selectCard.roadColor;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)newGameButtonTab:(id)sender
{
//    “command”:” action”,
//    “game_cmd”:”game_new”
    [_gameWinView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    API* myApi = [API sharedController];
    [myApi sendMessage:[myApi objectToJSONString:@{@"command":@"action",@"game_cmd":@"game_new"}]];
    [myApi popToTop:^{
        NSLog(@"Pop to top ok");
        [[API sharedController] initConnectWithServerInfo:nil];
    }];

}
- (IBAction)mainMenuButtonTap:(id)sender
{
     [_gameWinView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    API* myApi = [API sharedController];
    [myApi sendMessage:[myApi objectToJSONString:@{@"command":@"action",@"game_cmd":@"game_close"}]];
}
@end
