%%%-------------------------------------------------------------------
%% @doc medusa_web top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(medusa_web_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy => one_for_one,
        intensity => 1,
        period => 5
    },
    ChildSpecs = [
        #{
            id => medusa_web_listener,
            start => {medusa_web_listener, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [medusa_web_listener]
        }
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
