# PhoenixPaper Website

The showcase site for [PhoenixPaper](https://github.com/z7ealth/phoenix_paper): a live, running demo of every component the library ships, with usage examples and options tables for each one. This repo is not the library itself; for the component source, API docs, and `mix.exs` install instructions, go to the [phoenix_paper repo](https://github.com/z7ealth/phoenix_paper).

## Running locally

This app depends on `phoenix_paper` as a local path dependency (`../phoenix_paper` in `mix.exs`), so it expects a sibling checkout:

```
some-parent-dir/
├── phoenix_paper/
└── phoenix_paper_website/   (this repo)
```

With that in place:

* Run `mix setup` to install and set up dependencies
* Start the server with `mix phx.server` (or `iex -S mix phx.server` from IEx)
* Visit [`localhost:4000`](http://localhost:4000): `/` is the landing page, `/components` is the full catalog

`config/dev.exs` sets `reloadable_apps: [:phoenix_paper_website, :phoenix_paper]`, so editing a component in the sibling `phoenix_paper` checkout live-reloads here too, without a manual recompile.

Ready to run in production? See Phoenix's own [deployment guides](https://phoenix.hexdocs.pm/deployment.html).
