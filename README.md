Cinder-OSXSpeech
================
Speech synthesis interface for Cinder on OSX

Addition to an existing project
-------------------------------

Just add the contents of include/ and src/ to your project in XCode (right-click Blocks group -> Add new files...)

Usage
-----

Say something:

    using namespace speech;
    Synthesizer speaker;
    speaker.speak( "something." );

Say it again, and again, and again, and...:

    speaker.loop();
    speaker.speak( "and again" );

Shut up:

    #include <thread>
    #include <chrono>
    using namespace std;
    
    speaker.speak( "I want express that... There's just a few things I want to tell you." );
    this_thread::sleep_for( std::chrono::milliseconds( 500 ) );
    speaker.dontSpeak();

Is that all you have to say?

    speaker.getDoneSpeakingSignal().connect( []{
      speaker.isSpeaking(); // -> false
      cout << "and that's all." << endl;
    } );
    speaker.speak( "Just this ashtray." );
    speaker.isSpeaking() // -> true
