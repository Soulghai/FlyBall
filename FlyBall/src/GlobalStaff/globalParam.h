//
//  globalParam.h
//  Beltality
//
//  Created by Mac Mini on 01.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

extern int SCREEN_WIDTH;
extern int SCREEN_HEIGHT;
extern int SCREEN_WIDTH_HALF;
extern int SCREEN_HEIGHT_HALF;
extern int const FRAME_RATE;

//-------GUI--------------
extern float BUTTON_DOWN_WAIT;
//------------------------

extern BOOL GAME_OVER;
extern float GAME_TIME;
extern BOOL GAME_STARTED;
extern BOOL GAME_IS_PLAYING;
extern BOOL GAME_EASTER;

extern int GAME_SCORE;

extern int GLOBAL_LAYER_ACTIVEOBJECT_COUNTER;
extern int GLOBAL_LAYER_PASSIVEOBJECT_COUNTER;

#define GAME_VERSION 1.2f

#define GAME_RATE_URL @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=515220537&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
#define URL_GIFT_THIS_APP @"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=515220537&productType=C&pricingParameter=STDQ"
#define URL_FACEBOOK @"http://www.facebook.com/FDGEntertainment"
#define URL_TWITTER @"http://twitter.com/#!/FDG_Games"
#define URL_VIDEO @"http://www.youtube.com/FDGGames"

#define FRAME_RATE 60.f
#define TIME_STEP 1/FRAME_RATE

#define MTP_RATIO 30
#define PTM_RATIO 1/MTP_RATIO

#define GAME_STATE_NONE				0x00000000
#define GAME_STATE_ALWAYS			0xffffffff
#define GAME_STATE_MENU				0x00000001
#define GAME_STATE_GAME				0x00000002
#define GAME_STATE_LEVELSCREEN		0x00000004
#define GAME_STATE_CREDITS			0x00000008
#define GAME_STATE_HIGHSCORE		0x00000100
#define GAME_STATE_HELP				0x00000200
#define GAME_STATE_GAMEOVER			0x00000400
#define GAME_STATE_LEVELFINISH		0x00000800
#define GAME_STATE_GAMEFINISH		0x00010000
#define GAME_STATE_GAMEPREPARE		0x00020000
#define GAME_STATE_SHOWROOM			0x00040000
#define GAME_STATE_PACKAGESCREEN	0x00080000
#define GAME_STATE_MARKETSCREEN		0x01000000
#define GAME_STATE_GAMEPAUSE		0x02000000
#define GAME_STATE_STORYSCREEN      0x04000000
#define GAME_STATE_LOADINGSCREEN    0x08000000


#define GAME_STATE_MOREGAMES        0x00000300


#define BONUS_ARMOR 10
#define BONUS_ACCELERATION 15
#define BONUS_APOCALYPSE 20
#define BONUS_GODMODE 25

#define BONUS_ACCELERATION_DEFAULT 0.1f
#define BONUS_ACCELERATION_MAX 0.5f
#define BONUS_ACCELERATION_DELAY_DEFAULT 1
#define BONUS_ACCELERATION_DELAY_MAX 5

#define BONUS_GODMODE_TIME_DEFAULT 2
#define BONUS_GODMODE_TIME_MAX 4

#define BONUS_GET_CHANCE_DEFAULT 0.1f
#define BONUS_GET_CHANCE_MAX 0.3f

#define GRAVITATION_DEFAULT 0.07f
#define GRAVITATION_MIN 0.04f

#define SPEEDWALL_ACCELERATION_DEFAULT 0.15f
#define SPEEDWALL_ACCELERATION_MAX 0.75f
#define SPEEDWALL_DECCELERARION_DEFAULT -0.05f
#define SPEEDWALL_DECCELERARION_MIN -0.01f
#define SPEEDWALL_DELAYSHOWINGCOEFF_DEFAULT 1
#define SPEEDWALL_DELAYSHOWINGCOEFF_MAX 5

#define PLAYER_MAGNET_DISTANDE_DEFAULT 88  //прибавляется по 88 за апдейт. Всего три апдейта
#define PLAYER_MAGNET_DISTANDE_MAX 264
#define PLAYER_MAGNET_POWER_DEFAULT 1
#define PLAYER_MAGNET_POWER_MAX 8

#define BONUS_GODMODE_AFTERCRASH_TIME_DEFAULT 0.5f
#define BONUS_GODMODE_AFTERCRASH_TIME_MAX 3.0f


//----------------------------------------------------------------
// GAMEPLAY CONST
//----------------------------------------------------------------

#define elementSize 45
#define elementRadius 22.5f
#define elementDensity 1

#define eraserDensity 0.7f
#define woodDensity 0.7f

#define ZCOORD_OBJECTS 100

#define Z_EFFECT 500
#define Z_GUI 5000

//static public var ropeStartDistance:Number = 1;

//LevelPacks
#define LEVELPACK_ISLAND 1
#define LEVELPACK_VOLCANO 2
#define LEVELPACK_ICE 3
#define LEVELPACK_CAVE 4
#define LEVELPACK_BOMB 5

// Rate me popup:
#define NOTIFICATION_RATEME_FONT_SIZE_IPAD 15
#define NOTIFICATION_RATEME_FONT_SIZE_IPHONE 14

#define NOTIFICATION_RATEME_FONT_SIZE_MOD_DE 0.9f
#define NOTIFICATION_RATEME_FONT_SIZE_MOD_ES 0.7f
#define NOTIFICATION_RATEME_FONT_SIZE_MOD_RU 0.8f
#define NOTIFICATION_RATEME_FONT_SIZE_MOD_PT 0.8f
#define NOTIFICATION_RATEME_FONT_SIZE_MOD_IT 0.9f
#define NOTIFICATION_RATEME_FONT_SIZE_MOD_FR 0.9f

#define NOTIFICATION_IAPBUY_FONT_SIZE_MOD_DE 1.0f
#define NOTIFICATION_IAPBUY_FONT_SIZE_MOD_ES 1.0f
#define NOTIFICATION_IAPBUY_FONT_SIZE_MOD_RU 1.0f
#define NOTIFICATION_IAPBUY_FONT_SIZE_MOD_PT 1.0f
#define NOTIFICATION_IAPBUY_FONT_SIZE_MOD_IT 1.0f
#define NOTIFICATION_IAPBUY_FONT_SIZE_MOD_FR 1.0f

#define NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_DE 1.0f
#define NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_ES 1.0f
#define NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_RU 0.9f
#define NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_PT 1.0f
#define NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_IT 1.0f
#define NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_FR 0.9f

#define NOTIFICATION_UI_ALERT_VISIBLE @"UIAlertViewShown"
#define NOTIFICATION_UI_ALERT_HIDDEN @"UIAlertViewHidden"

#define NOTIFICATION_RATEME_ID 1
#define NOTIFICATION_IAPBUY_ID 2
#define NOTIFICATION_IAPBUYMENU_ID 3