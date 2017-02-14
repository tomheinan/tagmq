-module(tagmq_broadcast).

-export([send/1]).

% TODO remove these exports before shipping
-export([listener_pids/0, connection_supervisor_pids/0, connection_pids/0]).

%%% public functions

send(Message) when is_binary(Message) ->
  lists:foreach(
    fun(ConnectionPid) ->
      ConnectionPid ! {message, Message}
    end,
    connection_pids()
  ),
  ok;
send(_) -> throw(badarg).

%%% private shenanigans

listener_pids() ->
  lists:foldl(
    fun(Listener, Acc) ->
      {_, ListenerInfo} = Listener,
      {pid, Pid} = lists:keyfind(pid, 1, ListenerInfo),
      Acc ++ [Pid]
    end,
    [],
    ranch:info()
  ).

connection_supervisor_pids() ->
  lists:foldl(
    fun(ListenerPid, Acc) ->
      Children = supervisor:which_children(ListenerPid),
      Pids = lists:filtermap(
        fun(ChildSpec) ->
           case ChildSpec of
             {ranch_conns_sup, Pid, supervisor, _} ->
               {true, Pid};
              _Else ->
                false
            end
        end,
        Children
      ),
      Acc ++ Pids
    end,
    [],
    listener_pids()
  ).

connection_pids() ->
  lists:foldl(
    fun(ConnectionSupPid, Acc) ->
      Children = supervisor:which_children(ConnectionSupPid),
      Pids = lists:filtermap(
        fun(ChildSpec) ->
           case ChildSpec of
             {cowboy_clear, Pid, _, _} ->
               {true, Pid};
              _Else ->
                false
            end
        end,
        Children
      ),
      Acc ++ Pids
    end,
    [],
    connection_supervisor_pids()
  ).
