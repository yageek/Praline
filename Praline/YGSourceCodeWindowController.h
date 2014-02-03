//
//  YGSourceCodeWindowController.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGSourceCodeEditorView.h"
#import "YGSyntaxHighlighter.h"

@interface YGSourceCodeWindowController : NSWindowController{
    YGSourceCodeEditorView * _editorView;
   YGSyntaxHighlighter * highlighter;
}


@property(readonly,nonatomic) YGSourceCodeEditorView * editorView;
@end
