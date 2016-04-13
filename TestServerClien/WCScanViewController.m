//
//  WCScanViewController.m
//  wayCall
//
//  Created by Alex Agarkov on 12/18/14.
//  Copyright (c) 2014 Alex Agarkov. All rights reserved.
//

#import "WCScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "API.h"
#import "ServerInfoObject.h"
#import "WaitStartViewController.h"

@interface WCScanViewController () <AVCaptureMetadataOutputObjectsDelegate,WCScanViewControllerDelegat,UIAlertViewDelegate>
{
    API *myAPI;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@property (weak, nonatomic) IBOutlet UISegmentedControl *fonarState;
- (IBAction)Fonar:(id)sender;

@end

@implementation WCScanViewController

- (void) exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"gameInit"
                                               object:nil];
    
    myAPI = [API sharedController];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    [self startStopReading];
}

-(void) gameInitNotification
{
    WaitStartViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitStartViewController"];

    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (void)startStopReading {
    if (!_isReading) {
        [self startReading];
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}


#pragma mark - Private method implementation

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasTorch] && [captureDevice hasFlash]){
        
        [captureDevice lockForConfiguration:nil];
        
        if (_fonarState.selectedSegmentIndex == 1) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            [captureDevice setFlashMode:AVCaptureFlashModeOn];
        }
        else
        {
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
            [captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        
        [captureDevice unlockForConfiguration];
    }
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

- (IBAction)Fonar:(id)sender
{
    [self startStopReading];
    [self startStopReading];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (_isReading) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            // Get the metadata object.
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                // If the found metadata is equal to the QR code metadata then update the status label's text,
                // stop reading and change the bar button item's title and the flag's value.
                // Everything is done on the main thread.
                
                
                _isReading = NO;
                
                if (_audioPlayer) {
                    [_audioPlayer play];
                }
                
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(readQRData:) withObject:[metadataObj stringValue] waitUntilDone:YES];
            }
        }
    }
}

-(void) readQRData:(NSString*)stringQR
{
    NSLog(@"stringQR: %@",stringQR);
    
    NSError *jsonError;
    NSData *objectData = [stringQR dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (!jsonError) {
        NSLog(@"json: %@",json);
        [myAPI initConnectWithServerInfo:[[ServerInfoObject alloc] initWithDictionary:json]];
    }
    else
    {
        NSLog(@"jsonError: %@",jsonError);
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self startStopReading];
}

@end

