-module(tagmq_config).

-export([version/0]).

-define(Version, <<"0.1">>).

version() ->
  ?Version.
