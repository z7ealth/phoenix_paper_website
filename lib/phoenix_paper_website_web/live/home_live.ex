defmodule PhoenixPaperWebsiteWeb.HomeLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias PhoenixPaperWebsiteWeb.PaperBird

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Material Design for Phoenix")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.landing flash={@flash}>
      <%!-- Easter egg: click the hero bird five times. --%>
      <PaperBird.game />
      <div class="mx-auto w-full px-4 max-w-screen-lg py-20">
        <div class="relative mb-14">
          <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden">
            <div class="pp-hero-blob pp-hero-blob-1 absolute -top-24 -left-16 size-72 bg-pp-primary" />
            <div class="pp-hero-blob pp-hero-blob-2 absolute top-0 -right-10 size-64 bg-pp-secondary" />
            <div class="pp-hero-blob pp-hero-blob-3 absolute -bottom-24 left-1/3 size-56 bg-pp-tertiary" />
          </div>

          <div class="flex flex-col items-start gap-10 lg:flex-row lg:items-center lg:justify-between">
            <div class="max-w-2xl">
              <div class="mb-4 flex items-center gap-3">
                <.pp_typography variant="display-medium" tag="h1" emphasized>
                  Material Design, built for Phoenix.
                </.pp_typography>
                <%!-- Mobile trigger: a small bird next to the headline (the big one
                      is lg-only). --%>
                <PaperBird.hero_egg
                  id="hero-egg-mobile"
                  class="shrink-0 touch-manipulation select-none lg:hidden"
                >
                  <.hero_mark id="pp-hero-mobile" class="size-14 sm:size-20" />
                </PaperBird.hero_egg>
              </div>
              <.pp_typography
                variant="title-large"
                tag="p"
                color="on-surface-variant"
                class="mb-8 max-w-2xl"
              >
                An effort to bring
                <.pp_typography
                  tag="span"
                  variant="title-large"
                  color="on-surface"
                  class="whitespace-nowrap"
                >
                  Material Design 3
                </.pp_typography>
                to Phoenix and Phoenix LiveView. Inspired by
                <.pp_typography
                  tag="span"
                  variant="title-large"
                  color="on-surface"
                  class="whitespace-nowrap"
                >
                  ember-paper
                </.pp_typography>
                for Ember.js, styled entirely with Tailwind CSS, and shipped as a plain hex
                dependency your app already knows how to install.
              </.pp_typography>

              <div class="flex flex-row gap-4 flex-wrap">
                <.pp_button size="md" navigate={~p"/components"}>See Components</.pp_button>
                <.pp_button size="md" variant="outlined" navigate={~p"/getting-started"}>
                  Get Started
                </.pp_button>
              </div>
            </div>

            <%!-- Desktop trigger; below lg, the small bird by the headline is. --%>
            <PaperBird.hero_egg class="hidden shrink-0 lg:block">
              <.hero_mark class="lg:size-56 xl:size-64" />
            </PaperBird.hero_egg>
          </div>
        </div>

        <.section
          eyebrow="Quick look"
          title="Every component, live"
          description="Click around below and try them."
        >
          <div class="flex flex-col gap-6">
            <.demo_group label="Try it">
              <.pp_button>Filled</.pp_button>
              <.pp_button variant="tonal">Tonal</.pp_button>
              <.pp_button variant="outlined">Outlined</.pp_button>
              <.pp_button variant="text">Text</.pp_button>
              <.pp_icon_button variant="tonal" icon="hero-bell" label="Notifications" />
              <.pp_fab icon="hero-sparkles" label="Create" />
            </.demo_group>

            <div class="grid grid-cols-12 gap-6">
              <div class="col-span-12 md:col-span-6">
                <.pp_card>
                  <:title>Account</:title>
                  You have no pending invoices this month.
                  <:actions>
                    <.pp_button variant="text">Dismiss</.pp_button>
                    <.pp_button variant="text" color="primary">Review</.pp_button>
                  </:actions>
                </.pp_card>
              </div>

              <div class="col-span-12 md:col-span-6">
                <div class="flex flex-col gap-4 justify-center rounded-pp-md border border-pp-outline-variant bg-pp-surface-container-lowest p-6">
                  <.pp_switch name="notifications" label="Notifications" checked />
                  <.pp_checkbox name="updates" label="Product updates" checked />
                  <.pp_slider name="home-volume" label="Volume" value={60} />
                </div>
              </div>
            </div>
          </div>
        </.section>

        <div class="grid grid-cols-12 gap-6 mb-16">
          <div class="col-span-12 md:col-span-6">
            <.pp_card class="h-full">
              <.pp_avatar class="mb-3"><.pp_icon name="hero-swatch" /></.pp_avatar>
              <:title>Tailwind-native theming</:title>
              Colors are Tailwind v4 theme tokens, namespaced
              <.pp_typography variant="code">pp-</.pp_typography>
              so they never collide with daisyUI; this site ships both, side by side. Try the
              theme picker in the top right corner: color mode, the brand colors and the
              surface tone are all live.
            </.pp_card>
          </div>

          <div class="col-span-12 md:col-span-6">
            <.pp_card class="h-full">
              <.pp_avatar class="mb-3"><.pp_icon name="hero-bolt" /></.pp_avatar>
              <:title>CSS-only interactions</:title>
              Checkboxes, radios, ratings, accordions, the navigation rail and the FAB menu are all
              pure CSS:
              <.pp_typography variant="code">peer-checked:</.pp_typography>
              and
              <.pp_typography variant="code">has-[:checked]:</.pp_typography>
              tricks, no client JS shipped for them at all.
            </.pp_card>
          </div>

          <div class="col-span-12 md:col-span-6">
            <.pp_card class="h-full">
              <.pp_avatar class="mb-3">
                <.pp_icon name="hero-shield-check" />
              </.pp_avatar>
              <:title>The paperize escape hatch</:title>
              Every component accepts a
              <.pp_typography variant="code">paperize</.pp_typography>
              attribute. Turn it off and every built-in class disappears; only your own
              <.pp_typography variant="code">class</.pp_typography>
              renders, no fighting the library's CSS.
            </.pp_card>
          </div>

          <div class="col-span-12 md:col-span-6">
            <.pp_card class="h-full">
              <.pp_avatar class="mb-3">
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
          </div>
        </div>

        <div class="flex flex-row gap-4 flex-wrap items-center justify-between rounded-pp-xl bg-pp-primary px-8 py-10 text-pp-on-primary">
          <div>
            <.pp_typography variant="headline-small" tag="h2">Ready to look around?</.pp_typography>
            <.pp_typography variant="body-large">
              Buttons, forms, selection controls, navigation, and surfaces, all in one place.
            </.pp_typography>
          </div>
          <.pp_button variant="elevated" size="md" navigate={~p"/components"} class="shrink-0">
            View all components
          </.pp_button>
        </div>
      </div>
    </Layouts.landing>
    """
  end
end
