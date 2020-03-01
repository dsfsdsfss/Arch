#define ding @"/Library/ApplicationSupport/ding.mp3"
#import "SparkAppList.h"

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>

#import <LocalAuthentication/LocalAuthentication.h>
#import <AVFoundation/AVFoundation.h>
#include <string.h>
#include <dlfcn.h>
AVAudioPlayer *player;
@interface SBAppSwitcherPageContentView : UIView
@end
@interface SBAppSwitcherPageView : UIView
@property (nonatomic, strong, readwrite) SBAppSwitcherPageContentView *view;
@end
@interface SBDisplayItem : NSObject
@property (retain, nonatomic, readwrite) NSString *bundleIdentifier;
@end
@interface SBAppLayout : NSObject
@property (retain, nonatomic, readwrite) NSDictionary* rolesToLayoutItemsMap;
@end
@interface SBAppSwitcherReusableSnapshotView : UIView
@property (retain, nonatomic) SBAppLayout* appLayout;
@end
@interface SBReusableSnapshotItemContainer : UIView
@property (retain, nonatomic) SBAppLayout* snapshotAppLayout;
@end
@interface CCUILabeledRoundButton
@property (nonatomic, copy, readwrite) NSString *title;
@end
@interface SBWiFiManager
-(id)sharedInstance;
-(void)setWiFiEnabled:(BOOL)enabled;
-(bool)wiFiEnabled;
@end

@interface BluetoothManager
-(id)sharedInstance;
-(void)setEnabled:(BOOL)enabled;
-(bool)enabled;

-(void)setPowered:(BOOL)powered;
-(bool)powered;

@end

NSString *swipeAppId;
%hook SBAppSwitcherReusableSnapshotView
- (void)layoutSubviews {
	%orig;
	self.hidden = 0;
	NSArray *values = [self.appLayout.rolesToLayoutItemsMap allValues];
	NSString *bundleID = [[values objectAtIndex:0] bundleIdentifier];
	if ([SparkAppList doesIdentifier:@"com.machport.archprefs" andKey:@"blacklist" containBundleIdentifier:bundleID]) {
		self.hidden = 1;
	}
}
%end
/*
%hook SBReusableSnapshotItemContainer
-(void)layoutSubviews {
	%orig;
	[self setUserInteractionEnabled: YES];
	NSArray *values = [self.snapshotAppLayout.rolesToLayoutItemsMap allValues];
	NSString *bundleID = [[values objectAtIndex:0] bundleIdentifier];
	swipeAppId = bundleID;
	if ([SparkAppList doesIdentifier:@"com.machport.archprefs" andKey:@"blacklist" containBundleIdentifier:bundleID]) {
		[self setUserInteractionEnabled: NO];
	}
}
%end
*/
%hook SBUIController
-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
	SBApplication* app = arg1;
	NSString *bundleID = [app bundleIdentifier];
	if ([SparkAppList doesIdentifier:@"com.machport.archprefs" andKey:@"blacklist" containBundleIdentifier:bundleID]) {
		LAContext *context = [[LAContext alloc] init];  
		NSError *error = nil;  
		NSString *reason = @"Please authenticate.";
		if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
		   [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
		       localizedReason:reason
		           reply:^(BOOL success, NSError *error) {
		           dispatch_async(dispatch_get_main_queue(), ^{
		               if (success) {
		               		NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.machport.archprefs"];
		               		id dingenabled = [bundleDefaults valueForKey:@"dingenabled"];
		               		if (![dingenabled isEqual:@0]) {
		               			player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:@"/Library/Application Support/Arch/ding.caf"] error:nil];
		               			[player play];
		               		}
		                   return %orig();
		               }
		           });
		    }];
		} 
		else {  
		   NSLog(@"Can not evaluate Touch ID");
		}
	} else {
		return %orig();
	}
}
%end

%hook SBAppSwitcherPageView
-(void)layoutSubviews {
	%orig;
	UITapGestureRecognizer *swipeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
	[self addGestureRecognizer:swipeGesture];

}
%new
-(void)swipeDown{
SBAppSwitcherReusableSnapshotView *CView = (SBAppSwitcherReusableSnapshotView*)self.view;
NSArray *values = [CView.appLayout.rolesToLayoutItemsMap allValues];
	NSString *bundleID = [[values objectAtIndex:0] bundleIdentifier];
	if ([SparkAppList doesIdentifier:@"com.machport.archprefs" andKey:@"blacklist" containBundleIdentifier:bundleID]) {
		LAContext *context = [[LAContext alloc] init];  
		NSError *error = nil;  
		NSString *reason = @"Please authenticate.";
		if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
		   [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
		       localizedReason:reason
		           reply:^(BOOL success, NSError *error) {
		           dispatch_async(dispatch_get_main_queue(), ^{
		               if (!success) {
		               		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" 
                                                    message:@"Authentication failed. Respringing in 3 seconds..." 
                                                    delegate:self 
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
							[alert show];
							[self performSelector:@selector(respring) withObject:nil afterDelay:3];
		               } else {
		              		 NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.machport.archprefs"];
		               		id dingenabled = [bundleDefaults valueForKey:@"dingenabled"];
		               		if (![dingenabled isEqual:@0]) {
		               			player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:@"/Library/Application Support/Arch/ding.caf"] error:nil];
		               			[player play];
		               		}
		               }
		           });
		    }];
		}
	}
}
%new
-(void)respring {
	system("killall backboardd");
}
%end
