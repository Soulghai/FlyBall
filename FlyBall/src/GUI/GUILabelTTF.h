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
    CCTextAlignment alignement;
    ccColor3B textColor;
}

@property (nonatomic, retain) CCLabelTTF *spr;
@property (nonatomic,assign) NSString* fontName;
@property (nonatomic,readwrite) float fontSize;
@property (nonatomic,readwrite) CGSize containerSize;
@property (nonatomic,readwrite) CCTextAlignment alignement;

- (id) init:(id)_def;
- (void) setText:(NSString *)_text;
- (void) show:(BOOL)_flag;
- (void) setColor:(ccColor3B)_cc3;
@end
