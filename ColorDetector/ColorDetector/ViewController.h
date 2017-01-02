//
//  ViewController.h
//  ColorDetector
//
//  Created by Wang Yu on 12/13/16.
//  Copyright © 2016 Yu Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EventDelegateView.h"

@interface ViewController : NSViewController 
<EventDelegateViewDelegate>

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *label;
@property (strong) IBOutlet EventDelegateView *baseView;

@end

