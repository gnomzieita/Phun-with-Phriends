
//
//  WaitStartViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 12.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "WaitStartViewController.h"
#import "SelectStartCellViewController.h"
#import "AdminViewController.h"
#import "GameCardView.h"
#import "MyLabel.h"

@interface WaitStartViewController ()
{
    NSTimer* timer;
    UIView* mview;
}
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet GameCardView *card;
@property (assign, nonatomic) NSInteger rotate;
@end

@implementation WaitStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [_waitLabel setStrokeText:@"Waiting users..."];
    
    _card.isRotatingCard = NO;
    [_card setType:(rand()%35)+1 startRoad:(rand()%8)+1 rotate:0];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"gameStart"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotif:)
                                                 name:@"gameInit"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.3
                                             target:self
                                           selector:@selector(rotateCard)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void) rotateCard
{
    [UIView animateWithDuration:1 animations:^{
        if (rand()%2) {
            _card.transform = CGAffineTransformMakeRotation(-M_PI_2);
            _rotate = _rotate-1<0?3:_rotate-1;
        }
        else
        {
            _card.transform = CGAffineTransformMakeRotation(M_PI_2);
            _rotate = _rotate+1>3?0:_rotate+1;
        }
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_card.frame];
        view.isRotatingCard = _card.isRotatingCard;
        [view setType:(rand()%35)+1 startRoad:(rand()%8)+1 rotate:_rotate];
        [_card removeFromSuperview];
        
        [self.view addSubview:view];
        _card = view;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gameInitNotif:(NSNotification *) notification
{
    if ([[[notification userInfo] objectForKey:@"admin"] boolValue])
    {
        [timer invalidate];
        timer = nil;
        AdminViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewController"];
        
        [self presentViewController:viewController animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
    }
}

-(void) gameInitNotification
{
    [timer invalidate];
    timer = nil;
    
    SelectStartCellViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectStartCellViewController"];
    
    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [timer invalidate];
        timer = nil;
    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void) dealloc
{
    [timer invalidate];
    timer = nil;
    NSLog(@"DEALLOC");
}
@end
