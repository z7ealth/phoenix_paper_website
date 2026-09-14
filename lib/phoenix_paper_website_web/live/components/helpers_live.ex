defmodule PhoenixPaperWebsiteWeb.Components.HelpersLive do
  use PhoenixPaperWebsiteWeb, :live_view

  @elevation_levels [0, 1, 2, 4, 8, 16, 24]
  @shape_tokens [:none, :xs, :sm, :md, :lg, :xl, :full]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Helpers")
     |> assign(:elevation_levels, @elevation_levels)
     |> assign(:shape_tokens, @shape_tokens)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:helpers}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Helpers</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Ripple, Elevation, and Shape: the plumbing every visual component in
          this library is built on. Color theming has its own <.link
            navigate={~p"/theming"}
            class="text-pp-primary hover:underline"
          >guide</.link>.
        </p>

        <.section
          title="Ripple"
          description="The Material ripple effect (a circle that expands from the click point and fades out). Vanilla inline onclick, no JS hook/bundler. Click or tap any button on this site to see it."
          props={[
            {"ripple",
             "the boolean prop on Button, Fab, ToggleButton, Switch, Checkbox, RadioGroup, and a linked ListItem: default true, except Checkbox/RadioGroup (default false; their own instant fill/border change already reads as feedback on a target that small); always off when paperize is false"},
            {"PhoenixPaper.Ripple.on_click/1",
             "returns the script, or nil when disabled (so the attribute is dropped entirely)"},
            {"PhoenixPaper.Ripple.container_classes/1",
             "the \"relative overflow-hidden\" the ripple needs to stay clipped"}
          ]}
          code={ripple_code()}
        >
          <.demo_group label="ripple: true (default) vs. ripple: false">
            <.pp_button>Ripples (default)</.pp_button>
            <.pp_button ripple={false}>No ripple</.pp_button>
          </.demo_group>
        </.section>

        <.section
          title="Elevation"
          description="PhoenixPaper.Elevation.class/1 maps a Material dp level (0-24, clamped) to a pp-elevation-N class backed by a two-layer box-shadow approximating Google's official table."
          props={[{"Elevation.class(level)", "returns the literal \"pp-elevation-N\" class name"}]}
          code={elevation_code()}
        >
          <.demo_group label="Scale">
            <div :for={level <- @elevation_levels} class="flex flex-col items-center gap-2">
              <div class={[
                "flex size-16 items-center justify-center rounded-lg bg-pp-surface text-xs font-medium text-pp-on-surface/60",
                PhoenixPaper.Elevation.class(level)
              ]}>
                {level}dp
              </div>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Shape"
          description="PhoenixPaper.Shape.class/1,2 maps a token to a literal rounded-* class, optionally scoped to an edge (:top/:bottom) for shapes like the filled text field that only round two corners."
          props={[
            {"Shape.class(token)", "all four corners"},
            {"Shape.class(token, :top | :bottom)", "only those two corners"}
          ]}
          code={shape_code()}
        >
          <.demo_group label="Scale" class="items-end">
            <div :for={token <- @shape_tokens} class="flex flex-col items-center gap-2">
              <div class={[
                "size-14 border-2 border-pp-primary bg-pp-primary/10",
                PhoenixPaper.Shape.class(token)
              ]} />
              <span class="text-xs text-pp-on-surface/60">{token}</span>
            </div>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp ripple_code do
    """
    <.pp_button>Ripples (default)</.pp_button>
    <.pp_button ripple={false}>No ripple</.pp_button>\
    """
  end

  defp elevation_code do
    """
    <div class={["rounded-lg bg-pp-surface p-4", PhoenixPaper.Elevation.class(8)]}>8dp</div>\
    """
  end

  defp shape_code do
    """
    <div class={["size-14 border-2 border-pp-primary", PhoenixPaper.Shape.class(:lg)]} />\
    """
  end
end
