//
//  YGSourceCodeEditorView+TextViewBlocks.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGSourceCodeEditorView+TextViewBlocks.h"
#import <CocoaLumberjack/DDLog.h>

static int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation YGSourceCodeEditorView (TextViewBlocks)

- (void) updateLineNumbers
{
    static NSMutableArray * tempArray = nil;
    if(!tempArray)
    {
        DDLogVerbose(@"First time, initializing rects array");
        tempArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    NSLayoutManager * lytManager = _textView.layoutManager;
    NSRect boundingRect = _textScrollView.contentView.documentVisibleRect;
    
    CGFloat scrollY = boundingRect.origin.y;
    NSRange glyphVisible = [lytManager glyphRangeForBoundingRect:boundingRect inTextContainer:_textView.textContainer];

    NSInteger numberOfLines, index;
    NSRange lineRange;
    for (numberOfLines = 0, index = glyphVisible.location; index < NSMaxRange(glyphVisible); numberOfLines++)
    {

        NSRect rect =  [lytManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange withoutAdditionalLayout:YES];
        rect.origin.y -= scrollY;
        NSValue * value = [NSValue valueWithRect:rect];
        [tempArray addObject:value];
        
        index = NSMaxRange(lineRange);
    }
    NSRect firstLine = [[tempArray firstObject] rectValue];
    DDLogVerbose(@"First Line NSrect : x:%f y:%f witdh:%f height:%f",firstLine.origin.x,firstLine.origin.y,firstLine.size.width, firstLine.size.height);
    _gutterView.lineFragmentRectsArray = [tempArray copy];
   [_gutterView setNeedsDisplay:YES];
   

    
    [tempArray removeAllObjects];
}
@end


