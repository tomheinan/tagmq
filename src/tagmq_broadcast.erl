-module(tagmq_broadcast).

-export([send/1]).

%%% public functions

send(Message) when is_binary(Message) ->
  lists:foreach(
    fun(ConnectionPid) ->
      ConnectionPid ! {message, Message}
    end,
    tagmq_connections:pids()
  ),
  ok;
send(_) -> throw(badarg).
