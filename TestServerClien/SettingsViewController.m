//
//  SettingsViewController.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 26.05.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()
{
    NSUserDefaults* userDef;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
- (IBAction)okButtonTap:(id)sender;
- (IBAction)cancelButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userDef = [NSUserDefaults standardUserDefaults];
    if (![userDef objectForKey:@"userName"]) {
        [userDef setObject:[[UIDevice currentDevice] name] forKey:@"userName"];
    }
    
    [_userNameTextField setText:[userDef objectForKey:@"userName"]];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    NSDictionary *typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:20.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor colorWithRed:58.0f/255.0f green:35.0f/255.0f blue:10.0f/255.0f alpha:1.0f],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                                       };
    NSAttributedString *str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(@"User name",@"User name")
                               attributes:typingAttributes];
    
    [_userName setAttributedText:str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)okButtonTap:(id)sender
{
    [userDef setObject:_userNameTextField.text forKey:@"userName"];
    [[API sharedController] setUserName:_userNameTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField  resignFirstResponder];
    return YES;
}
@end
