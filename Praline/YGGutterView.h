//
//  YGGutterView.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface YGGutterLine : NSObject
{
@public
    NSRect lineRect;
    NSInteger number;

}

@end

@interface YGGutterView : NSView
{
    CGFloat rowHeight;
    CGFloat lineSpacing;
    NSUInteger _linesCount;
    

}

- (id) initWithFrame:(NSRect) frame andScrollView:(NSScrollView*) textview;

@property(copy,nonatomic) NSDictionary * textAttributes;
@property(assign,nonatomic) NSScrollView * textScrollView;
@property (readonly) NSUInteger linesCount;
@end
