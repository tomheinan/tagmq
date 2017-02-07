all: compile

compile:
	rebar3 compile

run: compile
	erl -env ERL_LIBS _build/default/lib -eval 'application:ensure_all_started(tagmq).' -noshell
