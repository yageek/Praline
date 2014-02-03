//
//  YGSyntaxHighlighter.h
//  Praline
//
//  Created by Yannick Heinrich on 03/02/2014.
//  Copyright (c) 2014 YaGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGSyntaxHighlighter : NSObject

- (id) initWithTextView:(NSTextView*) textView;

- (void) highlight;
@end
