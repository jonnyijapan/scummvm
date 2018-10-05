//
//  tvos_common.h
//  ScummVM-tvOS
//
//  Created by Jonny Bergstrom on 2018/10/04.
//

#pragma once

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, AppleTVRemoteButton) {
	primary,
	secondary,
	menu,
};
typedef NS_ENUM(NSInteger, AppleTVRemoteAction) {
	buttonDown,
	buttonUp,
	buttonCancel,
};
