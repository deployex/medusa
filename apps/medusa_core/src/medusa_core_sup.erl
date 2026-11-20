%%%-------------------------------------------------------------------
%% @doc medusa_core top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(medusa_core_sup).

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
            id => medusa_core_history_server,
            start => {medusa_core_history_server, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [medusa_core_history_server]
        },
        #{
            id => medusa_core_server,
            start => {medusa_core_server, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [medusa_core_server]
        }
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
