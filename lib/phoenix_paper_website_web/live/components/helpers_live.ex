defmodule PhoenixPaperWebsiteWeb.Components.HelpersLive do
  use PhoenixPaperWebsiteWeb, :live_view

  @shape_tokens [:none, :xs, :sm, :md, :lg, :lg_increased, :xl, :xl_increased, :xxl, :full]

  # Full literal class names so Tailwind generates each one.
  @springs [
    {"spatial-fast", "pp-motion-spatial-fast"},
    {"spatial-default", "pp-motion-spatial-default"},
    {"spatial-slow", "pp-motion-spatial-slow"},
    {"effects-fast", "pp-motion-effects-fast"},
    {"effects-default", "pp-motion-effects-default"},
    {"effects-slow", "pp-motion-effects-slow"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Helpers")
     |> assign(:shape_tokens, @shape_tokens)
     |> assign(:springs, @springs)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:helpers}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Helpers">
          PhoenixPaper.Ripple, Elevation, Shape and the motion tokens: the plumbing every
          component is built on. Color has its own <.link
            navigate={~p"/theming"}
            class="text-pp-primary hover:underline"
          >guide</.link>.
        </.page_header>

        <.section
          title="Ripple"
          description="The Material ripple: a circle that expands from the click point and fades. A vanilla inline onclick, no hook or bundler. On by default on buttons, FABs, linked list items and rail items; off by default on Switch, Checkbox and RadioGroup (their 40dp state layer already gives feedback); always off with paperize={false}."
          props={[
            {"ripple", "the boolean attr on interactive components (see each component's options)"},
            {"PhoenixPaper.Ripple.on_click/1",
             "the onclick script, or nil when disabled (the attribute is dropped)"},
            {"PhoenixPaper.Ripple.container_classes/1,2",
             "the relative/overflow-hidden the ripple needs; the /2 form takes a position for components with a position attr"}
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
          description="MD3 has six elevation levels (0–5) with its own shadows; PhoenixPaper.Elevation.class/1 maps a level (clamped to 5) to a pp-elevation-N class. MD3 mostly separates surfaces by color (the surface-container scale, see Paper), and keeps shadows for things that float."
          props={[{"Elevation.class(level)", "the literal \"pp-elevation-N\" class, level 0–5"}]}
          code={elevation_code()}
        >
          <.demo_group label="Levels 0–5">
            <div
              :for={level <- 0..5}
              class={[
                "flex size-16 items-center justify-center rounded-pp-md bg-pp-surface-container-low",
                PhoenixPaper.Elevation.class(level)
              ]}
            >
              <.pp_typography variant="label-large" color="on-surface-variant">
                {level}
              </.pp_typography>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Shape"
          description="The MD3 corner scale as --radius-pp-* tokens and rounded-pp-* utilities, including M3 Expressive's lg_increased, xl_increased and xxl. PhoenixPaper.Shape.class/1,2 maps a token to its class, optionally on one edge (:top, :bottom, :start, :end)."
          props={[
            {"Shape.class(token)", "all four corners"},
            {"Shape.class(token, :top | :bottom | :start | :end)", "only that edge's two corners"}
          ]}
          code={shape_code()}
        >
          <.demo_group label="The scale" class="items-end">
            <div :for={token <- @shape_tokens} class="flex flex-col items-center gap-2">
              <div class={[
                "size-14 border-2 border-pp-primary bg-pp-primary-container",
                PhoenixPaper.Shape.class(token)
              ]} />
              <.pp_typography variant="label-small" color="on-surface-variant">
                {token}
              </.pp_typography>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Motion"
          description={
            ~S|M3 Expressive's motion as springs: spatial springs (for position and size; they can overshoot) and effects springs (for color and opacity; no overshoot), each fast/default/slow, as CSS linear() easings sampled from the real springs. Components use them already; pp-motion-* utilities set the transition for your own elements. data-pp-motion="standard" on an ancestor switches to the calmer standard scheme, prefers-reduced-motion is respected, and the classic MD3 duration easings are available as ease-pp-*.|
          }
          props={[
            {"pp-motion-spatial-fast / -default / -slow",
             "transition timing + duration for movement and size"},
            {"pp-motion-effects-fast / -default / -slow",
             "transition timing + duration for color and opacity"},
            {~S|data-pp-motion="standard"|,
             "on any ancestor: the standard (non-Expressive) motion scheme"},
            {"ease-pp-standard / -emphasized (and -accelerate / -decelerate)",
             "MD3's cubic-bezier easings, for your own transition-* utilities"}
          ]}
          code={motion_code()}
        >
          <.demo_group label="Hover a row: the square slides with that spring" direction="column">
            <div
              :for={{label, class} <- @springs}
              class="group flex items-center gap-4 rounded-pp-md px-2 py-1 hover:bg-pp-surface-container"
            >
              <.pp_typography variant="label-medium" class="w-32 shrink-0">{label}</.pp_typography>
              <div class="relative h-8 flex-1">
                <div class={[
                  "absolute left-0 top-1 size-6 rounded-pp-sm bg-pp-primary transition-[left,background-color]",
                  "group-hover:left-[calc(100%-1.5rem)] group-hover:bg-pp-tertiary",
                  class
                ]} />
              </div>
            </div>
          </.demo_group>
        </.section>
      </div>
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
    <div class={["rounded-pp-md bg-pp-surface-container-low p-4", PhoenixPaper.Elevation.class(3)]}>Level 3</div>\
    """
  end

  defp shape_code do
    """
    <div class={["size-14 bg-pp-primary-container", PhoenixPaper.Shape.class(:xl_increased)]} />
    <div class={["size-14 bg-pp-primary-container", PhoenixPaper.Shape.class(:lg, :top)]} />

    <%!-- or the utilities directly --%>
    <div class="size-14 rounded-pp-xxl bg-pp-primary-container" />\
    """
  end

  defp motion_code do
    """
    <%!-- A spring for movement --%>
    <div class="transition-transform pp-motion-spatial-default hover:translate-x-4">...</div>

    <%!-- An effects spring for color --%>
    <div class="bg-pp-surface-container transition-colors pp-motion-effects-fast hover:bg-pp-secondary-container">...</div>

    <%!-- The calmer standard scheme for a whole subtree --%>
    <div data-pp-motion="standard">...</div>\
    """
  end
end
