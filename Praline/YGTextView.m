//
//  YGTextView.m
//  Praline
//
//  Created by Yannick Heinrich on 17/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGTextView.h"
#import "YGTextCompletionView.h"
@implementation YGTextView
{
    NSDictionary * _textAttributes;
    NSPoint _cursorPoint;
    NSScrollView *_scrollView;
}


- (id) initWithFrame:(NSRect)frameRect andScrollView:(NSScrollView *)scrollView
{
    if(self = [super initWithFrame:frameRect])
    {
        self.autoresizingMask = NSViewWidthSizable;
        self.backgroundColor = [NSColor colorWithRed:0.16 green:0.17 blue:0.21 alpha:1.0];
        self.textColor = [NSColor whiteColor];
        [self setRichText:NO];
        [self setInsertionPointColor:[NSColor whiteColor]];
        
        NSFont * defaultFont =[NSFont fontWithName:@"Menlo Regular" size:13.];
        [self setFont:defaultFont];
        _scrollView = scrollView;
    }
    return self;
    
}

- (BOOL) isFlipped
{
    return YES;
}
/*
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    
    NSLayoutManager * manager = [self layoutManager];
    CGFloat rowHeight = [manager defaultLineHeightForFont:[self font]];

    [[NSColor greenColor] setStroke];
    
    NSInteger i;
    for(i = 0; i <1000; ++i)
    {
        NSBezierPath * path = [NSBezierPath bezierPath];
        
        CGFloat y = i*rowHeight;
        [path moveToPoint:NSMakePoint(0, y)];
        [path lineToPoint:NSMakePoint(100, y)];
        
        [path stroke];

    }

}
*/

- (void) complete:(id)sender
{

    NSLayoutManager * manager = self.layoutManager;
    _cursorPoint = [manager boundingRectForGlyphRange:self.selectedRange inTextContainer:self.textContainer].origin;
    _cursorPoint.y += [self.font pointSize] + 5;
//    [self showCompleteViewAtPoint:_cursorPoint];
   
    

}

- (void)showCompleteViewAtPoint:(NSPoint) point
{
    
    YGTextCompletionView* completeView = [[YGTextCompletionView alloc] initWithFrame:NSMakeRect(point.x, point.y, 100, 100)];
       [self addSubview:completeView];
}
@end
