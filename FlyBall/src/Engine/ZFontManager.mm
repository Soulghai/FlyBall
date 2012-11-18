//
//  ZFontManager.m
//  Beltality
//
//  Created by Mac Mini on 06.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFontManager.h"
#import "globalParam.h"

@implementation ZFontManager

static ZFontManager *instance_;

static void instance_remover() {
	[instance_ release];
}

+ (ZFontManager*)instance {
	@synchronized(self) {
		if( instance_ == nil ) {
			[[self alloc] init];
		}
	}
	
	return instance_;
}

- (id)init {
	self = [super init];
	instance_ = self;
	
	atexit(instance_remover);
	
	return self;
}

-(CCRenderTexture*) createStroke: (CCLabelTTF*) label   size:(float)size   color:(ccColor3B)cor
{
	CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:label.texture.contentSize.width+size*2  height:label.texture.contentSize.height+size*2];
	CGPoint originalPos = [label position];
	ccColor3B originalColor = [label color];
	[label setColor:cor];
	ccBlendFunc originalBlend = [label blendFunc];
	[label setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
	CGPoint center = ccp(label.texture.contentSize.width/2+size, label.texture.contentSize.height/2+size);
	[rt begin];
	for (int i=0; i<360; i+=15)
	{
		[label setPosition:ccp(center.x + sin(CC_DEGREES_TO_RADIANS(i))*size, center.y + cos(CC_DEGREES_TO_RADIANS(i))*size)];
		[label visit];
	}
	[rt end];
	[label setPosition:originalPos];
	[label setColor:originalColor];
	[label setBlendFunc:originalBlend];
	[rt setPosition:originalPos];
	return rt;
}
 
- (CCLabelBMFont *) textOut:(CGPoint)_pos
				  _str:(NSString *)_str{
	/*int i;
 
 var bitmap:Bitmap = new Bitmap(new BitmapData(text.length*(kerning)+32-kerning,32,true, 0x00000000));
 var letterId:int;
 text = text.toUpperCase();
 trace(text,_x,_y);
 for (i = 0; i < text.length; i++) {
 if (text.charAt(i) == ' ') continue;
 letterId = font_text.indexOf(text.charAt(i));
 if (letterId > -1){
 bitmap.bitmapData.copyPixels(Bitmap(texture[letterId]).bitmapData, new Rectangle(0, 0, 32, 32), new Point((kerning) * i, 0),null,null,true);
 }
 }
 
 bitmap.position = ccp(_x,_y);
 bitmap.visible = false;*/
	
	CCLabelBMFont *font = [CCLabelBMFont labelWithString:_str fntFile:@"fntNumber.fnt"];
	font.position = ccp(_pos.x, _pos.y);
	[font setAnchorPoint:ccp(0.5f,0.5f)];
	[font retain];
    
    /*CCLabelTTF *font = [CCLabelTTF labelWithString:_str fontName:@"Baveuse.ttf" fontSize:30];
    font.position = ccp(_pos.x, _pos.y);
	//[font setAnchorPoint:ccp(0.5f,0.5f)];
	[font retain];*/
	
	return font;
 }

- (CCLabelBMFont *) textOutOutlined:(CGPoint)_pos
                       _str:(NSString *)_str{
	
	CCLabelBMFont *font = [CCLabelBMFont labelWithString:_str fntFile:@"myriadpro_bold_48.fnt"];
	font.position = ccp(_pos.x, _pos.y);
	[font setAnchorPoint:ccp(0.5f,0.5f)];
	[font retain];
	
	return font;
}

- (CCLabelTTF *) textOutTTF:(CGPoint)_pos
                       _str:(NSString *)_str
                      _size:(float)_size {
    
    CCLabelTTF *font = [CCLabelTTF labelWithString:_str fontName:@"MyriadPro-Bold" fontSize:_size];
     font.position = ccp(_pos.x, _pos.y);
     //[font setAnchorPoint:ccp(0.5f,0.5f)];
     [font retain];
	
	return font;
}

- (CCSprite *) textOutTTFOutlined:(CGPoint)_pos
                       _str:(NSString *)_str
                      _size:(float)_size
                   _outlineSize:(float)_outlineSize {
    CCSprite* fontOutlined = [CCSprite node];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:_str
                         //dimensions:CGSizeMake(305,179) alignment:UITextAlignmentLeft
                                           fontName:@"MyriadPro-Bold" fontSize:_size];
    [label setPosition:ccp(_pos.x, _pos.y)];
    [label setColor:ccWHITE];
    CCRenderTexture* stroke = [self createStroke:label  size:_outlineSize  color:ccBLACK];
    [fontOutlined addChild:stroke];
    [fontOutlined addChild:label];
	
	return fontOutlined;
}

- (CCSprite *) textOutTTFOutlinedMultiString:(CGPoint)_pos
                                        _str:(NSString *)_str
                                       _size:(float)_size
                                _outlineSize:(float)_outlineSize
                              _containerSize:(CGSize)_containerSize {
    CCSprite* fontOutlined = [CCSprite node];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:_str fontName:@"MyriadPro-Bold" fontSize:_size
                                         dimensions:_containerSize hAlignment:kCCTextAlignmentCenter];

    [label setPosition:ccp(_pos.x, _pos.y)];
    [label setColor:ccWHITE];
    CCRenderTexture* stroke = [self createStroke:label  size:_outlineSize  color:ccBLACK];
    [fontOutlined addChild:stroke];
    [fontOutlined addChild:label];
	
	return fontOutlined;
}
 
/* - (void) textOutBitmap:(Bitmap)_bitmap
 _x:(float)_x
 _y:(float)_y
 text:(NSString *){
 int i;
 
 _bitmap.bitmapData.fillRect(new Rectangle(0, 0, _bitmap.width, _bitmap.height), 0x00000000);
 int letterId;
 text = text.toUpperCase();
 trace(text,_x,_y);
 for (i = 0; i < text.length; i++) {
 if (text.charAt(i) == ' ') continue;
 letterId = font_text.indexOf(text.charAt(i));
 if (letterId > -1){
 _bitmap.bitmapData.copyPixels(Bitmap(texture[letterId]).bitmapData, new Rectangle(0, 0, 32, 32), new Point((kerning) * i, 0),null,null,true);
 }
 }
 _bitmap.position = ccp(_x,_y);
 }*/
@end
