-module(tagmq_connections).

-export([pids/0, count/0]).

%%% public

pids() ->
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

count() ->
  length(pids()).

%%% private

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
