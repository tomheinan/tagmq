-module(tagmq_root_handler).

-include("connection_state.hrl").

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
  #{headers := Headers} = Req,
  case maps:get(<<"connection">>, Headers) of
    <<"Upgrade">> ->
      {cowboy_websocket, Req, Opts};

    _Else ->
      tagmq_info_handler:init(Req, Opts)
  end.

websocket_init(State) ->
  io:format("pid: ~p.", [self()]),
	{ok, State}.

% called whenever a websocket frame arrives

websocket_handle({text, Msg}, State) ->
  io:format("state: ~p.", [State]),
	{reply, {text, << "That's what she said! ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
	{ok, State}.

% called whenever an erlang message arrives

websocket_info({message, Message}, State) ->
	{reply, {text, Message}, State};
websocket_info(_Info, State) ->
	{ok, State}.
