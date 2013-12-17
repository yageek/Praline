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
@interface YGSourceCodeEditorView : NSView{
    YGTextView * _textView;
    NSScrollView * _textScrollView;
    YGGutterView * _gutterView;
    
    NSSplitView * _bottomSplitView;
}

@property(readonly,nonatomic) NSTextView *textView;

@end
