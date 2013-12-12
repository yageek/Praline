//
//  YGSourceCodeWindowController.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YGSourceCodeEditorView.h"

@interface YGSourceCodeWindowController : NSWindowController{
    YGSourceCodeEditorView * _editorView;
}

-(id) init;

@property(readonly,nonatomic) YGSourceCodeEditorView * editorView;
@end
