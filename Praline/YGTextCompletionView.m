//
//  YGTextCompletionView.m
//  Praline
//
//  Created by Yannick Heinrich on 03/02/2014.
//  Copyright (c) 2014 YaGeek. All rights reserved.
//

#import "YGTextCompletionView.h"

@implementation YGTextCompletionView

-(id) initWithFrame:(NSRect)frameRect
{
    if(self= [super initWithFrame:frameRect])
    {
        self.wantsLayer = YES;
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void) drawRect:(NSRect)dirtyRect
{
    [[NSColor redColor] setFill];
    
    NSRectFill(dirtyRect);
}
@end
