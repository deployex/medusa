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
 * `0.2.0` - adds `medusa_core_history_server`, a new supervised child tracking bump counts, and wires `medusa_core_server` to notify it on every bump. This exercises `add_module` and a supervisor-spec update rather than a `code_change`-based state migration: `medusa_core_server` doesn't export `code_change/3` in 0.1.0, so an upgrade from that version would never invoke one anyway, no matter what 0.2.0 adds - the instruction an upgrade uses is chosen from the currently-deployed version's own exports.
 * `0.2.1` - adds `code_change/3` to `medusa_core_server` as a no-op pass-through. The 0.2.0 -> 0.2.1 appup is still a plain `load_module` for that module, since the plugin decides the instruction from the currently-deployed version's exports, not the incoming one. This version is a baseline: once it is what is running, a later release that changes `medusa_core_server`'s state shape can get a real `code_change` instruction generated against it.
 * `0.2.2` - `code_change/3` now prints a message instead of being a no-op. Upgrading from 0.2.1 onward, the appup is a real `{update, medusa_core_server, {advanced, []}}`, so this is the first version where that print actually runs during a hot upgrade rather than just being generated and skipped.
 * `0.2.3` - Added default PORT by env VAR and adjusted release code.
 * `0.2.4` - Adding `code_change/3`
