//
//  MyData.h
//  Expand_It
//
//  Created by Mac Mini on 10.05.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyData : NSObject {

}

+(MyData*) instance;

- (id) init;
- (void) dealloc;

+(NSString*)getSaveDataPath;
+(NSString *)getStoreValue:(NSString *)key;
+(void)setStoreValue:(NSString *)key 
               value:(NSString *)value;
+(NSDictionary*)getDictForSaveData;
+(void)encodeDict:(NSDictionary*)dict;
+(NSDictionary*)decodeDict;


@end
