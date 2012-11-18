//
//  Utils.h
//  Beltality
//
//  Created by Mac Mini on 02.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

@interface Utils : NSObject {

}

+(Utils*) instance;
- (id) init;
- (float) distance:(float)_x1
			   _y1:(float)_y1
			   _x2:(float)_x2
			   _y2:(float)_y2;
- (float) myRandomF;
- (float) myRandom2F;
- (float) aspire:(float)_start 
			_aim:(float)_aim
		  _speed:(float)_speed;
- (int) timeToNormalTime:(int)_time
					  day:(BOOL)day
					 hour:(BOOL)hour
				   minute:(BOOL)minute
				   second:(BOOL)second;
-(int) getOpr:(CGPoint)P1 P2:(CGPoint)P2 P3:(CGPoint)P3;
-(int) calcSofPolygon:(NSArray*)_Shape;
+ (float) GetAngleBetweenPt1:(CGPoint) pt1 andPt2:(CGPoint) pt2;

@end
