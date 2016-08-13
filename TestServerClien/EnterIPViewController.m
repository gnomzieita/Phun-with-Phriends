//
//  EnterIPViewController.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 26.05.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "EnterIPViewController.h"
#import "WaitStartViewController.h"
#import "AdminViewController.h"

@interface EnterIPViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *portLabel;

- (IBAction)okButtonTap:(id)sender;
- (IBAction)cancelButtonTap:(id)sender;
@end

@implementation EnterIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification:)
                                                 name:@"gameInit"
                                               object:nil];
    
    NSArray* ipActetArray = [[[API sharedController] getIPAddress] componentsSeparatedByString:@"."];
    NSString* rangeIP = [NSString stringWithFormat:@"%@.%@.%@.",ipActetArray[0],ipActetArray[1],ipActetArray[2]];
    
    [_ipTextField setText:rangeIP];
    [_ipTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
    
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
                               initWithString:NSLocalizedString(@"IP Addres",@"IP Addres")
                               attributes:typingAttributes];
    
    [_ipAddressLabel setAttributedText:str];
    
    str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(@"Port",@"Port")
                               attributes:typingAttributes];
    
    [_portLabel setAttributedText:str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else
    {
        WaitStartViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitStartViewController"];
        
        [self presentViewController:viewController animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
    }
}

- (IBAction)okButtonTap:(id)sender
{
    [[API sharedController] initConnectWithServer:_ipTextField.text Port:[_portTextField.text intValue]];
}

- (IBAction)cancelButtonTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _ipTextField) {
        [_portTextField becomeFirstResponder];
    }
    else
    {
        [_portTextField resignFirstResponder];
    }
    return YES;
}
@end
