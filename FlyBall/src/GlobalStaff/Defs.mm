#import "Defs.h"

@implementation Defs

//@synthesize particles;
@synthesize actorManager = _actorManager;
@synthesize myFont;
@synthesize spriteSheetChars;
@synthesize spriteSheetCells;
//@synthesize objectBackLayer;
@synthesize objectFrontLayer;
@synthesize isSoundMute;
@synthesize isMusicMute;
@synthesize startGameNotFirstTime;
@synthesize iPad;
@synthesize iPhone5;
@synthesize screenHD;
@synthesize currentLanguage;
@synthesize currentMusicTheme;
@synthesize totalTouchBloxCounter;
@synthesize totalDeadBloxCounter;
@synthesize totalBombCounter;
@synthesize closeAnimationPanel;
@synthesize afterCloseAnimationScreenType;
@synthesize isCloseScreenAnimation;
@synthesize isOpenScreenAnimation;

@synthesize isPlayGameBefore;

@synthesize achievement_Rookie;
@synthesize achievement_Newbie;
@synthesize achievement_Apprentice;
@synthesize achievement_Intermediate;
@synthesize achievement_GiveMeMore;
@synthesize achievement_SearchingForStars;
@synthesize achievement_Stargazer;
@synthesize achievement_StarsInTheSky;
@synthesize achievement_Expand_10;
@synthesize achievement_Expand_100;
@synthesize achievement_Expand_1000;
@synthesize achievement_Expand_2500;
@synthesize achievement_Lost_100;
@synthesize achievement_Bomb_1;
@synthesize achievement_Bomb_10;
@synthesize achievement_Bomb_100;
@synthesize achievement_Highscore_1_11;
@synthesize achievement_Highscore_1_14;
@synthesize achievement_Highscore_2_8;
@synthesize achievement_Highscore_2_11;
@synthesize achievement_Highscore_3_3;
@synthesize achievement_Highscore_3_12;
@synthesize achievement_Highscore_4_2;
@synthesize achievement_Highscore_4_13;
@synthesize achievement_Highscore_5_5;
@synthesize achievement_Highscore_5_10;

@synthesize bonusAccelerationValue;
@synthesize bonusGetChance;
@synthesize bonusGodModeTime;
@synthesize gravitation;
@synthesize speedWallAccelerationCoeff;
@synthesize speedWallDeccelerationCoeff;
@synthesize speedWallDelayShowingCoeff;
@synthesize playerMagnetDistance;
@synthesize playerMagnetPower;


static Defs *instance_;

static void instance_remover() {
	[instance_ release];
}

+ (Defs*)instance {
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

- (void)dealloc {
	[super dealloc];
}

@end

@implementation CCAnimation (Helper)

+(CCAnimation*) animationWithFile:(NSString*)_name
					  _frameCount:(unsigned int)_frameCount
						   _delay:(float)_delay {
	
	NSMutableArray *_frames = [NSMutableArray arrayWithCapacity:_frameCount];
	
	for(unsigned int i = 1; i <= _frameCount; i++) {
		NSString *_file = [NSString stringWithFormat:@"%@%i.png",_name,i];
		
		CCTexture2D *_tex = [[CCTextureCache sharedTextureCache] addImage:_file];
		 
		CGSize _texSize = [_tex contentSize];
		
		[_frames addObject:[CCSpriteFrame frameWithTexture:_tex rect:CGRectMake(0, 0, _texSize.width, _texSize.height)]];
	}  
	
	return [CCAnimation animationWithSpriteFrames:_frames delay:_delay];
}

+(CCAnimation*) animationWithCachedFrames:(NSString*)_name
					  _frameCount:(unsigned int)_frameCount
						   _delay:(float)_delay {
	
	NSMutableArray *_frames = [NSMutableArray arrayWithCapacity:_frameCount];
	
	for(unsigned int i = 1; i <= _frameCount; i++) {
		NSString *_file = [NSString stringWithFormat:@"%@%i.png",_name,i];
		[_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_file]];
	}
	
	return [CCAnimation animationWithSpriteFrames:_frames delay:_delay];
}

@end