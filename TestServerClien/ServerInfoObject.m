//
//  ServerInfoObject.m
//  TestServerClien
//
//  Created by Alex Agarkov on 30.03.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "ServerInfoObject.h"

@implementation ServerInfoObject

-(instancetype) initWithDictionary:(NSDictionary*)dictInfo
{
    _gid = [dictInfo objectForKey:@"gid"];
    _gv = [dictInfo objectForKey:@"gv"];
    _ip = [dictInfo objectForKey:@"ip"];
    _port = [dictInfo objectForKey:@"port"];
    _ssid = [dictInfo objectForKey:@"ssid"];
    return self;
}
@end
