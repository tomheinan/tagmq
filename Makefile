all: compile

compile:
	rebar3 compile

run: compile
	erl -env ERL_LIBS _build/default/lib -eval 'application:ensure_all_started(tagmq).' -setcookie tagmq -sname tagmq -noshell

shell: compile
	erl -env ERL_LIBS _build/default/lib -eval 'application:ensure_all_started(tagmq).' -setcookie tagmq -sname tagmq

observe:
	erl -sname observer -hidden -setcookie tagmq -run observer
