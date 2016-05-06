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
@property (weak, nonatomic) IBOutlet GameCardView *card_1;
@property (weak, nonatomic) IBOutlet GameCardView *card_2;
@property (weak, nonatomic) IBOutlet GameCardView *card_3;
@property (strong, nonatomic) IBOutlet GameCardView *selectCard;
@property (weak, nonatomic) IBOutlet UILabel *NextStepName;

@property (weak, nonatomic) IBOutlet GameCardView *cardTemp;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

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
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    _okButton.layer.cornerRadius = 10.f;
    arrayOfCard = [NSArray arrayWithObjects:_card_1,_card_2,_card_3, nil];
    
    /*{"card":[18,29,34],"color":-769226,"cur_user":"Pupkin","game_cmd":"info","game_over":false,"path":1,"response":"action","step":true}*/
//    _cardArray = [NSArray arrayWithObjects:@"18",@"29",@"34",nil];
//    _roadStart = 1;
//    _rotate = 0;
    
   // [self loadCard];
    // Do any additional setup after loading the view.
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
}

- (void) gameEnd:(NSNotification *) notification
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Игра оконченна" message:@"ЭЭ" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionButtonOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //[[[[self presentingViewController] presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        [[[[[self presentingViewController] presentingViewController] presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:actionButtonOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) game_over:(NSNotification *) notification
{
    BOOL isWinn = [[[notification userInfo] objectForKey:@"game_over"] boolValue];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Игра оконченна" message:isWinn?@"Вы выиграли!":@"Вы проиграли!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionButtonOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        [[[[[self presentingViewController] presentingViewController] presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:actionButtonOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) gameInitNotification:(NSNotification *) notification {
    [_activity stopAnimating];
    NSLog(@"User info %@", notification.userInfo);
    NSArray* cardArray = [NSArray arrayWithArray:[notification.userInfo objectForKey:@"card"]];
    NSLog(@"cardArray %@", cardArray);
    _rotate = 0;
    _cardArray = cardArray;
    rotateArray = [NSArray arrayWithArray:[notification.userInfo objectForKey:@"rotating"]];
    _roadStart = [[notification.userInfo objectForKey:@"path"] integerValue];
    [_NextStepName setText:[NSString stringWithFormat:@"Следующим ходит: %@",[notification.userInfo objectForKey:@"cur_user"]]];
    roadColor = UIColorFromRGB([[notification.userInfo objectForKey:@"color"] integerValue]);
    [self.view setBackgroundColor:roadColor];
    _card_1.roadColor = roadColor;
    _card_2.roadColor = roadColor;
    _card_3.roadColor = roadColor;
    _selectCard.roadColor = roadColor;
    [self loadCard];
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

- (void) reloadCard:(GameCardView*)gameCard oldCard:(GameCardView*)oldCard withType:(GameCardType)cardType
{
    GameCardView* view = [[GameCardView alloc] initWithFrame:oldCard.frame];
    [view setType:cardType startRoad:_roadStart rotate:_rotate];
    
    [oldCard removeFromSuperview];
    oldCard = nil;
    [self.view addSubview:view];
    oldCard = view;
}

- (void) setSelectedCard:(GameCardView *)selectCard
{
    for (GameCardView* tempCard in arrayOfCard) {
        if (tempCard == selectCard) {
            tempCard.layer.borderColor = [UIColor blueColor].CGColor;
            tempCard.layer.borderWidth = 2;
            
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
//    [UIView animateWithDuration:1 animations:^{
//
//        _cardTemp = _card_1;
//        
//        [_card_1 setFrame:_selectCard.frame];
//        
//        //[_selectCard setFrame:_tempRect];
//        
//    } completion:^(BOOL finished) {
        _rotate = 0;
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_card_1.cardType startRoad:_card_1.startRoad rotate:_rotate];
        view.isRotatingCard = _card_1.isRotatingCard;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    [self setSelectedCard:_card_1];
//    }];
}

- (IBAction)card_2_tap:(id)sender
{
//    [UIView animateWithDuration:1 animations:^{
//        _tempRect = _card_2.frame;
//        
//        [_card_2 setFrame:_selectCard.frame];
//        
//        [_selectCard setFrame:_tempRect];
//        
//    } completion:^(BOOL finished) {
        _rotate = 0;
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_card_2.cardType startRoad:_card_2.startRoad rotate:_rotate];
        view.isRotatingCard = _card_2.isRotatingCard;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    [self setSelectedCard:_card_2];
//    }];
}

- (IBAction)card_3_tap:(id)sender
{
//    [UIView animateWithDuration:1 animations:^{
//        _tempRect = _card_3.frame;
//        
//        [_card_3 setFrame:_selectCard.frame];
//        
//        //[_selectCard setFrame:_tempRect];
//        
//    } completion:^(BOOL finished) {
        _rotate = 0;
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_card_3.cardType startRoad:_card_3.startRoad rotate:_rotate];
        view.isRotatingCard = _card_3.isRotatingCard;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    [self setSelectedCard:_card_3];
//    }];
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
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}


- (BOOL)shouldAutorotate {
    return NO;
}

@end
