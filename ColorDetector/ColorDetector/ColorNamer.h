//
//  ColorNamer.h
//  ColorDetector
//
//  Created by Wang Yu on 1/2/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorNamer : NSObject

- (NSString *)findNameForColor:(NSColor *)color;

- (NSString *)findNameForColorHexString:(NSString *)colorHexString;

@end
