defmodule PhoenixPaperWebsiteWeb.Components.SelectionLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Selection Controls")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:selection}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Selection Controls</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Checkbox, PhoenixPaper.Switch, PhoenixPaper.RadioGroup, and
          PhoenixPaper.Rating. Checkbox, Switch, and RadioGroup fake their styled control
          entirely in CSS around a real, visually hidden input — no JavaScript.
        </p>

        <.section title="Checkbox">
          <.demo_group label="States">
            <.pp_checkbox name="terms" label="I agree to the terms" />
            <.pp_checkbox name="marketing" label="Send me updates" checked />
            <.pp_checkbox name="locked" label="Disabled" disabled />
          </.demo_group>
        </.section>

        <.section title="Switch">
          <.demo_group label="States">
            <.pp_switch name="wifi" label="Wi-Fi" checked />
            <.pp_switch name="bluetooth" label="Bluetooth" />
            <.pp_switch name="airplane" label="Disabled" disabled />
          </.demo_group>
        </.section>

        <.section
          title="Radio Group"
          description="A labeled set of mutually exclusive options sharing one name."
        >
          <.demo_group label="Options">
            <.pp_radio_group
              name="size"
              label="Size"
              value="md"
              options={[{"Small", "sm"}, {"Medium", "md"}, {"Large", "lg"}]}
            />
          </.demo_group>
        </.section>

        <.section
          title="Rating"
          description="A row of radio inputs with a pure-CSS hover/checked fill effect. Pass readonly for a fixed display instead."
        >
          <.demo_group label="Interactive">
            <.pp_rating id="rating-interactive" name="rating-interactive" value={3} />
          </.demo_group>

          <.demo_group label="Read-only">
            <.pp_rating id="rating-readonly-2" value={2} readonly />
            <.pp_rating id="rating-readonly-4" value={4} readonly />
            <.pp_rating id="rating-readonly-5" value={5} readonly />
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end
end
