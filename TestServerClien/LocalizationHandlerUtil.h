//
//  LocalizationHandlerUtil.h
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 20.05.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationHandlerUtil : NSObject

+ (LocalizationHandlerUtil *)singleton;
- (NSString *)localizedString:(NSString *)key comment:(NSString *)comment;

@end
