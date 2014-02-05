//
//  YGGutterView.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const YGGutterViewTextForegroundColor;
extern NSString *const YGGutterViewBackgroundColor;
extern NSString *const YGGutterViewFont;

@interface YGGutterView : NSView
{
    CGFloat rowHeight;
    CGFloat lineSpacing;
    NSUInteger _linesCount;
    

}

- (id) initWithFrame:(NSRect) frame andScrollView:(NSScrollView*) textview;

@property (readonly) NSUInteger linesCount;
@property(copy,nonatomic) NSDictionary * attributes;

@end
