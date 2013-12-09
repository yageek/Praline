//
//  YGSourceCodeWindowController.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGSourceCodeWindowController.h"


@interface YGSourceCodeWindowController ()

@end

@implementation YGSourceCodeWindowController

- (id) init
{
    return [self initWithWindow:nil];
   
    
}
- (id)initWithWindow:(NSWindow *)window
{
    NSRect rect =NSMakeRect(0,0,500,500);
     NSWindow *textWindow = [[NSWindow alloc] initWithContentRect:rect styleMask:(NSTitledWindowMask |NSMiniaturizableWindowMask|NSResizableWindowMask | NSClosableWindowMask) backing:NSBackingStoreBuffered defer:YES];

    _editorView = [[YGSourceCodeEditorView alloc] initWithFrame:rect];
    [textWindow setContentView:_editorView];
    
    return [super initWithWindow:textWindow];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
