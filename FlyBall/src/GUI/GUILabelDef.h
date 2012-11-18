//
//  GUILabelDef.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItemDef.h"

@interface GUILabelDef : GUIItemDef {
    NSString* text;
    NSString* fontName;
}

@property (nonatomic,assign) NSString* text;
@property (nonatomic,assign) NSString* fontName;

- (id) init;

@end
