//
//  MarketScreen.h
//  Expand_It
//
//  Created by Mac Mini on 02.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MarketScreen : CCNode {
	BOOL isVisible;
	
	CCSprite *backSpr;
	
	CCLabelBMFont* marketItem1Text;
	CCLabelBMFont* marketItem2Text;
	CCLabelBMFont* marketItem3Text;
	CCLabelBMFont* marketItem4Text;
}

- (id) init;
- (void) show:(BOOL)_flag;
- (void) update;
@end
