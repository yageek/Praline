//
//  YGSourceCodeWindowController.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGSourceCodeWindowController.h"


@interface YGSourceCodeWindowController () <NSTextViewDelegate>{
    unsigned nextInsertionIndex;
    NSTimer *completionTimer;
}

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
    _editorView.textView.delegate = self;

     highlighter= [[YGSyntaxHighlighter alloc] initWithTextView:_editorView.textView];
    [textWindow setContentView:_editorView];
    
    return [super initWithWindow:textWindow];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Autocompletion
- (void)doCompletion:(NSTimer *)timer {
    [self stopCompletionTimer];
    [_editorView.textView complete:nil];
}

- (void)startCompletionTimer {
    [self stopCompletionTimer];
    completionTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(doCompletion:) userInfo:nil repeats:NO] ;
}

- (void)stopCompletionTimer {
    [completionTimer invalidate];
    completionTimer = nil;
}

- (BOOL) textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    if (NSOrderedSame == [@"c" compare:replacementString
                               options:NSCaseInsensitiveSearch]) {
        [self startCompletionTimer];
        nextInsertionIndex = affectedCharRange.location +
        [replacementString length];
    } else {
        [self stopCompletionTimer];
        nextInsertionIndex = NSNotFound;
    }
    return YES;
}

- (NSRange)textView:(NSTextView *)textView
willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange
   toCharacterRange:(NSRange)newSelectedCharRange {
    /* Stop the timer on selection changes other than those caused
     by the typing that started the timer. */
    if (newSelectedCharRange.length > 0 ||
        newSelectedCharRange.location != nextInsertionIndex) [self
                                                              stopCompletionTimer];
    
    
    [highlighter highlight];
    return newSelectedCharRange;
}

- (NSArray *)textView:(NSTextView *)textView completions:(NSArray *)
words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger*)index {
    /* Complete "Mac" to "Macintosh", "Mac OS", or "Mac OS X". */
    NSArray *result = nil;
    NSString *string = [[textView string]
                        substringWithRange:charRange];
    if (NSOrderedSame == [@"Mac" compare:string
                                 options:NSCaseInsensitiveSearch]) {
        result = [NSArray arrayWithObjects:@"Macintosh", @"Mac OS",
                  @"Mac OS X", nil];
    }
    return result;
}
@end
