//
//  GameStandartFunctions.h
//  Expand_It
//
//  Created by Mac Mini on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameStandartFunctions : CCNode {

}
+(GameStandartFunctions*) instance;


- (id) init;
- (void) dealloc;

- (void) checkBoxEnableSoundAction;
- (void) goToUrl:(NSString*)_url;
- (NSString*) pasteDot:(NSString*)_string;
- (void) showRateAlert;
- (void) playCurrentBackgroundMusicTrack;
- (void) playCloseScreenAnimation:(unsigned int)_nextScreenType;
- (void) playOpenScreenAnimation;
- (void) hideScreenAnimation;


@end
