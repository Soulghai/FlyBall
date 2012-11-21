//
//  GUILabelTTFDef.h
//  Expand_It
//
//  Created by Mac Mini on 10.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItemDef.h"

@interface GUILabelTTFDef : GUIItemDef {
    NSString* text;
    NSString* fontName;
    float fontSize;
    CGSize containerSize;
    ccColor3B textColor;
    CCTextAlignment alignement;
}

@property (nonatomic,assign) NSString* text;
@property (nonatomic,assign) NSString* fontName;
@property (nonatomic,readwrite) float fontSize;
@property (nonatomic,readwrite) CGSize containerSize;
@property (nonatomic,readwrite) ccColor3B textColor;
@property (nonatomic,readwrite) CCTextAlignment alignement;

- (id) init;

@end
