-module(tagmq_info_handler).

-export([init/2]).

init(Req0, Opts) ->
  Req = cowboy_req:reply(
    200,
    #{
      <<"content-type">> => <<"application/json">>
    },
    <<"{\"hello\": \"tagmq\"}">>,
    Req0
  ),
  {ok, Req, Opts}.
