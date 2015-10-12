#include "Recognizer.h"
#include <string>
#include <iostream>
#import <AppKit/NSSpeechRecognizer.h>
#import <Foundation/Foundation.h>

@interface RecognizerDelegate : NSObject < NSSpeechRecognizerDelegate > {
    speech::Recognizer *recognizer;
}
- (id)initWithRecognizer:(speech::Recognizer *)aRecognizer;
- (void)speechRecognizer:(NSSpeechRecognizer *)sender didRecognizeCommand:(NSString *)command;
@end

@implementation RecognizerDelegate

- (id)initWithRecognizer:(speech::Recognizer *)aRecognizer
{
    self = [super init];
    if ( self ) {
        recognizer = aRecognizer;
    }
    return self;
}

- (void)speechRecognizer:(NSSpeechRecognizer *)sender didRecognizeCommand:(NSString *)command
{
    std::string str_command = std::string( [command UTF8String] );
    recognizer->executeCommand( str_command );
}

@end

using namespace std;
using namespace speech;

Recognizer::Recognizer() :
recognizer( [[NSSpeechRecognizer alloc] init] ),
recognizerDelegate( [[RecognizerDelegate alloc] initWithRecognizer:this] )
{
    ((NSSpeechRecognizer *)recognizer).delegate = recognizerDelegate;
}

void
Recognizer::start()
{
    [recognizer startListening];
}

void
Recognizer::stop()
{
    [recognizer stopListening];
}

void
Recognizer::addCommand( const string &command, const command_fn &callback )
{
    callbacks[ command ].push_back( callback );



    NSMutableArray *commands = [NSMutableArray array];
    for ( auto &kv : callbacks ) {
        std::cout << kv.first << endl;
        NSString *ns_command = [NSString stringWithCString:kv.first.c_str()
                                                  encoding:[NSString defaultCStringEncoding]];
        [commands addObject:ns_command];
    }

    [recognizer setCommands:commands];
}

void
Recognizer::executeCommand( const std::string &command )
{
    for ( auto &cb : callbacks[ command ] ) {
        cb();
    }
}