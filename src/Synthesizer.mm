#include "Synthesizer.h"
#import <Foundation/NSString.h>
#import <AppKit/NSSpeechSynthesizer.h>

using namespace std;
using namespace speech;


@interface SynthDelegate : NSObject < NSSpeechSynthesizerDelegate > {
    Synthesizer *synthesizer;
}
- (id)initWithSynthesizer:(Synthesizer *)aSynthesizer;
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)success;
@end

@implementation SynthDelegate

- (id)initWithSynthesizer:(Synthesizer *)aSynthesizer
{
    self = [super init];
    if ( self ) {
        synthesizer = aSynthesizer;
    }
    return self;
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)success
{
    synthesizer->onFinish( success );
}
@end


Synthesizer::Synthesizer() :
mIsLooping( false ),
mStopRequested( false ),
mIsSpeaking( false ),
synth( [[NSSpeechSynthesizer alloc] init] ),
synthDelegate( [[SynthDelegate alloc] initWithSynthesizer:this] )
{
    ((NSSpeechSynthesizer *)synth).delegate = synthDelegate;
}

Synthesizer::~Synthesizer()
{
    if ( synth.delegate ) synth.delegate = nil;
    if ( synthDelegate ) [synthDelegate release];
    if ( synth ) [synth release];
}

void
Synthesizer::loop( const bool loop )
{
    mIsLooping = loop;
}

void
Synthesizer::speak( const string &text )
{
    mIsSpeaking = true;
    mLastText = text;
    NSString *ns_text = [NSString stringWithCString:text.c_str()
                                           encoding:[NSString defaultCStringEncoding]];
    [synth startSpeakingString:ns_text];
}

void
Synthesizer::dontSpeak()
{
    if ( isSpeaking() ) {
        mStopRequested = true;
        [synth stopSpeaking];
    } else {
        mIsSpeaking = false;
    }
}

void
Synthesizer::onFinish( bool success )
{
    if ( mIsLooping && success && !mStopRequested ) {
        speak( mLastText );
    } else {
        mIsSpeaking = false;
    }

    mStopRequested = false;

    if ( !mIsSpeaking ) getDoneSpeakingSignal().emit();
}

bool
Synthesizer::isSpeaking() const
{
    return mIsSpeaking && synth.isSpeaking;
}
