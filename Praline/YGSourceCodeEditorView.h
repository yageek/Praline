//
//  YGSourceCodeEditorView.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGGutterView.h"

@interface YGSourceCodeEditorView : NSView{
    NSTextView * _textView;
    NSScrollView * _textScrollView;
    YGGutterView * _gutterView;
    
    
}

@end
