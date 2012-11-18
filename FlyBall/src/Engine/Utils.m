//
//  Utils.m
//  Beltality
//
//  Created by Mac Mini on 02.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import "Utils.h"
#import "cocos2d.h"

@implementation Utils

static Utils *instance_;

static void utils_remover() {
	[instance_ release];
}

+ (Utils*)instance {
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
	
	atexit(utils_remover);
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (float) distance:(float)_x1
			   _y1:(float)_y1
			  _x2:(float)_x2
			  _y2:(float)_y2 {
	return sqrt((_x1-_x2)*(_x1-_x2)+(_y1-_y2)*(_y1-_y2));
}

- (float) myRandomF{
	return ((float)arc4random()/0x100000000);	
}

- (float) myRandom2F{
	return (((float)arc4random()/0x100000000)-((float)arc4random()/0x100000000));	
}

- (float) aspire:(float)_start 
			 _aim:(float)_aim
		   _speed:(float)_speed{
	if (_start + _speed < _aim) return _start + _speed;
	if (_start - _speed > _aim) return _start - _speed;
	return _aim;
}

- (int) timeToNormalTime:(int)_time
					  day:(BOOL)day
					 hour:(BOOL)hour
				   minute:(BOOL)minute
				   second:(BOOL)second
{
	if (day)  return (int)(_time / 86400);
	if (hour) return (int)(_time / 3600);
	if (minute) return (int)(_time / 60);
	if (second) return _time % 60;	
	return  0;
}


-(int) getOpr:(CGPoint)P1 P2:(CGPoint)P2 P3:(CGPoint)P3 {
	return  P1.x*P2.y*1 + P1.y*P3.x*1 + P2.x*P3.y*1 - P3.x*P2.y*1 - P2.x*P1.y*1 - P3.x*P1.y*1;
}

-(int) calcSofPolygon:(NSArray*)_Shape {
	// Считаем площадь полигона
	int S = 0;
	int N = 0;
	for (int i = 0; i < [_Shape count]; i++){
		N = i+1;
		if (N > [_Shape count]-1) N = 0;
		S = S + [self getOpr:CGPointMake(0, 0) P2:[[_Shape objectAtIndex:i] CGPointValue] P3:[[_Shape objectAtIndex:N] CGPointValue]];
	}
	return S;
}

// Fast approximate arctan2 code posted by Jim Shima
// return val in radians
static float arctan2( float y, float x ) {
	const float ONEQTR_PI = 0.78539816339f;
	const float THRQTR_PI = 2.35619449019f;
	float r, angle;
	float abs_y = fabs(y) + 1e-10f;      // kludge to prevent 0/0 condition
	if ( x < 0.0f ) {
		r = (x + abs_y) / (abs_y - x);
		angle = THRQTR_PI;
	} else {
		r = (x - abs_y) / (x + abs_y);
		angle = ONEQTR_PI;
	}
	angle += (0.1963f * r * r - 0.9817f) * r;
	return ( y < 0.0f ) ? -angle : angle;   // negate if in quad III or IV
}

// return in degrees(0-360)
+ (float) GetAngleBetweenPt1:(CGPoint) pt1 andPt2:(CGPoint) pt2 {
    float dx, dy;
    
    dx = pt1.x - pt2.x;
    dy = pt1.y - pt2.y;
    float res = arctan2( dy, dx );
    float angle = CC_RADIANS_TO_DEGREES(res);
    if ( angle < 0 ) {
        angle = (360.0f + angle);
    }
    return angle;
}

@end