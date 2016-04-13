//
//  ServerInfoObject.h
//  TestServerClien
//
//  Created by Alex Agarkov on 30.03.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerInfoObject : NSObject

@property (strong, nonatomic) NSString* gid;
@property (strong, nonatomic) NSString* gv;
@property (strong, nonatomic) NSString* ip;
@property (strong, nonatomic) NSString* port;
@property (strong, nonatomic) NSString* ssid;

-(instancetype) initWithDictionary:(NSDictionary*)dictInfo;
@end
