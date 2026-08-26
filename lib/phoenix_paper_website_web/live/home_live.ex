defmodule PhoenixPaperWebsiteWeb.HomeLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Material Design for Phoenix")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.landing flash={@flash}>
      <.pp_container max_width="lg" class="py-20">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">
          PhoenixPaper
        </p>
        <h1 class="mb-4 text-4xl font-semibold tracking-tight sm:text-5xl">
          Material Design, built for Phoenix.
        </h1>
        <p class="mb-8 max-w-2xl text-lg text-pp-on-surface/70">
          A component library for Phoenix and Phoenix LiveView, in the spirit of
          <span class="text-pp-on-surface">ember-paper</span>
          for Ember.js — styled entirely with Tailwind CSS, and shipped as a plain hex
          dependency your app already knows how to install.
        </p>

        <.pp_stack direction="row" spacing={:md} wrap class="mb-14">
          <.link_button href={~p"/components"}>See Components</.link_button>
          <.link_button href={~p"/getting-started"} variant="outlined">
            Get Started
          </.link_button>
        </.pp_stack>

        <.section
          eyebrow="Quick look"
          title="Every component, live"
          description="Nothing on this page is a screenshot — everything below is a real PhoenixPaper component, rendered live by this LiveView."
        >
          <.pp_stack spacing={:lg}>
            <.demo_group label="Try it">
              <.pp_button color="primary">Raised</.pp_button>
              <.pp_button color="secondary" variant="outlined">Outlined</.pp_button>
              <.pp_button color="tertiary" variant="text">Text</.pp_button>
              <.pp_button variant="icon" color="primary"><.pp_icon name="hero-bell" /></.pp_button>
              <.pp_fab color="secondary"><.pp_icon name="hero-sparkles" /></.pp_fab>
            </.demo_group>

            <.pp_grid spacing={:lg}>
              <.pp_grid_item span={12} md={6}>
                <.pp_card>
                  <:title>Account</:title>
                  You have no pending invoices this month.
                  <:actions>
                    <.pp_button variant="text">Dismiss</.pp_button>
                    <.pp_button variant="text" color="primary">Review</.pp_button>
                  </:actions>
                </.pp_card>
              </.pp_grid_item>

              <.pp_grid_item span={12} md={6}>
                <.pp_stack
                  spacing={:md}
                  class="justify-center rounded-xl border border-pp-outline/15 bg-pp-surface-variant/30 p-6"
                >
                  <.pp_switch name="notifications" label="Notifications" checked />
                  <.pp_checkbox name="updates" label="Product updates" checked />
                  <.pp_rating id="home-rating" name="home-rating" value={4} />
                </.pp_stack>
              </.pp_grid_item>
            </.pp_grid>
          </.pp_stack>
        </.section>

        <.pp_grid spacing={:lg} class="mb-16">
          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_box class="mb-3 inline-flex size-10 items-center justify-center rounded-full bg-pp-primary/10 text-pp-primary">
                <.pp_icon name="hero-swatch" />
              </.pp_box>
              <:title>Tailwind-native theming</:title>
              Colors are Tailwind v4 theme tokens, namespaced <code class="text-xs">pp-</code>
              so they never collide with daisyUI — this site ships both, side by side. Dark
              mode flips with the toggle in the top right corner.
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_box class="mb-3 inline-flex size-10 items-center justify-center rounded-full bg-pp-secondary/10 text-pp-secondary">
                <.pp_icon name="hero-bolt" />
              </.pp_box>
              <:title>CSS-only interactions</:title>
              Checkboxes, radios, ratings, accordions, and the drawer's mobile toggle are all
              pure CSS — <code class="text-xs">peer-checked:</code>
              and <code class="text-xs">has-[:checked]:</code>
              tricks, no client JS shipped for them at all.
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_box class="mb-3 inline-flex size-10 items-center justify-center rounded-full bg-pp-tertiary/10 text-pp-tertiary">
                <.pp_icon name="hero-shield-check" />
              </.pp_box>
              <:title>The paperize escape hatch</:title>
              Every component accepts a <code class="text-xs">paperize</code>
              attribute. Turn it off and every built-in class disappears — only your own
              <code class="text-xs">class</code>
              renders, no fighting the library's CSS.
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_box class="mb-3 inline-flex size-10 items-center justify-center rounded-full bg-pp-error/10 text-pp-error">
                <.pp_icon name="hero-code-bracket" />
              </.pp_box>
              <:title>Idiomatic Phoenix forms</:title>
              Form components accept a <code class="text-xs">field</code>
              from <code class="text-xs">to_form/2</code>
              the same way this app's own <code class="text-xs">core_components.ex</code>
              inputs do — no new form abstraction to learn.
            </.pp_card>
          </.pp_grid_item>
        </.pp_grid>

        <.pp_stack
          direction="row"
          spacing={:md}
          wrap
          class="items-center justify-between rounded-2xl bg-pp-primary px-8 py-10 text-pp-on-primary"
        >
          <.pp_box>
            <h2 class="text-xl font-semibold">Ready to look around?</h2>
            <p class="text-pp-on-primary/80">
              Buttons, forms, selection controls, navigation, and surfaces — all in one place.
            </p>
          </.pp_box>
          <.link_button href={~p"/components"} variant="flat" color="surface" class="shrink-0">
            View all components
          </.link_button>
        </.pp_stack>
      </.pp_container>
    </Layouts.landing>
    """
  end
end
