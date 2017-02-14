-module(tagmq_info_handler).

-export([init/2]).

init(Req, Opts) ->
  Info = #{
    tagmq => #{
      version => tagmq_config:version(),
      connections => tagmq_connections:count()
    }
  },

  Payload = jiffy:encode(Info, [pretty]),

  Res = cowboy_req:reply(
    200,
    #{
      <<"content-type">> => <<"application/json">>
    },
    Payload,
    Req
  ),

  {ok, Res, Opts}.
