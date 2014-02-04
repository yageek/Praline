//
//  YGSyntaxHighlighter.m
//  Praline
//
//  Created by Yannick Heinrich on 03/02/2014.
//  Copyright (c) 2014 YaGeek. All rights reserved.
//

#import "YGSyntaxHighlighter.h"
#import <ParseKit/ParseKit.h>
@implementation YGSYntaxHighlighterElement
@end

@interface YGSyntaxHighlighter(){}

@end

@implementation YGSyntaxHighlighter


- (void) highlightString:(NSMutableAttributedString*) attrString;
{
    for(YGSYntaxHighlighterElement * element in elements)
    {
        [attrString removeAttribute:element->name range:element->range];
    }
    
    
    NSMutableArray* array = [NSMutableArray array];
    NSString * code = [attrString string];
    
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
                YGSYntaxHighlighterElement * element = [YGSYntaxHighlighterElement new];
                element->range = range;
                element->name = NSForegroundColorAttributeName;
                element->value = [NSColor greenColor];
                [array addObject:element];
            }
                
                break;
            default:
                break;
        }
    
    }
    elements = [array copy];
    
    for(YGSYntaxHighlighterElement * element in elements)
    {
        [attrString addAttribute:element->name value:element->value range:element->range];
    }
    
}
@end
