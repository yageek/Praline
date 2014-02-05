//
//  YGSourceCodeEditorView.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGSourceCodeEditorView.h"
#define MAS_SHORTHAND
#import <Masonry/Masonry.h>

#define GUTTER_VIEW_WIDTH 30

NSString * const YGSourceCodeEditorViewBackgroundColor = @"YGTextViewBackgroundColor";
NSString * const YGSourceCodeEditorViewStandartTextFontForegroundColor = @"YGTextViewStandartTextFontForegroundColor";
NSString * const YGSourceCodeEditorViewCommentTextFontForegroundColor = @"YGTextViewCommentTextFontForegroundColor";
NSString * const YGSourceCodeEditorViewFont = @"YGTextViewFont";



@interface YGSourceCodeEditorView ()<NSTextStorageDelegate>

+ (NSOperationQueue *) globalEditingQueue;

@end

@implementation YGSourceCodeEditorView

#pragma mark - Designated Initializers + dealloc

- (id) initWithFrame:(NSRect) rect andProperties:(NSDictionary*) dict
{

    if(self = [super initWithFrame:rect])
    {
        [self createViewWithMainFrame:rect];
        self.attributes = dict;

    }
    return self;
}
- (id)initWithFrame:(NSRect)frame
{
    return [self initWithFrame:frame andProperties:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Appearance
- (void) setAttributes:(NSDictionary *)attributes
{
    _attributes = [attributes copy];
    
    _textView.backgroundColor = attributes[YGSourceCodeEditorViewBackgroundColor] ?: [NSColor colorWithRed:0.16 green:0.17 blue:0.21 alpha:1.0];
    
    _textView.textColor = attributes[YGSourceCodeEditorViewStandartTextFontForegroundColor] ?: [NSColor whiteColor];
    _textView.insertionPointColor = _textView.textColor;
    
    _textView.font = attributes[YGSourceCodeEditorViewFont] ?: [NSFont fontWithName:@"Menlo Regular" size:13.];

    
}
#pragma mark - GCD initialization
+ (NSOperationQueue *) globalEditingQueue
{
    static NSOperationQueue * queue = nil;
    if(!queue)
    {
        
        queue = [[NSOperationQueue alloc] init];
        queue.name =@"net.yageek.Praline.editingqueue";
        
    }
    return queue;
}


#pragma mark - Subviews initialization

- (void) createViewWithMainFrame:(NSRect) frame
{
    
    _textScrollView = [[NSScrollView alloc] initWithFrame:frame];
    [_textScrollView setHasVerticalScroller:YES];
    
    
    _textView = [[YGTextView alloc] initWithFrame:frame andScrollView:_textScrollView];
    _textView.textStorage.delegate = self;
    
    [_textScrollView setDocumentView:_textView];
    
    _gutterView = [[YGGutterView alloc] initWithFrame:frame andScrollView:_textScrollView];
    
    [self addSubview:_gutterView];
    [self addSubview:_textScrollView];
    
    _bottomSplitView = [[NSSplitView alloc] initWithFrame:frame];
    [_bottomSplitView setVertical:NO];
    
    
    [self addSubview:_bottomSplitView];
    [self initConstraints];
    
    [self registerNotifications];
}


- (void) initConstraints
{
    [_gutterView makeConstraints:^(MASConstraintMaker * make){
        make.width.equalTo(@(GUTTER_VIEW_WIDTH));
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.bottom.equalTo(_bottomSplitView.top);
        
    }];
    
    [_textScrollView makeConstraints:^(MASConstraintMaker * make){
        make.left.equalTo(_gutterView.right);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(_bottomSplitView.top);
    }];
    
    [_bottomSplitView makeConstraints:^(MASConstraintMaker * make)
     {
         make.left.equalTo(self.left);
         make.right.equalTo(self.right);
         make.bottom.equalTo(self.bottom);
         make.height.equalTo(@20);
         make.top.equalTo(_textScrollView.bottom);
     }];
    
}

#pragma mark - Notifications
- (void) registerNotifications
{
    [_textScrollView.contentView setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateGutter) name:NSViewBoundsDidChangeNotification object:_textScrollView.contentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGutter)
                                                 name:NSWindowDidResizeNotification
                                               object:self.window];
    
}

#pragma mark - delegate


- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
    [self updateGutter];
    
//    [self.syntaxHighlighter highlightString:self.textView.textStorage];
}

- (void) updateGutter
{
    [_gutterView setNeedsDisplay:YES];
}
- (void) setText:(NSString*) text
{
    _textView.string = text;
}
- (void) setTextStorage:(NSTextStorage*) storage
{
    _textView.layoutManager.textStorage = storage;
}
@end
