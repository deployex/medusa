# medusa

A minimal Erlang/OTP umbrella app used to exercise and test [rebar3_jellyfish_plugin](https://github.com/deployex/rebar3_jellyfish_plugin) across releases.

## Apps

 * `medusa_core` - a `gen_server` holding a single counter in its state, plus (as of 0.2.0) a sibling `gen_server` tracking how many times it's been bumped.
 * `medusa_web` - a dependency-free HTTP listener (plain `gen_tcp`, no framework) serving a page at `/` showing both counters, and `/bump` to increment them.

## Running

```bash
rebar3 release
_build/default/rel/medusa/bin/medusa console
```

Then open <http://127.0.0.1:8080/>.

## Plugin under test

`rebar3_jellyfish_plugin` is pulled from Hex in `rebar.config`. A `relup-guard-erlang` CI check (`.github/workflows/relup-guard.yml`) builds the base and head of every PR and runs a real hot upgrade between them.

## Versions

 * `0.1.0` - initial release.
 * `0.2.0` - adds `medusa_core_history_server`, a new supervised child tracking bump counts, and wires `medusa_core_server` to notify it on every bump. This exercises `add_module` and a supervisor-spec update rather than a `code_change`-based state migration: `medusa_core_server` doesn't export `code_change/3` in 0.1.0, so an upgrade from that version would never invoke one anyway, no matter what 0.2.0 adds - the instruction an upgrade uses is chosen from the currently-deployed version's own exports. A future version can add a no-op `code_change/3` first, then safely migrate `medusa_core_server`'s state shape in the version after that.
