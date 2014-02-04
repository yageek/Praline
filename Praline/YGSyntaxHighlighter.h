//
//  YGSyntaxHighlighter.h
//  Praline
//
//  Created by Yannick Heinrich on 03/02/2014.
//  Copyright (c) 2014 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGSYntaxHighlighterElement : NSObject
{
    @public
    NSRange range;
    NSString *name;
    id value;
    
    
}

@end

@interface YGSyntaxHighlighter : NSObject
{
    NSArray * elements;
}

- (void) highlightString:(NSMutableAttributedString*) attrString;
@end
