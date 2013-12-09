//
//  YGGutterView.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGutterView.h"

@implementation YGGutterView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.textAttributes = @{
                                NSFontAttributeName: [NSFont userFixedPitchFontOfSize:10.5],
                                NSForegroundColorAttributeName : [NSColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0]
                                };
        
    }
    return self;
}
- (BOOL) isFlipped
{
    return YES;
}
- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithRed:0.24 green:0.25 blue:0.29 alpha:1.0] setFill];
    NSRectFill(dirtyRect);
    
    NSInteger totalLines = self.lineFragmentRectsArray.count;
    NSUInteger index;
    for(index = 0; index < totalLines; ++index)
    {
        @autoreleasepool
        {
            NSRect lineRect = [self.lineFragmentRectsArray[index] rectValue];
            NSString * numberString = [@(index+1) stringValue];
            NSAttributedString * __autoreleasing string = [[NSAttributedString alloc] initWithString:numberString attributes:self.textAttributes];
            
            CGFloat originX = self.frame.size.width - string.size.width - 5;
            
            CGFloat delta = ABS(string.size.height-lineRect.size.height);
            
            CGFloat originY = lineRect.origin.y - delta/2 ;
            [string drawAtPoint:NSMakePoint(originX, originY)];
        }
        
        
    }
}

@end
