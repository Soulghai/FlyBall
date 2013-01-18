//
//  GameStandartFunctions.mm
//  Expand_It
//
//  Created by Mac Mini on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameStandartFunctions.h"
#import "SimpleAudioEngine.h"
#import	"Defs.h"
#import "MainScene.h"
#import "GameKit/GameKit.h"
#import "globalParam.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"
#import "MyData.h"

@implementation GameStandartFunctions

static GameStandartFunctions *instance_;

static void GameStandartFunctions_remover() {
	[instance_ release];
}

+ (GameStandartFunctions*)instance {
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
	
	atexit(GameStandartFunctions_remover);
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void) checkBoxEnableSoundAction {
	[Defs instance].isSoundMute = ![Defs instance].isSoundMute;
	//[[Defs instance].userSettings setBool: forKey:@"isSoundMute"];
    [MyData setStoreValue:@"isSoundMute" value:[NSString stringWithFormat:@"%i",[Defs instance].isSoundMute]];
    //CCLOG(@"[Defs instance].isSoundMute = @"@",[NSString stringWithFormat:@"%i",[Defs instance].isSoundMute]);
	//[[SimpleAudioEngine sharedEngine] setMute:[Defs instance].isSoundMute];
	
	/*if ((![Defs instance].isSoundMute)&&(![Defs instance].isMusicMute))
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
    else
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];*/
    [FlurryAnalytics logEvent:ANALYTICS_BUTTON_SOUND_ON_OFF_CLICKED];
}

- (void) checkBoxEnableMusicAction {
	[Defs instance].isMusicMute = ![Defs instance].isMusicMute;
	//[[Defs instance].userSettings setBool:[Defs instance].isMusicMute forKey:@"isMusicMute"];
    [MyData setStoreValue:@"isMusicMute" value:[NSString stringWithFormat:@"%i",[Defs instance].isMusicMute]];
	
	if (![Defs instance].isMusicMute)
		[self playCurrentBackgroundMusicTrack];
    else
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [FlurryAnalytics logEvent:ANALYTICS_BUTTON_SOUND_ON_OFF_CLICKED];
}

- (void) playCurrentBackgroundMusicTrack{
    if (![Defs instance].isMusicMute) {
        if ([Defs instance].currentMusicTheme == 0) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme_menu.mp3"];
        } else
        if ([Defs instance].currentMusicTheme == 1) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme_game_1.mp3"];
        } else
            if ([Defs instance].currentMusicTheme == 2) {
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"expand_it_volcano_v2.mp3"];
            } else
                if ([Defs instance].currentMusicTheme == 3) {
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"expand_it_ice_age_v2.mp3"];
                }else
                    if ([Defs instance].currentMusicTheme == 4) {
                        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"expand_it_caves_v2.mp3"];
                    }else
                        if ([Defs instance].currentMusicTheme == 5) {
                            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme_menu.mp3"];
                        }
    }
}

- (void) goToUrl:(NSString*)_url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
}

- (NSString*) pasteDot:(NSString*)_string {
    if ([_string length] < 4) return _string;
    
    NSMutableString* _newString = [NSMutableString stringWithCapacity:[_string length] + (int)round([_string length]/3 - 1)];
    int i = 1;
    int j = 3 - (int)([_string length] %3);
    
    if (j == 3) {
        [_newString stringByAppendingFormat:@"%c",[_string characterAtIndex:0]];
        j = 1;
        i = 2;
    }
    while (i <= [_string length]) {
        if (j == 3)
        {
           [_newString stringByAppendingFormat:@"%@",@"."];
            j = 0;
        }
        [_newString stringByAppendingFormat:@"%c",[_string characterAtIndex:i-1]];
        ++i;
        ++j;
    }
    return _newString;
}

-(float) getFontModifierForCurrentLanguageForAlertWithID:(int)alertID {
	NSString *langID = [Defs instance].currentLanguage;
	CCLOG(@"Current locale is: %@", langID);
    
	switch (alertID) {
		case NOTIFICATION_RATEME_ID:
			if ([langID isEqualToString:@"de"]) {
				return NOTIFICATION_RATEME_FONT_SIZE_MOD_DE;
			} else if ([langID isEqualToString:@"ru"]) {
				return NOTIFICATION_RATEME_FONT_SIZE_MOD_RU;
			} else if ([langID isEqualToString:@"es"]) {
				return NOTIFICATION_RATEME_FONT_SIZE_MOD_ES;
			} else if ([langID isEqualToString:@"pt"] || [langID isEqualToString:@"pt-PT"]) {
				return NOTIFICATION_RATEME_FONT_SIZE_MOD_PT;
			} else if ([langID isEqualToString:@"it"]) {
				return NOTIFICATION_RATEME_FONT_SIZE_MOD_IT;
			} else if ([langID isEqualToString:@"fr"]) {
				return NOTIFICATION_RATEME_FONT_SIZE_MOD_FR;
			}
			break;
            
		case NOTIFICATION_IAPBUY_ID:
			if ([langID isEqualToString:@"de"]) {
				return NOTIFICATION_IAPBUY_FONT_SIZE_MOD_DE;
			} else if ([langID isEqualToString:@"ru"]) {
				return NOTIFICATION_IAPBUY_FONT_SIZE_MOD_RU;
			} else if ([langID isEqualToString:@"es"]) {
				return NOTIFICATION_IAPBUY_FONT_SIZE_MOD_ES;
			} else if ([langID isEqualToString:@"pt"] || [langID isEqualToString:@"pt-PT"]) {
				return NOTIFICATION_IAPBUY_FONT_SIZE_MOD_PT;
			} else if ([langID isEqualToString:@"it"]) {
				return NOTIFICATION_IAPBUY_FONT_SIZE_MOD_IT;
			} else if ([langID isEqualToString:@"fr"]) {
				return NOTIFICATION_IAPBUY_FONT_SIZE_MOD_FR;
			}
			break;
            
		case NOTIFICATION_IAPBUYMENU_ID:
			if ([langID isEqualToString:@"de"]) {
				return NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_DE;
			} else if ([langID isEqualToString:@"ru"]) {
				return NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_RU;
			} else if ([langID isEqualToString:@"es"]) {
				return NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_ES;
			} else if ([langID isEqualToString:@"pt"] || [langID isEqualToString:@"pt-PT"]) {
				return NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_PT;
			} else if ([langID isEqualToString:@"it"]) {
				return NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_IT;
			} else if ([langID isEqualToString:@"fr"]) {
				return NOTIFICATION_IAPBUYMENU_FONT_SIZE_MOD_FR;
			}
			break;
            
		default:
			break;
	}
    
	return 1.0f;
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
	for (NSObject *subview in [alertView subviews]) {
        if ([subview isKindOfClass:[UILabel class]]) {
			if (iPad)
				((UILabel*)subview).font = [UIFont systemFontOfSize:NOTIFICATION_RATEME_FONT_SIZE_IPAD * [self getFontModifierForCurrentLanguageForAlertWithID:NOTIFICATION_RATEME_ID]];
			else
				((UILabel*)subview).font = [UIFont systemFontOfSize:NOTIFICATION_RATEME_FONT_SIZE_IPHONE * [self getFontModifierForCurrentLanguageForAlertWithID:NOTIFICATION_RATEME_ID]];
            
			if ([[[UIDevice currentDevice] systemVersion] intValue] <= 3)
				((UILabel*)subview).center = CGPointMake(((UILabel*)subview).center.x, ((UILabel*)subview).center.y - 25.0f);
        }
    }
    
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_ALERT_VISIBLE object:nil];
}

-(void) showRateAlert {
 //if ([[Defs instance].userSettings boolForKey:@"rateThisBefore"] != YES){
 
    UIAlertView *warn = [[UIAlertView alloc] initWithTitle:nil  message:NSLocalizedString(@"Please Rate 5 Stars","")  delegate: self 
    cancelButtonTitle:NSLocalizedString(@"Don't Ask Again","") 
    otherButtonTitles: NSLocalizedString(@"Yes Rate It",""), NSLocalizedString(@"Remind Me Later",""), nil];
    [self willPresentAlertView:warn];
    //((UILabel*)[[warn subviews] objectAtIndex:0]).font = [UIFont systemFontOfSize:10];
    //((UILabel*)[[warn subviews] objectAtIndex:0]).textAlignment = UITextAlignmentLeft;
    [warn show];
    [warn release];

    [FlurryAnalytics logEvent:ANALYTICS_SOCIAL_RATE_APP_POPUP];
    //}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
    if (buttonIndex==0)
    {
        //[[Defs instance].userSettings setBool:YES forKey:@"rateThisBefore"];
        [MyData setStoreValue:@"rateThisBefore" value:@"YES"];
    }
    
    if (buttonIndex==1)
    {
        //[[Defs instance].userSettings setBool:YES forKey:@"rateThisBefore"];
        [MyData setStoreValue:@"rateThisBefore" value:@"YES"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GAME_RATE_URL]];
        
#if MACROS_LITE_VERSION
        if ([Defs instance].liteVersionRateGame == 0) {
            [Defs instance].liteVersionLevelsCountAvailable += 2;
            [MyData setStoreValue:@"liteVersionLevelsCountAvailable" value:[NSString stringWithFormat:@"%d",[Defs instance].liteVersionLevelsCountAvailable]];
            [Defs instance].liteVersionRateGame = 1;
            [MyData setStoreValue:@"liteVersionRateGame" value:@"1"];
       }
#endif
    }
}

- (void) playCloseScreenAnimation:(unsigned int)_nextScreenType {
    if ([Defs instance].isCloseScreenAnimation) return;
    
    [[Defs instance].closeAnimationPanel.spr setOpacity:0];
    [[Defs instance].closeAnimationPanel show:YES];
    [Defs instance].afterCloseAnimationScreenType = _nextScreenType;
    
    [Defs instance].isOpenScreenAnimation = NO;
    [Defs instance].isCloseScreenAnimation = YES;
}

- (void) playOpenScreenAnimation {
    [Defs instance].isCloseScreenAnimation = NO;
    [Defs instance].isOpenScreenAnimation = YES;
    [[Defs instance].closeAnimationPanel.spr setOpacity:255];
    [[Defs instance].closeAnimationPanel show:YES];
}

- (void) hideScreenAnimation {
    [Defs instance].isCloseScreenAnimation = NO;
    [Defs instance].isOpenScreenAnimation = NO;
    [[Defs instance].closeAnimationPanel.spr setOpacity:0];
    [[Defs instance].closeAnimationPanel show:NO];
}

@end
