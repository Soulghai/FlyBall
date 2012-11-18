//
//  ZFontManager.h
//  Beltality
//
//  Created by Mac Mini on 06.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ZFontManager : NSObject {
	//NSMutableArray *texture;
	//int size;
	//float kerning;
	//NSString *font_text;
}

+(ZFontManager*) instance;
- (id) init;
-(CCRenderTexture*) createStroke: (CCLabelTTF*) label   size:(float)size   color:(ccColor3B)cor;
- (CCLabelBMFont *) textOut:(CGPoint)_pos
                       _str:(NSString *)_str;
- (CCLabelBMFont *) textOutOutlined:(CGPoint)_pos
                               _str:(NSString *)_str;
- (CCLabelTTF *) textOutTTF:(CGPoint)_pos
                       _str:(NSString *)_str
                      _size:(float)_size;
- (CCSprite *) textOutTTFOutlined:(CGPoint)_pos
                           _str:(NSString *)_str
                          _size:(float)_size
                   _outlineSize:(float)_outlineSize;
- (CCSprite *) textOutTTFOutlinedMultiString:(CGPoint)_pos
                                        _str:(NSString *)_str
                                       _size:(float)_size
                                _outlineSize:(float)_outlineSize
                              _containerSize:(CGSize)_containerSize;
@end
