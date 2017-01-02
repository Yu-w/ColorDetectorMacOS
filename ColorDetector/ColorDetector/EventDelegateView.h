//
//  EventDelegateView.h
//  ColorDetector
//
//  Created by Wang Yu on 1/2/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol EventDelegateViewDelegate <NSObject>

- (void)eventDelegateViewKeyDown:(NSEvent *)event;

@end

@interface EventDelegateView : NSView

@property (nonatomic, weak) id <EventDelegateViewDelegate> delegate;

@end
