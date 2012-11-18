//
//  Statistics.h
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Statistics : NSObject {
}

@property (nonatomic, assign) int totalLevelsComplite;
@property (nonatomic, assign) int totalLevelsStart;
@property (nonatomic, assign) int rateMeWindowShowValue;

+(Statistics*) instance;

- (void)dealloc;

@end
