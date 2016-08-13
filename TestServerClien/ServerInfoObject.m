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
    
#if DEBUG
    
    #  warning TEST IP
    //_ip = @"100.100.0.34";
    _ip = @"192.168.2.24";
    
#else
    _ip = [dictInfo objectForKey:@"ip"];
#endif
    //_ip = [dictInfo objectForKey:@"ip"];
    _port = [dictInfo objectForKey:@"port"];
    _ssid = [dictInfo objectForKey:@"ssid"];
    return self;
}
@end
