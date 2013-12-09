//
//  main.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDLog.h>
int main(int argc, const char * argv[])
{
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    return NSApplicationMain(argc, argv);
}
