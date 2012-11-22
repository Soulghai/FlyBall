/*
 *  Defs2.h
 *  IncredibleBlox
 *
 *  Created by Mac Mini on 25.11.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

//#import "ParticlesEngine.h";
#import "cocos2d.h"
#import "ZFontManager.h"
#import "ActorManager.h"
#import "GUIPanel.h"

@interface Defs : NSObject {	

}

//@property (nonatomic, retain) ParticlesEngine *particles;
@property (nonatomic, retain) ActorManager* actorManager;
@property (nonatomic, retain) ZFontManager *myFont;
@property (nonatomic, retain) CCSpriteBatchNode *spriteSheetChars;
@property (nonatomic, retain) CCSpriteBatchNode *spriteSheetCells;
//@property (nonatomic, retain) CCNode *objectBackLayer;
@property (nonatomic, retain) CCNode *objectFrontLayer;
@property (nonatomic, readwrite) BOOL isSoundMute;
@property (nonatomic, readwrite) BOOL isMusicMute;

@property (nonatomic, readwrite) BOOL startGameNotFirstTime;

@property (nonatomic, readwrite) BOOL iPad;
@property (nonatomic, readwrite) BOOL screenHD;
@property (nonatomic, readwrite) BOOL iPhone5;
@property (nonatomic, retain) NSString *currentLanguage;

@property (nonatomic, readwrite) int currentMusicTheme;

@property (nonatomic, readwrite) unsigned int totalTouchBloxCounter;
@property (nonatomic, readwrite) unsigned int totalDeadBloxCounter;
@property (nonatomic, readwrite) unsigned int totalBombCounter;
@property (nonatomic, readwrite) BOOL isPlayGameBefore;

@property (nonatomic, retain) GUIPanel *closeAnimationPanel;
@property (nonatomic, readwrite) unsigned int afterCloseAnimationScreenType;
@property (nonatomic, readwrite) BOOL isCloseScreenAnimation;
@property (nonatomic, readwrite) BOOL isOpenScreenAnimation;

@property (nonatomic, readwrite) BOOL achievement_Rookie;
@property (nonatomic, readwrite) BOOL achievement_Newbie;
@property (nonatomic, readwrite) BOOL achievement_Apprentice;
@property (nonatomic, readwrite) BOOL achievement_Intermediate;
@property (nonatomic, readwrite) BOOL achievement_GiveMeMore;
@property (nonatomic, readwrite) BOOL achievement_SearchingForStars;
@property (nonatomic, readwrite) BOOL achievement_Stargazer;
@property (nonatomic, readwrite) BOOL achievement_StarsInTheSky;
@property (nonatomic, readwrite) BOOL achievement_Expand_10;
@property (nonatomic, readwrite) BOOL achievement_Expand_100;
@property (nonatomic, readwrite) BOOL achievement_Expand_1000;
@property (nonatomic, readwrite) BOOL achievement_Expand_2500;
@property (nonatomic, readwrite) BOOL achievement_Lost_100;
@property (nonatomic, readwrite) BOOL achievement_Bomb_1;
@property (nonatomic, readwrite) BOOL achievement_Bomb_10;
@property (nonatomic, readwrite) BOOL achievement_Bomb_100;
@property (nonatomic, readwrite) BOOL achievement_Highscore_1_11;
@property (nonatomic, readwrite) BOOL achievement_Highscore_1_14;
@property (nonatomic, readwrite) BOOL achievement_Highscore_2_8;
@property (nonatomic, readwrite) BOOL achievement_Highscore_2_11;
@property (nonatomic, readwrite) BOOL achievement_Highscore_3_3;
@property (nonatomic, readwrite) BOOL achievement_Highscore_3_12;
@property (nonatomic, readwrite) BOOL achievement_Highscore_4_2;
@property (nonatomic, readwrite) BOOL achievement_Highscore_4_13;
@property (nonatomic, readwrite) BOOL achievement_Highscore_5_5;
@property (nonatomic, readwrite) BOOL achievement_Highscore_5_10;

@property (nonatomic, assign) int rateMeWindowShowValue;
@property (nonatomic, readwrite) int coinsCount;
@property (nonatomic, readwrite) int bestScore;

// Прокачиваемые параметры
@property (nonatomic, readwrite) float bonusAccelerationValue;
@property (nonatomic, readwrite) float bonusAccelerationDelay;
@property (nonatomic, readwrite) float bonusGetChance;
@property (nonatomic, readwrite) float bonusGodModeTime;
@property (nonatomic, readwrite) float gravitation;
@property (nonatomic, readwrite) float speedWallAccelerationCoeff;
@property (nonatomic, readwrite) float speedWallDeccelerationCoeff;
@property (nonatomic, readwrite) float speedWallDelayShowingCoeff;
@property (nonatomic, readwrite) float playerMagnetDistance;
@property (nonatomic, readwrite) float playerMagnetPower;
@property (nonatomic, readwrite) float playerGodModeAfterCrashTime;

+(Defs*) instance;

- (void)dealloc;

@end

@interface CCAnimation(Helper)
+(CCAnimation*) animationWithFile:(NSString*)_name
					  _frameCount:(unsigned int)_frameCount
						   _delay:(float)_delay;
+(CCAnimation*) animationWithCachedFrames:(NSString*)_name
							  _frameCount:(unsigned int)_frameCount
								   _delay:(float)_delay;
@end