//
//  SelectStartCellViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 12.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "SelectStartCellViewController.h"
#import "API.h"
#import "GameViewController.h"
#import "MyLabel.h"
#import <AVFoundation/AVFoundation.h>

@interface SelectStartCellViewController ()<UIActionSheetDelegate, AVAudioPlayerDelegate>
{
    API *myAPI;
    UIButton* tapButton;
    NSTimer* sirenaTimer;
    BOOL roundButtonFlag;
    
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *carsArray;
@property (weak, nonatomic) IBOutlet UIView *waitView;

- (IBAction)buttonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *kub;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *vw;

@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (strong, nonatomic) PWPPlayer* myPlayer;


@end

@implementation SelectStartCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    _myPlayer = PLAYER_INIT;
    CGFloat step = 194/18.0f;
    for (int x=0; x<18; x++) {
        for (int y = 0; y<2; y++) {
            if (x%3 != 0) {
                UIView* roundView = [[UIView alloc] initWithFrame:CGRectMake(step*x+4, step*y*18+4, 8, 8)];
                roundView.layer.cornerRadius = 4;

                if (x%3 == 1) {
                    if (y == 1) {
                        roundView.layer.backgroundColor = [UIColor blueColor].CGColor;
                    }
                    else
                    {
                        roundView.layer.backgroundColor = [UIColor redColor].CGColor;
                    }
                }
                else
                {
                    if (y == 1) {
                        roundView.layer.backgroundColor = [UIColor redColor].CGColor;
                    }
                    else
                    {
                        roundView.layer.backgroundColor = [UIColor blueColor].CGColor;
                    }
                }
                [_kub addSubview:roundView];
            }
        }
    }
    for (int y=0; y<18; y++) {
        for (int x = 0; x<2; x++) {
            if (y%3 != 0) {
                UIView* roundView = [[UIView alloc] initWithFrame:CGRectMake(step*x*18+4, step*y+4, 8, 8)];
                roundView.layer.cornerRadius = 4;
                if (y%3 == 1) {
                    if (x == 1) {
                        roundView.layer.backgroundColor = [UIColor redColor].CGColor;
                    }
                    else
                    {
                        roundView.layer.backgroundColor = [UIColor blueColor].CGColor;
                    }
                }
                else
                {
                    if (x == 1) {
                        roundView.layer.backgroundColor = [UIColor blueColor].CGColor;
                    }
                    else
                    {
                        roundView.layer.backgroundColor = [UIColor redColor].CGColor;
                    }
                }
                [_kub addSubview:roundView];
            }
        }
    }
    [_orLabel setStrokeText:NSLocalizedString(@"OR",@"OR")];
    
    for (UIView* view in _vw) {
        if (view.tag > 0) {
         [view setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [view setBackgroundColor:[UIColor clearColor]];
        }
        [view.layer setBorderColor:[UIColor blackColor].CGColor];
        [view.layer setBorderWidth:1.0f];
    }
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    // Do any additional setup after loading the view.
    myAPI = [API sharedController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification:)
                                                 name:@"gameAction"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameError:)
                                                 name:@"gameError"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startGame:)
                                                 name:@"cardInit"
                                               object:nil];
    
    sirenaTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                                  target:self
                                                selector:@selector(policeSirene)
                                                userInfo:nil
                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:sirenaTimer forMode:NSDefaultRunLoopMode];
    
}

- (void) startGame:(NSNotification *) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_myPlayer stopPlay];
    _myPlayer = nil;
    GameViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    [viewController gameInitNotification:notification];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void) policeSirene
{
    [_myPlayer playSound:API_Sound_HurryUp];
    [sirenaTimer invalidate];
    sirenaTimer = nil;
    
    for (UIButton* tempButton in _carsArray) {
        if (tempButton.tag %2 == 0 ) {
            [tempButton setSelected:YES];
        }
        else
        {
            [tempButton setSelected:NO];
        }
    }
    [self animCars];
}
- (void) animCars
{
    [UIView animateWithDuration:2 animations:^
     {
         for (UIButton* tempButton in _carsArray) {
             [tempButton setSelected:!tempButton.selected];
         }
     }
    completion:^(BOOL finished) {
        if (!tapButton) {
            [self animCars];
        }
        else
        {
            for (UIButton* tempButton in _carsArray) {
                if (tempButton == tapButton ) {
                    [tempButton setSelected:YES];
                }
                else
                {
                    [tempButton setSelected:NO];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gameError:(NSNotification *) notification
{
    [notification.userInfo objectForKey:@"error"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error!",@"Error!")
                                                                   message:[notification.userInfo objectForKey:@"error"]
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok",@"Ok")
                                                          style:UIAlertActionStyleDestructive handler:nil]; // 2
    
    [alert addAction:firstAction]; // 4
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonTap:(id)sender
{
    
    tapButton = (UIButton*)sender;
    for (UIButton* tempButton in _carsArray) {
        if (tempButton == tapButton ) {
            [tempButton setSelected:YES];
        }
        else
        {
            [tempButton setSelected:NO];
        }
    }
    
    [_myPlayer stopPlay];
    [_myPlayer playSound:API_Sound_idle];
    
    [sirenaTimer invalidate];
    sirenaTimer = nil;
    sirenaTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                   target:self
                                                 selector:@selector(policeSireneRoundButtons)
                                                 userInfo:nil
                                                  repeats:NO];

}

- (void) policeSireneRoundButtons
{
    [_myPlayer playSound:API_Sound_HurryUp];
    [_redButton setHighlighted:!_redButton.highlighted];
    [self redBlueButtonAnimm];
}

- (void) redBlueButtonAnimm
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^
     {
         [_redButton setHighlighted:!_redButton.highlighted];
         [_blueButton setHighlighted:!_blueButton.highlighted];
     }
    completion:^(BOOL finished)
     {
         if (!roundButtonFlag) {
             [self redBlueButtonAnimm];
         }
     }];
}

-(void) gameInitNotification:(NSNotification *) notification
{
    if ([[notification.userInfo objectForKey:@"result"] boolValue]) {
        [_myPlayer stopPlay];
        _myPlayer = nil;
        [_waitView setHidden:NO];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)redButtonTap:(id)sender
{
    if (tapButton) {
        [_myPlayer stopPlay];
        _myPlayer = nil;
        NSInteger doorNum = tapButton.tag<7?1:(tapButton.tag<13?3:(tapButton.tag<19?5:7));
        [myAPI selectCell:tapButton.tag path:doorNum];
        
        roundButtonFlag = YES;
        [sirenaTimer invalidate];
        sirenaTimer = nil;
    }
}

- (IBAction)blueButtonTap:(id)sender
{
    if (tapButton) {
        [_myPlayer stopPlay];
        _myPlayer = nil;
        NSInteger doorNum = tapButton.tag<7?2:(tapButton.tag<13?4:(tapButton.tag<19?6:8));
        [myAPI selectCell:tapButton.tag path:doorNum];
        
        roundButtonFlag = YES;
        [sirenaTimer invalidate];
        sirenaTimer = nil;
    }

}

- (void) dealloc
{
    _myPlayer = nil;
    myAPI = nil;
    
    [sirenaTimer invalidate];
    sirenaTimer = nil;
}

@end
