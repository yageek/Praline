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

@implementation YGGutterLine

- (NSString*) description
{
    return [NSString stringWithFormat:@"Line : %li - {x:%f y:%f w:%f h:%f}",self->number,self->lineRect.origin.x,self->lineRect.origin.y,self->lineRect.size.width,self->lineRect.size.height];
}

@end

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
    @autoreleasepool
    {
        
        [[NSColor colorWithRed:0.24 green:0.25 blue:0.29 alpha:1.0] setFill];
        NSRectFill(dirtyRect);
        CGFloat scrollY = [_textScrollView.contentView documentVisibleRect].origin.y;
        
        NSArray * lines = [self getLines];
        
        for(YGGutterLine * line in lines)
        {
            if(NSIntersectsRect(line->lineRect, _textScrollView.documentVisibleRect))
            {
                
                NSString * label;
                if(line->number < 0)
                {
                    label =@".";
                }
                else
                {
                    label = [NSString stringWithFormat:@"%li",line->number];
                }
                
                line->lineRect.origin.y -= scrollY;
                
                 NSAttributedString * __autoreleasing string = [[NSAttributedString alloc] initWithString:label attributes:self.textAttributes];
                 [string drawInRect:line->lineRect];
                
            }
        }
    }
    
}

- (NSArray *) getLines
{
    NSMutableArray * linesArray = [NSMutableArray array];
    NSTextView * textView = _textScrollView.documentView;
    NSLayoutManager * manager = textView.layoutManager;
    NSString * code = textView.string;

    CGFloat rowHeight = [manager defaultLineHeightForFont:self.textAttributes[NSFontAttributeName]];
    CGFloat lineSpacing = [[textView defaultParagraphStyle] lineSpacing];
    CGFloat centeringYOffset = -1*(rowHeight - [self.textAttributes[NSFontAttributeName] pointSize]);
                                             
    if(code.length == 0)
    {
        YGGutterLine * line = [[YGGutterLine alloc] init];
        line->lineRect = NSMakeRect(0, centeringYOffset, self.bounds.size.width, [manager defaultLineHeightForFont:self.textAttributes[NSFontAttributeName]] + lineSpacing  );
        line->number = 1;
    
        [linesArray addObject:line];
        return  [linesArray copy];
    }
    
    
    NSInteger index, numberofLines, totalGlyphs = [manager numberOfGlyphs];
    NSRange loopRange;
    
    YGGutterLineMode currentMode, previousMode =YGGutterLineModeNewLine;
    
    for(numberofLines = 0, index = 0; index < totalGlyphs;numberofLines++)
    {
        NSRect lineRect = [manager lineFragmentRectForGlyphAtIndex:index effectiveRange:&loopRange];
        NSString * line = [code substringWithRange:loopRange];
        
        lineRect.origin.y += centeringYOffset;
        
        YGGutterLine * gtLine = [[YGGutterLine alloc] init];
        gtLine->lineRect = lineRect;
        
        if([line rangeOfString:@"\n"].location == NSNotFound)
        {
            currentMode = YGGutterLineModeWrapping;
        }
        else
        {
            currentMode = YGGutterLineModeNewLine;
        }
        
        if((previousMode == YGGutterLineModeNewLine && currentMode == YGGutterLineModeWrapping) || (previousMode == YGGutterLineModeNewLine && currentMode == YGGutterLineModeNewLine))
        {
            gtLine->number = numberofLines +1;
        }
        else if((previousMode == YGGutterLineModeWrapping && currentMode == YGGutterLineModeNewLine) || (previousMode == YGGutterLineModeWrapping && currentMode == YGGutterLineModeWrapping))
        {
            gtLine->number = -1;
        }
        
        [linesArray addObject:gtLine];
        previousMode = currentMode;
        index = NSMaxRange(loopRange);
    }
    
    NSString *lastCharacter = [code substringFromIndex:code.length-1];
    if([lastCharacter isEqualToString:@"\n"])
    {
        YGGutterLine * line = [[YGGutterLine alloc] init];
        YGGutterLine * previousLine = linesArray[numberofLines-1];
        
        CGFloat y = previousLine->lineRect.origin.y + rowHeight + lineSpacing + 0.5*centeringYOffset;
        
        line->lineRect = NSMakeRect(0, y, self.bounds.size.width, rowHeight + lineSpacing);
        line->number = numberofLines+1;
        
       [linesArray addObject:line];
        return  [linesArray copy];
    }
    
    
    
    
    return [linesArray copy];
}

@end
