# medusa

A minimal Erlang/OTP umbrella app used to exercise and test [rebar3_jellyfish_plugin](https://github.com/deployex/rebar3_jellyfish_plugin) across releases.

## Apps

 * `medusa_core` - a `gen_server` holding a single counter in its state. Its state shape changes between 0.1.0 and 0.2.0 on purpose, so the plugin has a real `code_change` to generate.
 * `medusa_web` - a dependency-free HTTP listener (plain `gen_tcp`, no framework) serving a page at `/` showing the counter, and `/bump` to increment it.

## Running

```bash
rebar3 release
_build/default/rel/medusa/bin/medusa console
```

Then open <http://127.0.0.1:8080/>.

## Plugin under test

`rebar3_jellyfish_plugin` isn't published to hex yet, so `rebar.config` pulls it from a sibling checkout over a local `file://` git URL (see the comment there for why `project_plugin_dirs` doesn't work for this). Update that URL/branch, or switch to a hex version once one exists, to point at a different checkout.

## Versions

 * `0.1.0` - initial release.
 * `0.2.0` - changes `medusa_core`'s state shape, to produce a non-trivial appup.
