//
//  ViewController.m
//  ColorDetector
//
//  Created by Wang Yu on 12/13/16.
//  Copyright © 2016 Yu Wang. All rights reserved.
//

#import "ViewController.h"
#import "ColorNamer.h"
#include <Carbon/Carbon.h>

#define VIEW_WIDTH 160

@implementation ViewController
{
    BOOL isDisplayHex;
    BOOL shouldFollow;
    NSString *currentHexString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isDisplayHex = NO;
    shouldFollow = YES;
    [self roundConrerLabel];
    [self.baseView setDelegate:self];
    ColorNamer *colorNamer = [ColorNamer new];
    CGSize screenSize = [[NSScreen mainScreen] frame].size;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        for (;;) {
            NSPoint mouseLoc = [NSEvent mouseLocation];
            
            uint32_t count = 0;
            CGDirectDisplayID displayForPoint;
            if (CGGetDisplaysWithPoint(NSPointToCGPoint(mouseLoc), 1, &displayForPoint, &count) != kCGErrorSuccess)
                continue;
            
            CGFloat amplifiedWidth = VIEW_WIDTH / 5;
            CGImageRef image = CGDisplayCreateImageForRect(displayForPoint, CGRectMake(mouseLoc.x - amplifiedWidth / 2 - 1, screenSize.height - mouseLoc.y - amplifiedWidth / 2 - 2, amplifiedWidth, amplifiedWidth));
            if (!image) continue;
            NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
            CGImageRelease(image);
            NSColor* color;
            if (screenSize.width == 1440) {
                color = [bitmap colorAtX:amplifiedWidth y:amplifiedWidth];
            } else {
                color = [bitmap colorAtX:amplifiedWidth / 2 y:amplifiedWidth / 2];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString* hexString = [NSString stringWithFormat:@"%02X%02X%02X",
                                       (int) (color.redComponent * 0xFF),
                                       (int) (color.greenComponent * 0xFF),
                                       (int) (color.blueComponent * 0xFF)];
                NSString* rgbString = [NSString stringWithFormat:@"%d %d %d",
                                       (int)(255 * color.redComponent),
                                       (int)(255 * color.greenComponent),
                                       (int)(255 * color.blueComponent)];
                currentHexString = [NSString stringWithFormat:@"#%@", hexString];
                NSImage *image = [[NSImage alloc] initWithCGImage:[bitmap CGImage] size:NSMakeSize(VIEW_WIDTH,VIEW_WIDTH)];
                [self.imageView setImage:image];
                NSPoint point = NSMakePoint(mouseLoc.x - VIEW_WIDTH / 2, mouseLoc.y + 12);
                if (mouseLoc.y >= screenSize.height - VIEW_WIDTH - 54) {
                    point.y = mouseLoc.y - 54 - VIEW_WIDTH;
                }
                NSString *displayString;
                NSString *colorName = [colorNamer findNameForColor:color];
                if (colorName != nil) {
                    displayString = isDisplayHex
                    ? [NSString stringWithFormat:@"  %@: #%@  ", colorName, hexString]
                    : [NSString stringWithFormat:@"  %@: %@  ", colorName, rgbString];
                } else {
                    displayString = isDisplayHex
                    ? [[@"  #" stringByAppendingString:hexString] stringByAppendingString:@"  "]
                    : [[@"  " stringByAppendingString:rgbString] stringByAppendingString:@"  "];
                }
                [self.label setStringValue:displayString];
                if (shouldFollow)
                    [[NSApp mainWindow] setFrameOrigin:point];
                [[NSApp mainWindow] setLevel:NSFloatingWindowLevel];
            });
        }
    });
}

- (void)eventDelegateViewKeyDown:(NSEvent *)event {
    switch ([event keyCode])
    {
        case kVK_ANSI_S:
            isDisplayHex = !isDisplayHex;
            break;
        case kVK_ANSI_C:
            [[NSPasteboard generalPasteboard] clearContents];
            [[NSPasteboard generalPasteboard] setString:currentHexString forType:NSPasteboardTypeString];
            break;
        case kVK_ANSI_F:
            shouldFollow = !shouldFollow;
            break;
        default:
            break;
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)roundConrerLabel {
    [self.label setTextColor:[NSColor whiteColor]];
    [self.label setWantsLayer:YES];
    [self.label setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [self.label.layer setCornerRadius:9];
    [self.label.layer setMasksToBounds:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
