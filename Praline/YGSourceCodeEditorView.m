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

#import<CocoaLumberjack/DDLog.h>

#define GUTTER_VIEW_WIDTH 30

static int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface YGSourceCodeEditorView ()<NSTextStorageDelegate>

+ (NSOperationQueue *) globalEditingQueue;

@end

@implementation YGSourceCodeEditorView

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


    _textView = [[YGTextView alloc] initWithFrame:frame];
    _textView.textStorage.delegate = self;

    [_textScrollView setDocumentView:_textView];
    
    
    
     _gutterView = [[YGGutterView alloc] initWithFrame:frame andScrollView:_textScrollView];
    
    [self addSubview:_gutterView];
    [self addSubview:_textScrollView];
    
    [self initConstraints];
    
    [self registerNotifications];
}


- (void) initConstraints
{
    [_gutterView makeConstraints:^(MASConstraintMaker * make){
        make.width.equalTo(@(GUTTER_VIEW_WIDTH));
        make.height.equalTo(self.height);
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
                        
    }];
    
    [_textScrollView makeConstraints:^(MASConstraintMaker * make){
        make.left.equalTo(_gutterView.right);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
    }];
    

}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self createViewWithMainFrame:self.frame];
    }
    return self;
}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        [self createViewWithMainFrame:frame];
        
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
