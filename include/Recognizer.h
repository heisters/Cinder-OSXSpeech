#pragma once

#include <string.h>
#include <map>
#include <vector>
#include <functional>
#include <objc/objc.h>

namespace speech {

typedef std::function< void( void ) > command_fn;
typedef std::map< std::string, std::vector< command_fn > > command_callback_container;


class Recognizer
{
public:
    Recognizer();

    void    start();
    void    stop();
    void    addCommand( const std::string &command, const command_fn &callback );
    void    executeCommand( const std::string &command );
private:
    id      recognizer;
    id      recognizerDelegate;
    command_callback_container callbacks;
};

}