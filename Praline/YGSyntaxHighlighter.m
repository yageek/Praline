//
//  YGSyntaxHighlighter.m
//  Praline
//
//  Created by Yannick Heinrich on 03/02/2014.
//  Copyright (c) 2014 YaGeek. All rights reserved.
//

#import "YGSyntaxHighlighter.h"
#import <ParseKit/ParseKit.h>

@interface YGSyntaxHighlighter(){
    NSTextView *  _textView;
}

@end

@implementation YGSyntaxHighlighter

- (id) initWithTextView:(NSTextView*) textView
{
    
    if(self = [super init])
    {
        _textView = textView;
    }
    return self;
}

- (void) highlight
{
    NSString * code = [_textView string];
    
    PKTokenizer * t = [PKTokenizer tokenizerWithString:code];
    t.commentState.reportsCommentTokens = YES;
    PKToken *eof = [PKToken EOFToken];
    PKToken *tok = nil;
    
    while ((tok = [t nextToken]) != eof) {
       switch(tok.tokenType)
        {
            case PKTokenTypeComment:
            {
                NSRange range = NSMakeRange(tok.offset, tok.stringValue.length);
                
                [_textView.textStorage addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:range];
            }
                
                break;
            default:
                break;
        }
    
    }
}

@end
