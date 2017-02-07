%%%-------------------------------------------------------------------
%% @doc tagmq public API
%% @end
%%%-------------------------------------------------------------------

-module(tagmq_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    tagmq_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================