//
//  ColorNamer.m
//  ColorDetector
//
//  Created by Wang Yu on 1/2/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

#import "ColorNamer.h"
#import "RGBHSL.h"
#import "ColorNameLib.h"

#define RGBA(r,g,b,a) [NSColor colorWithCalibratedRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f]

#define NSColorFromRGB(rgbValue) [NSColor colorWithCalibratedRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ColorNamer
{
    NSDictionary<NSString *, NSString *> *colorDictionary;
    NSMutableDictionary<NSString *, NSArray<NSNumber *> *> *colorAttributes;
}

- (NSString *)findNameForColor:(NSColor *)color {
    return [self algorithm:color];
}

- (NSString *)findNameForColorHexString:(NSString *)colorHex {
    return  [self algorithm:[ColorNamer colorFromHexString:colorHex]];
}

- (NSString *)algorithm:(NSColor *)color {
    float r = color.redComponent * 255.0f;
    float g = color.greenComponent * 255.0f;
    float b = color.blueComponent * 255.0f;
    float h, s, l;
    RGB2HSL(r, g, b, &h, &s, &l);
    
    float ndf1 = 0;
    float ndf2 = 0;
    float ndf = 0;
    NSString *cl = nil;
    float df = -1;
    
    for (NSString *key in colorDictionary) {
        if ([[ColorNamer hexStringFromColor:color] isEqualToString:key])
            return colorDictionary[key];
        ndf1 = powf(r - colorAttributes[key][0].floatValue, 2)
             + powf(g - colorAttributes[key][1].floatValue, 2)
             + powf(b - colorAttributes[key][2].floatValue, 2);
        ndf2 = powf(h - colorAttributes[key][3].floatValue, 2)
             + powf(s - colorAttributes[key][4].floatValue, 2)
             + powf(l - colorAttributes[key][5].floatValue, 2);
        ndf = ndf1 + ndf2 * 2;
        if (df < 0 || df > ndf) {
            df = ndf;
            cl = key;
        }
    }
    return colorDictionary[cl];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        colorDictionary = ColorNames();
        colorAttributes = [NSMutableDictionary<NSString *, NSArray<NSNumber *> *> new];
        for (NSString *key in colorDictionary) {
            NSColor *color = [ColorNamer colorFromHexString:key];
            float r = color.redComponent * 255.0f;
            float g = color.greenComponent * 255.0f;
            float b = color.blueComponent * 255.0f;
            float h, s, l;
            RGB2HSL(r, g, b, &h, &s, &l);
            NSArray *arr = @[[NSNumber numberWithFloat:r],
                             [NSNumber numberWithFloat:g],
                             [NSNumber numberWithFloat:b],
                             [NSNumber numberWithFloat:h],
                             [NSNumber numberWithFloat:s],
                             [NSNumber numberWithFloat:l]];
            [colorAttributes setValue:arr forKey:key];
        }
    }
    return self;
}

+ (NSColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [NSColor colorWithCalibratedRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSString *)hexStringFromColor:(NSColor *)color {
    NSString* hexString = [NSString stringWithFormat:@"%02X%02X%02X",
                           (int) (color.redComponent * 0xFF), (int) (color.greenComponent * 0xFF),
                           (int) (color.blueComponent * 0xFF)];
    return hexString;
}

@end
