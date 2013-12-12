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

- (void) makeWindowControllers
{
   _sourceCodeController = [[YGSourceCodeWindowController alloc] init];
    [self addWindowController:_sourceCodeController];
    
    if(code)
    {
        _sourceCodeController.editorView.textView.string = [code copy];
    }

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
    code = [_sourceCodeController.editorView.textView.string copy];

    [_sourceCodeController.editorView.textView breakUndoCoalescing];
    
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
