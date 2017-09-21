# PlugMetrics [![CircleCI](https://img.shields.io/circleci/project/github/derek-schaefer/plug_metrics.svg)](https://circleci.com/gh/derek-schaefer/plug_metrics) [![Hex](https://img.shields.io/hexpm/v/plug_metrics.svg)](https://hex.pm/packages/plug_metrics)

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `plug_metrics` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_metrics, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/plug_metrics](https://hexdocs.pm/plug_metrics).

## TODO
- [x] Create and unit test a basic runtime plug
- [x] Create and unit test a basic queries plug
- [ ] Ensure that metrics are consumed even if there are errors
- [ ] Ensure that if the metrics server is unreachable that requests still succeed
- [ ] Add explanatory and usage documentation to this file
- [ ] Add inline documentation to the source
- [ ] Add typespecs such that dialyzer no longer produces warnings
- [ ] Create an example application
- [ ] Add integration tests
