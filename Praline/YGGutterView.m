//
//  YGGutterView.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGGutterView.h"

#pragma mark - Preferences Keys
NSString *const YGGutterViewTextForegroundColor = @"YGGutterViewTextForegroundColor";
NSString *const YGGutterViewBackgroundColor =@"YGGutterViewBackgroundColor";
NSString *const YGGutterViewFont = @"YGGutterViewFont";



typedef NS_ENUM(NSInteger,YGGutterLineMode)
{
    YGGutterLineModeNewLine,
    YGGutterLineModeWrapping
};
#pragma mark - YGGutterLine Internal Object
@interface YGGutterLine : NSObject
{
@public
    NSRect lineRect;
    NSInteger number;
    
}

@end

@implementation YGGutterLine

- (NSString*) description
{
    return [NSString stringWithFormat:@"Line : %li - {x:%f y:%f w:%f h:%f}",self->number,self->lineRect.origin.x,self->lineRect.origin.y,self->lineRect.size.width,self->lineRect.size.height];
}

@end

#pragma mark - YGGutterView
@interface YGGutterView()

@property(assign,nonatomic) NSScrollView * textScrollView;

@end
@implementation YGGutterView

- (id) initWithFrame:(NSRect) frame andScrollView:(NSScrollView*) scrollview
{
    
    if(![scrollview.documentView isKindOfClass:[NSTextView class]])
    {
        self = nil;
        NSLog(@"Could not Initialize. The provided scrollView should have an NSTextView as document view.");
        return self;
    }
    if(self = [super initWithFrame:frame])
    {
       _textScrollView = scrollview;

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
        NSColor * backgroundColor = self.attributes[YGGutterViewBackgroundColor] ?:[NSColor colorWithRed:0.24 green:0.25 blue:0.29 alpha:1.0];
        [backgroundColor setFill];
        NSRectFill(dirtyRect);
        
        
        CGFloat scrollY = [self.textScrollView.contentView documentVisibleRect].origin.y;
        
        CGFloat pointSize = [self.textAttributes[NSFontAttributeName] pointSize];
        NSArray * lines = [self getLines];
        _linesCount = lines.count;
        for(YGGutterLine * line in lines)
        {
            NSRect lineRect = line->lineRect;
            if(NSIntersectsRect(lineRect, self.textScrollView.documentVisibleRect))
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
                
                lineRect.origin.y -= scrollY;
                
                NSAttributedString * __autoreleasing string = [[NSAttributedString alloc] initWithString:label attributes:self.textAttributes];
                
                lineRect.origin.y -= (string.size.height - pointSize)/2;

                 [string drawInRect:lineRect];
            }
        }
    }
    
}

- (NSDictionary*) textAttributes
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSCenterTextAlignment;
    dict[NSParagraphStyleAttributeName] = [paragraphStyle copy];
    
    if(!self.attributes)
    {

        dict[NSFontAttributeName] = [[self.textScrollView documentView] font];
        dict[NSForegroundColorAttributeName] = [[self.textScrollView documentView] textColor];

    }
    else
    {
        dict[NSFontAttributeName] = self.attributes[YGGutterViewFont];
        dict[NSForegroundColorAttributeName] = self.attributes[YGGutterViewTextForegroundColor];
    }

    return [dict copy];
}
- (NSArray *) getLines
{
    NSMutableArray * linesArray = [NSMutableArray array];
    NSTextView * textView = _textScrollView.documentView;
    NSLayoutManager * manager = textView.layoutManager;
    NSString * code = textView.string;


    rowHeight = [manager defaultLineHeightForFont:self.textAttributes[NSFontAttributeName]];
    lineSpacing = [[textView defaultParagraphStyle] lineSpacing];

    if(code.length == 0)
    {
        YGGutterLine * line = [[YGGutterLine alloc] init];
        line->lineRect = NSMakeRect(0, 0, self.bounds.size.width, rowHeight);
        line->number = 1;
    
        [linesArray addObject:line];
        return  [linesArray copy];
    }
    
    NSInteger index, numberofLines, totalGlyphs = [manager numberOfGlyphs];
    NSRange loopRange;
    NSInteger iter;
    
    YGGutterLineMode currentMode, previousMode =YGGutterLineModeNewLine;
    
    for(iter = 0, numberofLines = 0, index = 0; index < totalGlyphs; iter++)
    {
        [manager lineFragmentRectForGlyphAtIndex:index effectiveRange:&loopRange];
        NSString * line = [code substringWithRange:loopRange];
        
        YGGutterLine * gtLine = [[YGGutterLine alloc] init];
        gtLine->lineRect = NSMakeRect(0, iter*rowHeight, self.bounds.size.width, rowHeight);
        
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
            numberofLines++;
            gtLine->number = numberofLines;
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
        
        
        line->lineRect = NSMakeRect(0, iter*rowHeight, self.bounds.size.width, rowHeight);
        line->number = numberofLines+1;
        
       [linesArray addObject:line];
        return  [linesArray copy];
    }
    
    
    
    return [linesArray copy];
}

- (NSUInteger) linesCount
{
    return _linesCount;
}
@end
