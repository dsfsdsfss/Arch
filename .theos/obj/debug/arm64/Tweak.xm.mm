#line 1 "Tweak.xm"
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBAppSwitcherReusableSnapshotView; @class SBAppSwitcherPageView; @class SBUIController; 
static void (*_logos_orig$_ungrouped$SBAppSwitcherReusableSnapshotView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherReusableSnapshotView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBAppSwitcherReusableSnapshotView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherReusableSnapshotView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$)(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST, SEL, id, id, long long, id, id); static void _logos_method$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST, SEL, id, id, long long, id, id); static void (*_logos_orig$_ungrouped$SBAppSwitcherPageView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBAppSwitcherPageView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBAppSwitcherPageView$swipeDown(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBAppSwitcherPageView$respring(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST, SEL); 

#line 49 "Tweak.xm"
NSString *swipeAppId;

static void _logos_method$_ungrouped$SBAppSwitcherReusableSnapshotView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherReusableSnapshotView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$SBAppSwitcherReusableSnapshotView$layoutSubviews(self, _cmd);
	self.hidden = 0;
	NSArray *values = [self.appLayout.rolesToLayoutItemsMap allValues];
	NSString *bundleID = [[values objectAtIndex:0] bundleIdentifier];
	if ([SparkAppList doesIdentifier:@"com.machport.archprefs" andKey:@"blacklist" containBundleIdentifier:bundleID]) {
		self.hidden = 1;
	}
}
















static void _logos_method$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2, long long arg3, id arg4, id arg5) {
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
		                   return _logos_orig$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$(self, _cmd, arg1, arg2, arg3, arg4, arg5);
		               }
		           });
		    }];
		} 
		else {  
		   NSLog(@"Can not evaluate Touch ID");
		}
	} else {
		return _logos_orig$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$(self, _cmd, arg1, arg2, arg3, arg4, arg5);
	}
}



static void _logos_method$_ungrouped$SBAppSwitcherPageView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$SBAppSwitcherPageView$layoutSubviews(self, _cmd);
	UITapGestureRecognizer *swipeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
	[self addGestureRecognizer:swipeGesture];

}

static void _logos_method$_ungrouped$SBAppSwitcherPageView$swipeDown(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
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

static void _logos_method$_ungrouped$SBAppSwitcherPageView$respring(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherPageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	system("killall backboardd");
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBAppSwitcherReusableSnapshotView = objc_getClass("SBAppSwitcherReusableSnapshotView"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSwitcherReusableSnapshotView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBAppSwitcherReusableSnapshotView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBAppSwitcherReusableSnapshotView$layoutSubviews);Class _logos_class$_ungrouped$SBUIController = objc_getClass("SBUIController"); MSHookMessageEx(_logos_class$_ungrouped$SBUIController, @selector(activateApplication:fromIcon:location:activationSettings:actions:), (IMP)&_logos_method$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$, (IMP*)&_logos_orig$_ungrouped$SBUIController$activateApplication$fromIcon$location$activationSettings$actions$);Class _logos_class$_ungrouped$SBAppSwitcherPageView = objc_getClass("SBAppSwitcherPageView"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSwitcherPageView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBAppSwitcherPageView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBAppSwitcherPageView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBAppSwitcherPageView, @selector(swipeDown), (IMP)&_logos_method$_ungrouped$SBAppSwitcherPageView$swipeDown, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBAppSwitcherPageView, @selector(respring), (IMP)&_logos_method$_ungrouped$SBAppSwitcherPageView$respring, _typeEncoding); }} }
#line 156 "Tweak.xm"
