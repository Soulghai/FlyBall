//
//  GUILabel.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItem.h"

@interface GUILabel : GUIItem {
	CCLabelTTF *spr;
    NSString * text;
    NSString* fontName;
}

@property (nonatomic, retain) CCLabelTTF *spr;
@property (nonatomic,assign) NSString* fontName;

- (id) init:(id)_def;
- (void) setText:(NSString *)_text;
- (void) show:(BOOL)_flag;

@end
