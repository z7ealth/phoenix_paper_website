defmodule PhoenixPaperWebsiteWeb.HomeLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Material Design for Phoenix")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.landing flash={@flash}>
      <.pp_container max_width="lg" class="py-20">
        <div class="relative mb-14">
          <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden">
            <div class="pp-hero-blob pp-hero-blob-1 absolute -top-24 -left-16 size-72 bg-pp-primary" />
            <div class="pp-hero-blob pp-hero-blob-2 absolute top-0 -right-10 size-64 bg-pp-secondary" />
            <div class="pp-hero-blob pp-hero-blob-3 absolute -bottom-24 left-1/3 size-56 bg-pp-accent" />
          </div>

          <div class="flex flex-col items-start gap-10 lg:flex-row lg:items-center lg:justify-between">
            <div class="max-w-2xl">
              <h1 class="mb-4 text-4xl font-semibold tracking-tight sm:text-5xl">
                Material Design, built for Phoenix.
              </h1>
              <p class="mb-8 max-w-2xl text-lg text-pp-on-surface/70">
                A component library for Phoenix and Phoenix LiveView, in the spirit of
                <span class="whitespace-nowrap text-pp-on-surface">ember-paper</span>
                for Ember.js, styled entirely with Tailwind CSS, and shipped as a plain hex
                dependency your app already knows how to install. Most components follow the API
                and behavior of <span class="whitespace-nowrap text-pp-on-surface">MUI</span>
                (Material-UI for React), adapted to Phoenix's server-rendered, function-component
                model.
              </p>

              <.pp_stack direction="row" spacing={:md} wrap>
                <.link_button href={~p"/components"}>See Components</.link_button>
                <.link_button href={~p"/getting-started"} variant="outlined">
                  Get Started
                </.link_button>
              </.pp_stack>
            </div>

            <.hero_mark class="hidden shrink-0 lg:block lg:size-56 xl:size-64" />
          </div>
        </div>

        <.section
          eyebrow="Quick look"
          title="Every component, live"
          description="Click around below and try them."
        >
          <.pp_stack spacing={:lg}>
            <.demo_group label="Try it">
              <.pp_button color="primary">Raised</.pp_button>
              <.pp_button color="secondary" variant="outlined">Outlined</.pp_button>
              <.pp_button color="accent" variant="text">Text</.pp_button>
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
              <.pp_avatar color="primary" class="mb-3"><.pp_icon name="hero-swatch" /></.pp_avatar>
              <:title>Tailwind-native theming</:title>
              Colors are Tailwind v4 theme tokens, namespaced
              <.pp_typography variant="code">pp-</.pp_typography>
              so they never collide with daisyUI; this site ships both, side by side. Try the
              theme picker in the top right corner: color mode, primary accent, neutral tone,
              and font are all live.
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_avatar color="secondary" class="mb-3"><.pp_icon name="hero-bolt" /></.pp_avatar>
              <:title>CSS-only interactions</:title>
              Checkboxes, radios, ratings, accordions, and the drawer's mobile toggle are all
              pure CSS:
              <.pp_typography variant="code">peer-checked:</.pp_typography>
              and
              <.pp_typography variant="code">has-[:checked]:</.pp_typography>
              tricks, no client JS shipped for them at all.
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_avatar color="accent" class="mb-3">
                <.pp_icon name="hero-shield-check" />
              </.pp_avatar>
              <:title>The paperize escape hatch</:title>
              Every component accepts a
              <.pp_typography variant="code">paperize</.pp_typography>
              attribute. Turn it off and every built-in class disappears; only your own
              <.pp_typography variant="code">class</.pp_typography>
              renders, no fighting the library's CSS.
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={6}>
            <.pp_card padding={:lg} class="h-full">
              <.pp_avatar color="error" class="mb-3">
                <.pp_icon name="hero-code-bracket" />
              </.pp_avatar>
              <:title>Idiomatic Phoenix forms</:title>
              Form components accept a
              <.pp_typography variant="code">field</.pp_typography>
              from
              <.pp_typography variant="code">to_form/2</.pp_typography>
              the same way this app's own
              <.pp_typography variant="code">core_components.ex</.pp_typography>
              inputs do: no new form abstraction to learn.
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
              Buttons, forms, selection controls, navigation, and surfaces, all in one place.
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
