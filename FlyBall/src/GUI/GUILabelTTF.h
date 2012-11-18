//
//  GUILableTTF.h
//  Expand_It
//
//  Created by Mac Mini on 10.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItem.h"

@interface GUILabelTTF : GUIItem {
	CCLabelTTF *spr;
    NSString * text;
    NSString* fontName;
    float fontSize;
    CGSize containerSize;
}

@property (nonatomic, retain) CCLabelTTF *spr;
@property (nonatomic,assign) NSString* fontName;
@property (nonatomic,readwrite) float fontSize;
@property (nonatomic,readwrite) CGSize containerSize;

- (id) init:(id)_def;
- (void) setText:(NSString *)_text;
- (void) show:(BOOL)_flag;

@end
