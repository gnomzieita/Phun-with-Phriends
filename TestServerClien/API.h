//
//  API.h
//  TestServerClien
//
//  Created by Alex Agarkov on 22.02.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CFBase.h>
#import "GCDAsyncSocket.h"
#import "ServerInfoObject.h"
#import <UIKit/UIKit.h>

@protocol API_Delegat <NSObject>

- (void) newData:(NSString*)stringData;
- (void) connectClose;

@end

@interface API : NSObject

+ (API*)sharedController;

@property (strong, nonatomic) id<API_Delegat> delegat;
@property (strong, nonatomic) ServerInfoObject* serverInf;

- (void) closeConnect;

- (void) initConnectWithServer:(NSString*)serverAddress Port:(UInt32)port;

- (BOOL) initConnectWithServerInfo:(ServerInfoObject*)serverInfo;

- (void) selectCell:(NSInteger)cellnum path:(NSInteger)path;

- (NSString *)getIPAddress;

-(void) sendCard:(NSInteger)cardNum angle:(NSInteger)angle;

- (NSDictionary*) jsonStringToDictionary:(NSString*)jsonString;

- (void) setUserName:(NSString*)userName;

- (void) showErrorMessage:(NSString*)errorString  handler:(void (^)(UIAlertAction *action))handler;

- (void) sendMessage:(NSString*)message;

- (NSString*) objectToJSONString:(id)obj;

- (void) popToTop:(void (^ __nullable)(void))completion;

- (nullable UIViewController*)currentTopViewController;

@end
