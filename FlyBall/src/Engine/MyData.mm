//
//  MyData.m
//  Expand_It
//
//  Created by Mac Mini on 10.05.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyData.h"


static NSDictionary * dictWithSaves;
static  NSString *saveDataGamePath;

@implementation MyData

static MyData *instance_;

static void MyData_remover() {
	[instance_ release];
}

+ (MyData*)instance {
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
	
	atexit(MyData_remover);
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

+(NSString*)getSaveDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    saveDataGamePath = [documentsDirectory stringByAppendingPathComponent:@"exsavedata.dat"];
    
    return saveDataGamePath;
}

+(NSString *)getStoreValue:(NSString *)key {
    return [[self getDictForSaveData] objectForKey:key];
}

+(void)setStoreValue:(NSString *)key 
               value:(NSString *)value {
    [[self getDictForSaveData] setValue:value forKey:key];
}

+(NSDictionary*)getDictForSaveData {
    if (dictWithSaves==NULL) {
        dictWithSaves = [[self decodeDict] retain];
    }
    
    return dictWithSaves;
}

+(void)encodeDict:(NSDictionary*)dict
{
    NSMutableData* gameData = [NSMutableData data];
    NSKeyedArchiver * encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
    
    [encoder encodeObject:dict forKey:@"expandItbestGameEver"]; //key - любое
    [encoder finishEncoding];
    [gameData writeToFile:[self getSaveDataPath] atomically:YES]; //saveDataGamePath - из предыдущего
    [encoder release];
}

+(NSDictionary*)decodeDict
{
    NSMutableData *gameData;
    NSKeyedUnarchiver *decoder;
    NSDictionary * dict;
    
    gameData = [NSData dataWithContentsOfFile:[self getSaveDataPath]];
    
	
	decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameData];
    dict = [decoder decodeObjectForKey:@"expandItbestGameEver"];
    [decoder release];
    
    return dict;
}

@end
