/* ScummVM - Graphic Adventure Engine
 *
 * ScummVM is the legal property of its developers, whose names
 * are too numerous to list here. Please refer to the COPYRIGHT
 * file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 */

#define FORBIDDEN_SYMBOL_ALLOW_ALL
#include "backends/platform/tvos/tvos_app_delegate.h"
#include "backends/platform/tvos/tvos_video.h"
#include "ScummVM_tvOS-Swift.h"


@interface AppleTVAppDelegate () <Protocol_tvosscummvmviewcontroller> {
	
}
@end

@implementation AppleTVAppDelegate {
	UIWindow *_window;
	tvOSScummVMViewController *_controller;
	AppleTVView *_view;
}

- (id)init {
	if (self = [super init]) {
		_window = nil;
		_view = nil;
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	CGRect rect = [[UIScreen mainScreen] bounds];

	NSLog(@"tvOS - applicationDidFinishLaunching, rect: %@", NSStringFromCGRect(rect));

#ifdef IPHONE_SANDBOXED
	// Create the directory for savegames
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *documentPath = [NSString stringWithUTF8String:iOS7_getDocumentsDir()];
	NSString *savePath = [documentPath stringByAppendingPathComponent:@"Savegames"];
	NSLog(@"savePath: %@", savePath);
	if (![fm fileExistsAtPath:savePath]) {
		[fm createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
#endif

	_window = [[UIWindow alloc] initWithFrame:rect];
	[_window retain];

	_controller = [[tvOSScummVMViewController alloc] initWithDelegate:self];

	_view = [[AppleTVView alloc] initWithFrame:rect];
	_controller.view = _view;

	[_window setRootViewController:_controller];
	[_window makeKeyAndVisible];

	//[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(didRotate:)
	                                             name:@"UIDeviceOrientationDidChangeNotification"
	                                           object:nil];

	// Force creation of the shared instance on the main thread
	iOS7_buildSharedOSystemInstance();

	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		iOS7_main(iOS7_argc, iOS7_argv);
	});
	
	
#ifdef IPHONE_SANDBOXED
	// Just testing...
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* defkey = @"testkey";
	NSString* thevalue = [defaults objectForKey:defkey];
	if (thevalue != nil) {
		NSLog(@"defaults: stored value: %@", thevalue);
	}
	else {
		NSDate* date = [NSDate new];
		NSString* newvalue = date.description;
		NSLog(@"defaults: no value! Store: %@", newvalue);
		[defaults setObject:newvalue forKey:defkey];
		[date release];
	}
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[_view applicationSuspend];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[_view applicationResume];
}

- (void)didRotate:(NSNotification *)notification {
	/*
	UIDeviceOrientation screenOrientation = [[UIDevice currentDevice] orientation];
	[_view deviceOrientationChanged:screenOrientation];
	*/
}

+ (AppleTVAppDelegate *)AppleTVAppDelegate {
	UIApplication *app = [UIApplication sharedApplication];
	return (AppleTVAppDelegate *) app.delegate;
}

+ (AppleTVView *)appleTVView {
	AppleTVAppDelegate *appDelegate = [self AppleTVAppDelegate];
	return appDelegate->_view;
}

- (void)pressWithButton:(enum Button)button {
	switch (button) {
		case ButtonPrimary:
			[_view pressPrimary];
			break;
		case ButtonSecondary:
			[_view pressSecondary];
			break;
	}
}

@end

const char *iOS7_getDocumentsDir() {
	NSString* dir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"rootgamescumm"];
	return [dir UTF8String];
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	return [documentsDirectory UTF8String];
}
