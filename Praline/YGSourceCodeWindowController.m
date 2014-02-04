//
//  YGSourceCodeWindowController.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGSourceCodeWindowController.h"
#import "YGDocument.h"

@interface YGSourceCodeWindowController () <NSTextViewDelegate>{
    unsigned nextInsertionIndex;
    NSTimer *completionTimer;
}

@end

@implementation YGSourceCodeWindowController

- (id) init
{
    return [super initWithWindowNibName:@"cjzeofjze"];
}


- (void) loadWindow
{
    [self windowWillLoad];
    
    NSRect rect =NSMakeRect(0,0,500,500);
    NSWindow *textWindow = [[NSWindow alloc] initWithContentRect:rect styleMask:(NSTitledWindowMask |NSMiniaturizableWindowMask|NSResizableWindowMask | NSClosableWindowMask) backing:NSBackingStoreBuffered defer:YES];
    
    [self setWindow:textWindow];
    
    _editorView = [[YGSourceCodeEditorView alloc] initWithFrame:rect];
    _editorView.textView.delegate = self;

    
    [textWindow setContentView:_editorView];
    
    self.window = textWindow;
    
    [self windowDidLoad];
}

- (void) windowDidLoad
{
    YGDocument * doc = self.document;
    if(doc.isSyntaxHighlighted)
    {
        
        YGSyntaxHighlighter * highlighter = [[YGSyntaxHighlighter alloc] init];
        _editorView.syntaxHighlighter = highlighter;
    }
    
}

@end
