//
//  YGSourceCodeEditorView.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGGutterView.h"
#import "YGTextView.h"
#import "YGSyntaxHighlighter.h"

extern NSString * const YGSourceCodeEditorViewBackgroundColor;
extern NSString * const YYGSourceCodeEditorViewStandartTextFontForegroundColor;
extern NSString * const YGSourceCodeEditorViewCommentTextFontForegroundColor;
extern NSString * const YGSourceCodeEditorViewFont;

@interface YGSourceCodeEditorView : NSView{

    YGTextView * _textView;
    NSScrollView * _textScrollView;
    YGGutterView * _gutterView;
    NSSplitView * _bottomSplitView;
    

}

- (id) initWithFrame:(NSRect) rect andProperties:(NSDictionary*) dict;

@property(copy,nonatomic) NSDictionary * attributes;
@property(strong,nonatomic) YGSyntaxHighlighter * syntaxHighlighter;


@end
