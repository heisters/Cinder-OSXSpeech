#pragma once

#include <string.h>
#include "cinder/Signals.h"

#if defined( __OBJC__ )
    @class NSSpeechSynthesizer, SynthDelegate;
#else
    class NSSpeechSynthesizer;
    class SynthDelegate;
#endif


namespace speech {

class Synthesizer
{
public:
	typedef ci::signals::Signal< void(void) > signal_t;

    Synthesizer();
    ~Synthesizer();
    // Delete copy operators because the signal can't be copied
    Synthesizer(const Synthesizer &other) = delete;
    Synthesizer & operator=(const Synthesizer &other) = delete;


    void        loop( const bool loop=true );
    void        speak( const std::string &text );
    void        dontSpeak();
    void        onFinish( bool success );
    bool        isSpeaking() const;
    signal_t &  getDoneSpeakingSignal() { return mDoneSpeakingSignal; }
private:
    NSSpeechSynthesizer *synth;
    SynthDelegate       *synthDelegate;
    std::string         mLastText;
    bool                mIsLooping, mStopRequested, mIsSpeaking;
    signal_t            mDoneSpeakingSignal;
};

}
