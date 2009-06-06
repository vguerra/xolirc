# packages/xolirc/tcl/package-procs.tcl

ad_library {
    
    API for IRC interaction
    
    @author Victor Guerra (vguerra@vguerra.net)
    @creation-date 2009-01-15
    @cvs-id $Id$
}

#Checking availability of libthread
if {[info command ::thread::mutex] eq ""} {
    ns_log Notice "xolirc - libthread not available. "
    return
}

package require irc 0.4

Class IRCconn -superclass ::xotcl::THREAD -parameter {
    {nick OACSMonkey}
    {server irc.freenode.net} 
    {port 6667}
    {domain openacs.org}
    {persistance 1}
}

IRCconn instproc init {} {
    #Creating the connection
    my set cn [::irc::connection]
    ns_log Warning "created connection [my set cn]"
    #next
}

IRCconn instproc connect {} {
    my instvar nick server port cn
    ns_log Warning "connecting using cn: $cn"
    $cn connect $server $port
    $cn user $nick localhost domain [my set domain]
    $cn nick $nick
    ns_log Warning "[$cn connected]"
}

IRCconn instproc join_channel {{-channel "\#xotcl"}} {
    my instvar cn
    ns_log Warning "joinning $channel"
    $cn registerevent 001 "$cn join $channel"
} 

IRCconn instproc register_events {} {
    my instvar cn
    # Register a default action for commands from the server.
    $cn registerevent defaultcmd {
        ns_log Warning  "default_command [action] [msg]"
    }
    
    # Register a default action for numeric events from the server.
    $cn registerevent defaultnumeric {
        ns_log Warning  "default_numeric [action] XXX [target] XXX [msg]"
    }
    
    # Register a default action for events.
    $cn registerevent defaultevent {
        ns_log Warning  "default_event [action] XXX [who] XXX [target] XXX [msg]"
    }
    
    # Register a default action for PRIVMSG (either public or to a
    # channel).
    
    $cn registerevent PRIVMSG {
        ns_log Warning  "PRIVMSG [who] says to [target] [msg]"
    }
    
    # If you uncomment this, you can change this file and reload it
    # without shutting down the network connection.
    
    #if {0} {
    #    $cn registerevent PRIVMSG {
    #        ns_log Warning  "[who] says to [target] [msg]"
    #        if { [msg] == "RELOAD" && [target] == $::ircclient::nick} {
    #            if [catch {
    #                ::irc::reload
    #            } err] {
    #                ns_log Warning  "Error: $err"
    #            }
    #            set ::ircclient::RELOAD 1
    #        }
    #    }
    #}
    #vwait ::ircclient::RELOAD
#  
}

namespace eval ircclient {
    set ::ircclient::RELOAD 0
}

# namespace eval ircclient {

#     variable channel \#openacs
#     set nick "OACSMonkey"
#     set server irc.freenode.net
#     set port 6667
    
#     set cn [::irc::connection]
    
#     $cn connect $server $port
#     $cn user $nick localhost domain "www.vguerra.net"
#     $cn nick $nick

#     $cn registerevent 001 "$cn join $channel"
#     ns_log Warning "vguerra - IRC - $cn registered to $channel"

    
#     while (1) {
        
#         ns_log Warning "Loading [info script] ..."
        
#         #    $cn connect irc.freenode.net 6667
#         $cn registerevent 001 "$cn join $channel"
        
#         # Register a default action for commands from the server.
#         $cn registerevent defaultcmd {
#             ns_log Warning  "[action] [msg]"
#         }
        
#         # Register a default action for numeric events from the server.
#         $cn registerevent defaultnumeric {
#             ns_log Warning  "[action] XXX [target] XXX [msg]"
#         }
        
#         # Register a default action for events.
#         $cn registerevent defaultevent {
#             ns_log Warning  "[action] XXX [who] XXX [target] XXX [msg]"
#         }
        
#         # Register a default action for PRIVMSG (either public or to a
#         # channel).
        
#         $cn registerevent PRIVMSG {
#             ns_log Warning  "[who] says to [target] [msg]"
#         }
        
#         # If you uncomment this, you can change this file and reload it
#         # without shutting down the network connection.
        
#         if {0} {
#             $cn registerevent PRIVMSG {
#                 ns_log Warning  "[who] says to [target] [msg]"
#                 if { [msg] == "RELOAD" && [target] == $::ircclient::nick} {
#                     if [catch {
#                         ::irc::reload
#                     } err] {
#                         ns_log Warning  "Error: $err"
#                     }
#                     set ::ircclient::RELOAD 1
#                 }
#             }
#         }
        
#         $cn registerevent KICK {
#             ns_log Warning  "[who] KICKed [target 1] from [target] : [msg]"
#         }
        
#         ns_log Warning  " done"
        
        
#         vwait ::ircclient::RELOAD
#     }
# }
