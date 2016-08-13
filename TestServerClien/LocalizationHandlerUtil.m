//
//  LocalizationHandlerUtil.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 20.05.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "LocalizationHandlerUtil.h"

@implementation LocalizationHandlerUtil

static LocalizationHandlerUtil * singleton = nil;

+ (LocalizationHandlerUtil *)singleton
{
    return singleton;
}

__attribute__((constructor))
static void staticInit_singleton()
{
    singleton = [[LocalizationHandlerUtil alloc] init];
}

- (NSString *)localizedString:(NSString *)key comment:(NSString *)comment
{
    // default localized string loading
    NSString * localizedString = [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
    
    // if (value == key) and comment is not nil -> returns comment
    if([localizedString isEqualToString:key] && comment !=nil)
        return comment;
    
    return localizedString;
}

@end
