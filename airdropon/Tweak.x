
#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h> 

/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/


%hook SDStatusMonitor

// -(BOOL)  _isEveryoneModeExpired {
// 	BOOL exprired = %orig();
// 	NSLog(@"leotag _isEveryoneModeExpired should be executed!!! ,expire : %d", exprired);
// 	return exprired;
// }

// hook此方法可以解除airdrop对所有人10分钟的限制，使airdop对所有人开启
-(id)  _expireEveryoneModeAndOnlySetDefault:(int) mode {
	NSLog(@"leotag _expireEveryoneModeAndOnlySetDefault should be executed!!!, default mode : %d, hook to 1", mode);
	return %orig(1);
}

// -(id) setDiscoverableMode:(int) mode {
// 	NSLog(@"leotag setDiscoverableMode should be executed!!!, mode : %d", mode);
// 	return %orig(mode);
// }

// -(NSTimeInterval) _currentEveryoneModeExpiryInterval {
// 	NSTimeInterval ExpiryInterval = %orig();
// 	NSLog(@"leotag _currentEveryoneModeExpiryInterval should be executed!!!, ExpiryInterval : %f", ExpiryInterval);
// 	return ExpiryInterval;
// }

// -(NSTimeInterval) _everyoneModeExpiryInterval {
// 	NSTimeInterval ExpiryInterval = %orig();
// 	NSLog(@"leotag _everyoneModeExpiryInterval should be executed!!!, ExpiryInterval : %f", ExpiryInterval);
// 	return ExpiryInterval;
// }

// hook此方法可以定时关airdrop
// -(id) _everyoneModeExpiryDate {
// 	id expireDate = %orig();
// 	// 1 分钟后关闭
// 	NSDate *newExpireDate = [NSDate dateWithTimeIntervalSinceNow: 60];

// 	NSLog(@"leotag _everyoneModeExpiryDate should be executed!!!, expireDate : %@ changed to %@", expireDate, newExpireDate);
// 	return newExpireDate;
// }

%end

// %hook SDAirDropServer

// -(BOOL) thisIsTheFinder {
// 	NSLog(@"leotag thisIsTheFinder this should be executed!!!");
// 	return %orig;
// }

// %end

// %ctor 
// {
// 	NSLog(@"leotag loaded4!!!");
// }



