-module(tagmq_root_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req0, Opts) ->
  #{headers := Headers} = Req0,
  case maps:get(<<"connection">>, Headers) of
    <<"Upgrade">> ->
      io:format("headers: ~p.", [Headers]),
      {cowboy_websocket, Req0, Opts};

    _Else ->
      tagmq_info_handler:init(Req0, Opts)
  end.

websocket_init(State) ->
	erlang:start_timer(1000, self(), <<"Hello!">>),
	{ok, State}.

websocket_handle({text, Msg}, State) ->
	{reply, {text, << "That's what she said! ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
	{ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{reply, {text, Msg}, State};
websocket_info(_Info, State) ->
	{ok, State}.
