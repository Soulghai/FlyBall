//
//  AppDelegate.m
//  FlyBall
//
//  Created by Zakhar Gadzhiev on 14.11.12.
//  Copyright Zakhar Gadzhiev 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "globalParam.h"
#import "GameCenter.h"
#import "Defs.h"

@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskPortrait;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [IntroLayer scene]];
	}
}
@end


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Defs instance].iPad = NO;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [Defs instance].iPad = YES;
    }
#endif
    
    
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    //[[GameCenter instance] checkGameCenterAvailable];
    
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:TIME_STEP];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	[Defs instance].screenHD = YES;
	if( ! [director_ enableRetinaDisplay:YES] ) {
        [Defs instance].screenHD = NO;
		CCLOG(@"Retina Display Not supported");
    }
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
    [Defs instance].currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    CCLOG(@"Current Language = %@",[Defs instance].currentLanguage);
    
	// Assume that PVR images have premultiplied alpha
	//[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
    
    //[[GameCenter instance] authenticateLocalPlayer];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

#pragma mark -
#pragma mark Compose Mail
- (void)setUpMailAccount {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Error"
													message:@"Please setup a mail account first."
												   delegate:self
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet {
	if(![MFMailComposeViewController canSendMail]) {
		[self setUpMailAccount];
		return;
	}
    
    
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
    
    if (!emailController) {
        emailController = [[UIViewController alloc] init];
    }
    
    //[window_ addSubview: emailController.view];
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    //CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( 1.570796327 ); // 90 degrees in radian
    //[picker.view setTransform:landscapeTransform];
    //[emailController.view setTransform:landscapeTransform];
    
    //[[UIDevice currentDevice] orientation];
    
    [picker setSubject:@"Just discovered this great game!"];
    
    
    
    NSString *emailBody = @"<html><head></head><body bgcolor=\"#FFFFFF\"><br><table cellpadding=\"5\"><tbody><tr><td valign=\"top\"><h3><a href=\"%applink%\"><img src=\"%appicon%\" width=\"60\" height=\"60\"></a></h3></td><td valign=\"top\"><h3>%message%</h3></td></tr></tbody></table><br><a href=\"%applink%\"><img src=\"%screen01%\" width=\"240\" height=\"%screen_height%\"></a> <a href=\"%applink%\"><img src=\"%screen02%\" width=\"240\" height=\"%screen_height%\"></a> <a href=\"%applink%\"><img src=\"%screen03%\" width=\"240\" height=\"%screen_height%\"></a> <a href=\"%applink%\"><img src=\"%screen04%\" width=\"240\" height=\"%screen_height%\"></a> <a href=\"%applink%\"><img src=\"%screen05%\" width=\"240\" height=\"%screen_height%\"></a></body></html>";
	
	if ([Defs instance].iPad)
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%applink%" withString:NSLocalizedString(@"recommend_email_app_link_hd", @"")];
	else
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%applink%" withString:NSLocalizedString(@"recommend_email_app_link", @"")];
	
	if ([Defs instance].iPad)
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%appicon%" withString:NSLocalizedString(@"recommend_email_app_icon_hd", @"")];
	else
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%appicon%" withString:NSLocalizedString(@"recommend_email_app_icon", @"")];
	
	// Pic size for iPhone: 160, for iPad: 180
	if ([Defs instance].iPad)
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen_height%" withString:@"180"];
	else
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen_height%" withString:@"160"];
	
	NSString *messageText = @"";
	if ([Defs instance].iPad)
		messageText = [NSString stringWithFormat:NSLocalizedString(@"recommend_email_message_text", @""), NSLocalizedString(@"recommend_email_app_link_hd", @""), NSLocalizedString(@"recommend_email_app_title_hd", @""), [Defs instance].bestScore];
	else
		messageText = [NSString stringWithFormat:NSLocalizedString(@"recommend_email_message_text", @""), NSLocalizedString(@"recommend_email_app_link", @""), NSLocalizedString(@"recommend_email_app_title", @""),  [Defs instance].bestScore];
	
	emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%message%" withString:messageText];
	
	if ([Defs instance].iPad) {
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen01%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_01_hd", @"")];
		
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen02%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_02_hd", @"")];
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen03%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_03_hd", @"")];
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen04%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_04_hd", @"")];
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen05%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_05_hd", @"")];
	} else {
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen01%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_01", @"")];
		
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen02%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_02", @"")];
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen03%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_03", @"")];
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen04%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_04", @"")];
		emailBody = [emailBody stringByReplacingOccurrencesOfString:@"%screen05%"
														 withString:NSLocalizedString(@"recommend_email_app_screenshot_05", @"")];
        
    }
    
    [picker setMessageBody:emailBody isHTML:YES];
    
	[navController_ presentModalViewController:picker animated:YES];
    [picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[navController_ dismissModalViewControllerAnimated:YES];
    //[emailController.view removeFromSuperview];
    
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}

-(void)sendEmail
{
	NSLog(@"pop-up email here");
	[self displayComposerSheet];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}
@end
