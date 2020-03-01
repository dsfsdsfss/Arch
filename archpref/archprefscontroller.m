#include "archprefscontroller.h"
#import <SparkAppListTableViewController.h>
#import <LocalAuthentication/LocalAuthentication.h>

@implementation PFARootListController
-(void)verify {
	LAContext *context = [[LAContext alloc] init];  
	NSError *error = nil;  
	NSString *reason = @"Please authenticate.";
	if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
		   [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
		       localizedReason:reason
		           reply:^(BOOL success, NSError *error) {
		               if (!success) {
  							exit(0);
						}
					}];
		  	}
}
- (NSArray *)specifiers {
	[self verify];
		    if (!_specifiers) {
				_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
			}

			return _specifiers;


}
-(void)selectapps {

    // Replace "com.spark.notchlessprefs" and "excludedApps" with your strings
    SparkAppListTableViewController* s = [[SparkAppListTableViewController alloc] initWithIdentifier:@"com.machport.archprefs" andKey:@"blacklist"];

    [self.navigationController pushViewController:s animated:YES];
    self.navigationItem.hidesBackButton = FALSE;
}
@end
