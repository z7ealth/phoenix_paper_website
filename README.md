# PhoenixPaper Website

The showcase site for [PhoenixPaper](https://github.com/z7ealth/phoenix_paper): a live, running demo of every component the library ships, with usage examples and options tables for each one. This repo is not the library itself; for the component source, API docs, and `mix.exs` install instructions, go to the [phoenix_paper repo](https://github.com/z7ealth/phoenix_paper).

## Running locally

This app depends on the published [`phoenix_paper`](https://hex.pm/packages/phoenix_paper) hex package (`{:phoenix_paper, "~> 0.2.7"}` in `mix.exs`).

* Run `mix setup` to install and set up dependencies (this includes `npm install` in `assets/` for highlight.js, so Node.js/npm must be installed)
* Start the server with `mix phx.server` (or `iex -S mix phx.server` from IEx)
* Visit [`localhost:4000`](http://localhost:4000): `/` is the landing page, `/components` is the full catalog

### Developing against a local phoenix_paper

To try unreleased library changes, check `phoenix_paper` out next to this repo:

```
some-parent-dir/
├── phoenix_paper/
└── phoenix_paper_website/   (this repo)
```

Then in `mix.exs`, comment out the hex line and uncomment the path one right below it (`{:phoenix_paper, path: "../phoenix_paper"}`), run `mix deps.get`, and restart the server. Nothing else changes: `app.css` imports `phoenix_paper/priv/static/phoenix_paper.css` through `NODE_PATH`, which `config/config.exs` points at wherever Mix resolved the dependency. `config/dev.exs` sets `reloadable_apps: [:phoenix_paper_website, :phoenix_paper]`, so editing a component in the local checkout live-reloads here too. Switch back to the hex line before committing or building the Docker image (its build context can't see the sibling directory).

Ready to run in production? See Phoenix's own [deployment guides](https://phoenix.hexdocs.pm/deployment.html).
