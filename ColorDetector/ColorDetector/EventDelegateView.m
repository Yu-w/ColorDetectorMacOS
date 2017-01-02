//
//  EventDelegateView.m
//  ColorDetector
//
//  Created by Wang Yu on 1/2/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

#import "EventDelegateView.h"

@implementation EventDelegateView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)keyDown:(NSEvent *)event {
    [self.delegate eventDelegateViewKeyDown:event];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
