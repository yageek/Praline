//
//  YGGutterView.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGutterView.h"
#import <CocoaLumberjack/DDLog.h>

typedef NS_ENUM(NSInteger,YGGutterLineMode)
{
    YGGutterLineModeNewLine,
    YGGutterLineModeWrapping
};

static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation YGGutterView

- (id) initWithFrame:(NSRect) frame andScrollView:(NSScrollView*) scrollview
{
    
    if(![scrollview.documentView isKindOfClass:[NSTextView class]])
    {
        self = nil;
        DDLogError(@"Could not Initialize. The provided scrollView should have an NSTextView as document view.");
        return self;
    }
    if(self = [super initWithFrame:frame])
    {
       _textScrollView = scrollview;

        NSFont * font = [scrollview.documentView font];
       _textAttributes = [@{
                             NSFontAttributeName: font,
                             NSForegroundColorAttributeName : [NSColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0]
                             } copy];

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
    
    NSTextView * textView = _textScrollView.documentView;
    
    if(textView.string.length == 0) //Maintain first line if empty
    {
        DDLogVerbose(@"No text should maintain first line");
        
        NSAttributedString * __autoreleasing string = [[NSAttributedString alloc] initWithString:@"1" attributes:self.textAttributes];
        
        [string drawAtPoint:NSMakePoint(0, 0)];
        
        return;
    }
    
    NSString * code = textView.string;
    NSLayoutManager * lytManager = textView.layoutManager;
    
    NSRect boundingRect = _textScrollView.contentView.documentVisibleRect;
    CGFloat scrollY = boundingRect.origin.y;
    CGFloat maxY = -1;
    YGGutterLineMode previousMode = YGGutterLineModeNewLine;
    YGGutterLineMode currentMode;
    
    NSInteger index,numberoflines, numberOfGlyphs = [lytManager numberOfGlyphs];
    NSRange loopRange;
    for(numberoflines = 1, index =0 ; index < numberOfGlyphs;)
    {
        NSRect lineRect = [lytManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&loopRange withoutAdditionalLayout:YES];
        maxY = MAX(maxY,lineRect.origin.y);
        NSString * line = [code substringWithRange:loopRange];
        
        if([line rangeOfString:@"\n"].location == NSNotFound)
        {
            currentMode = YGGutterLineModeWrapping;
        }
        else
        {
            currentMode = YGGutterLineModeNewLine;
        }
        
        NSString * currentLine = nil;
        
        if((previousMode == YGGutterLineModeNewLine && currentMode == YGGutterLineModeWrapping) || (previousMode == YGGutterLineModeNewLine && currentMode == YGGutterLineModeNewLine))
        {
            currentLine = [NSString stringWithFormat:@"%lu", numberoflines];
            numberoflines++;
        }
        else if((previousMode == YGGutterLineModeWrapping && currentMode == YGGutterLineModeNewLine) || (previousMode == YGGutterLineModeWrapping && currentMode == YGGutterLineModeWrapping))
        {
            currentLine = @".";
        }
        
        previousMode = currentMode;
        
        //Draw
        NSRect documentRect = [_textScrollView documentVisibleRect];
        if(NSIntersectsRect(documentRect, lineRect))
        {
            NSAttributedString * __autoreleasing string = [[NSAttributedString alloc] initWithString:currentLine attributes:self.textAttributes];
            
            NSPoint originPoint = lineRect.origin;
            originPoint.y =NSMidY(lineRect) - string.size.height/2 - scrollY;
            
            [string drawAtPoint:originPoint];
            
        }
        
        index  = NSMaxRange(loopRange);
    }
    
    NSString *lastCharacter = [textView.string substringFromIndex:textView.string.length-1];
    if([lastCharacter isEqualToString:@"\n"])
    {
        DDLogVerbose(@"Should maintain last line");
        NSString * currentLine = [NSString stringWithFormat:@"%lu", numberoflines];
        
        NSAttributedString * __autoreleasing string = [[NSAttributedString alloc] initWithString:currentLine attributes:self.textAttributes];
        
        CGFloat lineHeight = [string size].height - 1; //Soustract -1 due to 0 origin
        NSPoint originPoint = NSMakePoint(0, maxY+lineHeight);
        originPoint.y -= scrollY;
        
        [string drawAtPoint:originPoint];
    }

}


@end
