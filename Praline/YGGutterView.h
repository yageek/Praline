//
//  YGGutterView.h
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YGGutterView : NSView


@property(strong,nonatomic) NSArray * lineFragmentRectsArray;
@property(strong,nonatomic) NSDictionary * textAttributes;
@end
