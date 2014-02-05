//
//  YGDocument.m
//  Praline
//
//  Created by Yannick Heinrich on 09/12/2013.
//  Copyright (c) 2013 YaGeek. All rights reserved.
//

#import "YGDocument.h"
#import "YGSourceCodeWindowController.h"

@interface YGDocument()
{
    YGSourceCodeWindowController * _sourceCodeController;
}

@end
@implementation YGDocument

- (id) init
{
    if(self = [super init])
    {
        _syntaxHighlighted = YES;
    }
    return self;
}
- (void) makeWindowControllers
{
   _sourceCodeController = [[YGSourceCodeWindowController alloc] init];
    [self addWindowController:_sourceCodeController];
    
   NSWindow * window = [_sourceCodeController window];
    
    [window makeKeyAndOrderFront:self];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
       
    NSStringEncoding encoding = codeEncoding ?: NSUTF8StringEncoding;
    
    NSData * data = [code dataUsingEncoding:encoding];
    
    if(!data)
    {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
    }
    
    return data;
}

- (BOOL) readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    
    code  = [[NSString alloc] initWithContentsOfFile:url.path usedEncoding:&codeEncoding error:outError];
    
    return (code != nil);
}
@end
