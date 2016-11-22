//
//  ViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 22.02.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "ViewController.h"
#import "GameCardView.h"
#import "GameViewController.h"
#import "WCScanViewController.h"
#import <Chartboost/Chartboost.h>
#import "SettingsViewController.h"
#import "AdminViewController.h"

@interface ViewController ()

@property (strong, nonatomic) API* myAPI;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *enteripButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UITextField *nikPole;


- (IBAction)startTab:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        SettingsViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
        [self presentViewController:viewController animated:YES completion:^{
            //[[NSNotificationCenter defaultCenter] removeObserver:self];
        }];

    }
    
    NSDictionary *typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:30.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor colorWithRed:255.0f/255.0f green:140.0f/255.0f blue:24.0f/255.0f alpha:1.0f],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                                       };
    NSAttributedString *str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(@"Scan QR",@"Scan QR")
                               attributes:typingAttributes];
    
    [_startButton setAttributedTitle:str forState:UIControlStateNormal];
    
    typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:30.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor colorWithRed:95.0f/255.0f green:22.0f/255.0f blue:161.0f/255.0f alpha:1.0f],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                                       };
    str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(@"Enter IP",@"Enter IP")
                               attributes:typingAttributes];
    
    [_enteripButton setAttributedTitle:str forState:UIControlStateNormal];
    
    typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:30.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor colorWithRed:253.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                                       };
    str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(@"Settings",@"Settings")
                               attributes:typingAttributes];
    
    [_settingsButton setAttributedTitle:str forState:UIControlStateNormal];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"back"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification:)
                                                 name:@"gameInit"
                                               object:nil];
    
     _myAPI = [API sharedController];
    //self.title = NSLocalizedString(@"view_settings_title", @"Settings");
}

-(void) gameInitNotification:(NSNotification *) notification
{
    if ([[[notification userInfo] objectForKey:@"admin"] boolValue])
    {
        AdminViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewController"];
        
        [self presentViewController:viewController animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gameInitNotification
{
    GameViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    
    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}
- (IBAction)startTab:(id)sender
{
//        WCScanViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WCScanViewController"];
//        
//        [self presentViewController:viewController animated:YES completion:^{
//            [[NSNotificationCenter defaultCenter] removeObserver:self];
//        }];

}


- (BOOL)shouldAutorotate {
    return NO;
}

@end
