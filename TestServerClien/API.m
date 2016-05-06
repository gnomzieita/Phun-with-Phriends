//
//  API.m
//  TestServerClien
//
//  Created by Alex Agarkov on 22.02.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "API.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "WCScanViewController.h"

#define SERVER_PORT 8080

@interface API () <NSStreamDelegate>
{
    NSInputStream	*inputStream;
    NSOutputStream	*outputStream;
    NSMutableArray	*messages;
    NSTimer* serverTimer;
    
    CFStringRef yourFriendlyCFString;
    
    GCDAsyncSocket *asyncSocket;
    NSMutableArray *availableHosts;
    NSInteger count;
    
    NSString* ipRange;
    NSTimer* serverInit;
    
    NSString* token;
    NSString* gameUserName;
    NSUserDefaults* userDef;
}
@end

@implementation API

static API *_sharedController = nil;


+ (API *)sharedController
{
    @synchronized(self)
    {
        if (!_sharedController)
        {
            _sharedController = [[API alloc] init];
            [_sharedController initController];
        }
    }
    return _sharedController;
}

- (void) initController
{
    userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"token"]) {
        [self initConnectWithServer:[userDef objectForKey:@"serverAddress"] Port:[[userDef objectForKey:@"serverPort"] intValue]];
    }
}

-(void) backToGame
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     “command”:”back”,
     “token”:12345
     }

     */
    
    [dict setObject:@"back" forKey:@"command"];
    [dict setObject:token forKey:@"token"];
    
    [self sendMessage:[self objectToJSONString:dict]];
}

- (NSString*) objectToJSONString:(id)obj
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:0
                                                         error:&error];
    
    if (!error) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSLog(@"ObjectToJSONString Error: %@",error);
    }
    return @"";
}

- (NSDictionary*) jsonStringToDictionary:(NSString*)jsonString
{
    NSError *jsonError;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (!jsonError) {
        return json;
    }
    else
    {
        NSLog(@"!!!!!!!!!!!!! jsonError: %@",jsonError);
    }
    return [NSDictionary dictionary];
}

- (void) sendInitServerComand
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     “command”:”init”,
     “device_id”:”ABC”,
     “game_id”:”GameName”,
     “game_version”:1,
     “user_name”:”User Name”
     }
     */
    
    [dict setObject:@"init" forKey:@"command"];
    [dict setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"device_id"];
    
    //[dict setObject:@"lol" forKey:@"device_id"];
    
    [dict setObject:@"TestGame" forKey:@"game_id"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"game_version"];
    [dict setObject:gameUserName forKey:@"user_name"];
    
    [self sendMessage:[self objectToJSONString:dict]];
    
}


//- (void)startScan
//{
//    
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    
//    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
//    NSError *error = nil;
//    
//    NSArray* ipActetArray = [[self getIPAddress] componentsSeparatedByString:@"."];
//    NSString* rangeIP = [NSString stringWithFormat:@"%@.%@.%@.",ipActetArray[0],ipActetArray[1],ipActetArray[2]];
//    
//    for (int i = 1; i < 255; i++) {
//        NSString *scanHostIP = [NSString stringWithFormat:@"%@%d",rangeIP,i];
//        NSLog(@"scanHostIP: %@",scanHostIP);
//        [asyncSocket connectToHost:scanHostIP onPort:SERVER_PORT withTimeout:1 error:&error];
//    }
//}
//
//-(void)startScan
//{
//    dispatch_queue_t mainQueue = dispatch_queue_create("mainQueue",NULL);;
//    
//    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
//    
//    //NSError *error = nil;
//    
//    NSArray* ipActetArray = [[self getIPAddress] componentsSeparatedByString:@"."];
//    ipRange = [NSString stringWithFormat:@"%@.%@.%@.",ipActetArray[0],ipActetArray[1],ipActetArray[2]];
//    //NSLog(@"ipRange: %@",ipRange);
//    //[asyncSocket connectToHost:@"192.168.43.1" onPort:SERVER_PORT withTimeout:1 error:&error];
//    [self sckan];
//}
//
//- (void) sckan
//{
//    NSError* error;
//    if(count < 254)
//    {
//        count++;
//
//        NSString *scanHostIP = [NSString stringWithFormat:@"%@%ld", ipRange, (long)count];
//        NSLog(@"scanHostIP: %@",scanHostIP);
//        [asyncSocket connectToHost:scanHostIP onPort:SERVER_PORT withTimeout:0.5 error:&error];
//    }
//    else
//    {
//        NSLog(@"OK");
//    }
//}

//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
//{
//    if (err) {
//        NSLog(@"socketDidDisconnect ERROR: %@ \r HOST:%@",err,sock);
//    }
//    //[self sckan];
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
//{
//        NSLog(@"Found open port %d on %@", port, host);
//        [availableHosts addObject:host];
//        //[sock setDelegate:nil];
//        [sock disconnect];
//        //[sock setDelegate:self];
//    
//        //[self sckan];
//    
//}

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

- (void) initConnectWithServerInfo:(ServerInfoObject*)serverInfo
{
    NSString *currentSSID = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (NSDictionary *) CFBridgingRelease(CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0)));
        if (myDict!=nil){
            currentSSID=[myDict valueForKey:@"SSID"];
        } else {
            currentSSID=@"<<NONE>>";
        }
    } else {
        currentSSID=@"<<NONE>>"; 
    }
    /*
     gid = TestGame;
     gv = 1;
     ip = "192.168.2.24";
     port = 8080;
     ssid = "Alex's MacBook Pro";
     */
#warning SSID CHEK OFF
    if ([serverInfo.ssid isEqualToString: currentSSID]) {
        [self initConnectWithServer:serverInfo.ip Port:[serverInfo.port intValue]];
    }
    else
    {
        NSLog(@"NE TOT SSID!!");

        
        [self showErrorMessage:@"NE TOT SSID!!" handler:^(UIAlertAction *action) {
            WCScanViewController* vc = (WCScanViewController*)[self currentTopViewController];
            [vc startStopReading];
        }];
        
    }
    
}

- (void) initConnectWithServer:(NSString*)serverAddress Port:(UInt32)port
{
    [userDef setObject:serverAddress forKey:@"serverAddress"];
    [userDef setObject:[NSNumber numberWithInteger:port] forKey:@"serverPort"];
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    if (!yourFriendlyCFString) {
        yourFriendlyCFString = (__bridge CFStringRef)serverAddress;
    }
    CFStreamCreatePairWithSocketToHost(NULL, yourFriendlyCFString, port, &readStream, &writeStream);
    
    inputStream = (__bridge_transfer NSInputStream *)readStream;
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    serverTimer = [NSTimer scheduledTimerWithTimeInterval:0.4
                                                   target:self
                                                 selector:@selector(sendLeave)
                                                 userInfo:nil
                                                  repeats:YES];
    
    if ([userDef objectForKey:@"token"]) {
        token = [userDef objectForKey:@"token"];
        serverInit = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(backToGame)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    else
    {
        serverInit = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(sendInitServerComand)
                                                    userInfo:nil
                                                     repeats:NO];
    }

}

- (void) sendLeave {
    
    [self sendMessage:@"!"];
    //[self sendInitServerComand];
    
}

- (void) sendMessage:(NSString*)message {
    
    NSString *response  = [NSString stringWithFormat:@"%@\r", message];
    NSLog(@"sendMessage: %@",response);
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    enum {
        NSStreamEventNone = 0,
        NSStreamEventOpenCompleted = 1 << 0,
        NSStreamEventHasBytesAvailable = 1 << 1,
        NSStreamEventHasSpaceAvailable = 1 << 2,
        NSStreamEventErrorOccurred = 1 << 3,
        NSStreamEventEndEncountered = 1 << 4
    };
    
    switch (theStream.streamStatus) {
        case NSStreamStatusNotOpen:
            NSLog(@"NSStreamStatusNotOpen");
            
            break;
        case NSStreamStatusOpening:
            NSLog(@"NSStreamStatusOpening");
            
            break;
        case NSStreamStatusOpen:
//            NSLog(@"NSStreamStatusOpen");
//            NSLog(@"stream event %lu", (unsigned long)streamEvent);
            
            switch (streamEvent) {
                    
                case NSStreamEventOpenCompleted:
                   // NSLog(@"Stream opened");
                    if (theStream == outputStream) {
                        //[self sendInitServerComand];
                    }
                    
                    break;
                case NSStreamEventHasBytesAvailable:
                    
                    if (theStream == inputStream) {
                        
                        uint8_t buffer[1024];
                        NSInteger len;
                        
                        while ([inputStream hasBytesAvailable]) {
                            len = [inputStream read:buffer maxLength:sizeof(buffer)];
                            if (len > 0) {
                                
                                NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                                
                                if (nil != output) {
                                    
                                    //NSLog(@"server said: %@", output);
                                    if (![output isEqualToString:@"!\r\n"]) {
                                        [self messageReceived:output];
                                    }

                                    
                                }
                            }
                        }
                    }
                    break;
                    
                    
                case NSStreamEventErrorOccurred:
                    
                    NSLog(@"Can not connect to the host!");
                    break;
                    
                case NSStreamEventEndEncountered:
                    NSLog(@"NSStreamEventEndEncountered!");
                    [theStream close];
                    [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                    theStream = nil;
                    
                    break;
                    
                case NSStreamEventNone:
                    //NSLog(@"NSStreamEventNone!");
                    break;
                case NSStreamEventHasSpaceAvailable:
                    //NSLog(@"NSStreamEventHasSpaceAvailable");
                    break;
                default:
                    NSLog(@"Unknown event: %lu",(unsigned long)streamEvent);
            }
            
            
            break;
        case NSStreamStatusReading:
            NSLog(@"NSStreamStatusReading");
            break;
        case NSStreamStatusWriting:
            NSLog(@"NSStreamStatusWriting");
            break;
        case NSStreamStatusAtEnd:
            NSLog(@"NSStreamStatusAtEnd");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            [serverTimer invalidate];
            break;
        case NSStreamStatusClosed:
            NSLog(@"NSStreamStatusClosed");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            [serverTimer invalidate];
            break;
        case NSStreamStatusError:
            NSLog(@"NSStreamStatusError");
            
            NSLog(@"streamError: %@",theStream.streamError);
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            [serverTimer invalidate];
            break;
            
        default:
            break;
    }
}

- (void) messageReceived:(NSString *)message
{

    NSDictionary* responseDict = [self jsonStringToDictionary:message];
    NSLog(@"messageReceived: %@",message);
//     NSLog(@"responseDict: %@",responseDict);
    if ([[responseDict objectForKey:@"response"] isEqualToString:@"init"])
    {
    /*
     {"admin":true,"game_type":0,"response":"init","token":1460459365508,"user_shuffle":true}
     */
        if (![responseDict objectForKey:@"error"])
        {
            token = [responseDict objectForKey:@"token"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gameInit" object:self userInfo:responseDict];
        }
        else
        {
            [self showErrorMessage:[responseDict objectForKey:@"error"] handler:nil];
        }
    }
    else if ([[responseDict objectForKey:@"response"] isEqualToString:@"start"])
    {
        /*{"admin":false,"response":"start"}*/
        if (![responseDict objectForKey:@"error"]) {
            [userDef setObject:token forKey:@"token"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gameStart" object:self];
        }
        else
        {
            [self showErrorMessage:[responseDict objectForKey:@"error"] handler:nil];
        }
    }
    else if ([[responseDict objectForKey:@"response"] isEqualToString:@"action"])
    {
        /*{"card":[18,29,34],"color":-769226,"cur_user":"Pupkin","game_cmd":"info","game_over":false,"path":1,"response":"action","step":true}*/
        
        NSLog(@"response action %@",responseDict);
        if ([[responseDict objectForKey:@"game_cmd"] isEqualToString:@"init_pos"]) {
            if ([[responseDict objectForKey:@"game_cmd"] isEqualToString:@"error"])
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gameError" object:nil];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gameAction" object:nil];
            }
            
        }
        else if ([[responseDict objectForKey:@"game_cmd"] isEqualToString:@"info"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cardInit" object:nil userInfo:responseDict];
        }
        else if ([[responseDict objectForKey:@"game_cmd"] isEqualToString:@"end_game"])
        {
            [userDef removeObjectForKey:@"token"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"end_game" object:nil];
        }
        else if ([[responseDict objectForKey:@"game_cmd"] isEqualToString:@"game_over"])
        {
            [userDef removeObjectForKey:@"token"];
            //“game_over”:false
            [[NSNotificationCenter defaultCenter] postNotificationName:@"game_over" object:nil userInfo:responseDict];
        }
    }
    else if ([[responseDict objectForKey:@"response"] isEqualToString:@"back"]){
        if (![responseDict objectForKey:@"error"]) {
            token = [responseDict objectForKey:@"token"];
            [userDef setObject:token forKey:@"token"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
        }
        else
        {
            [userDef removeObjectForKey:@"token"];
        }
    }
    
}

-(void) selectCell:(NSInteger)cellnum path:(NSInteger)path
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     “command”:”action”,
     “game_cmd”:”init_pos”,
     “position”:10, //номера на картинке
     “path”:2 

     }
     */
    
    [dict setObject:@"action" forKey:@"command"];
    [dict setObject:@"init_pos" forKey:@"game_cmd"];

    [dict setObject:[NSNumber numberWithInteger:cellnum] forKey:@"position"];
    [dict setObject:[NSNumber numberWithInteger:path] forKey:@"path"];
    
    [self sendMessage:[self objectToJSONString:dict]];
}

-(void) sendCard:(NSInteger)cardNum angle:(NSInteger)angle
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     “command”:”action”,
     “game_cmd”:”step”,
     “card”:2, //номер карты
     “angle”:2  // 0 – исходное положение, 1 – 90гр., 2 – 180гр., 3 – 270гр.
     }
     */
    
    [dict setObject:@"action" forKey:@"command"];
    [dict setObject:@"step" forKey:@"game_cmd"];
    
    [dict setObject:[NSNumber numberWithInteger:cardNum] forKey:@"card"];
    [dict setObject:[NSNumber numberWithInteger:angle] forKey:@"angle"];
    
    [self sendMessage:[self objectToJSONString:dict]];
}

- (void) setUserName:(NSString*)userName
{
    gameUserName = userName;
}

- (void) showErrorMessage:(NSString*)errorString  handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:@"Error!" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:handler];
    [alertControl addAction:okAction];
    UIViewController *vc = [self currentTopViewController];
    
    [vc presentViewController:alertControl animated:YES completion:nil];
    
}

- (UIViewController *)currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
@end
