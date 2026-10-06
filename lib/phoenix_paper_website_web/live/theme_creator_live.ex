defmodule PhoenixPaperWebsiteWeb.ThemeCreatorLive do
  @moduledoc """
  The theme creator: edit every `--color-pp-*` token for light and dark, see
  real PhoenixPaper components repaint live, and copy the result as an
  `app.css` block (see `PhoenixPaperWebsiteWeb.ThemeTokens`).

  The preview is scoped: its container carries the edited tokens as inline
  CSS custom properties (plus `data-theme` for the dark-mode surface tint),
  so the components inside resolve them while the rest of the site keeps its
  own theme.
  """
  use PhoenixPaperWebsiteWeb, :live_view

  alias PhoenixPaperWebsiteWeb.ThemeTokens

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Theme Creator")
     |> assign(:mode, "light")
     |> assign(:palettes, ThemeTokens.defaults())
     |> assign(:seed, "#6750a4")
     |> assign(:variant, "tonal_spot")
     |> assign(:groups, ThemeTokens.groups())}
  end

  def handle_event("set_mode", %{"mode" => mode}, socket) when mode in ~w(light dark) do
    {:noreply, assign(socket, :mode, mode)}
  end

  def handle_event("set_tokens", %{"tokens" => tokens}, socket) do
    mode = String.to_existing_atom(socket.assigns.mode)

    valid =
      for {name, hex} <- tokens,
          name in ThemeTokens.names(),
          ThemeTokens.hex?(hex),
          into: %{},
          do: {name, String.downcase(hex)}

    {:noreply, update(socket, :palettes, &Map.update!(&1, mode, fn p -> Map.merge(p, valid) end))}
  end

  def handle_event("random", _params, socket) do
    seed = ThemeTokens.random_seed()
    {:noreply, generate(socket, seed, socket.assigns.variant)}
  end

  def handle_event("generate", %{"seed" => seed, "variant" => variant}, socket) do
    seed = if ThemeTokens.hex?(seed), do: String.downcase(seed), else: socket.assigns.seed

    variant =
      if variant in Enum.map(ThemeTokens.variants(), &to_string/1),
        do: variant,
        else: "tonal_spot"

    {:noreply, generate(socket, seed, variant)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, :palettes, ThemeTokens.defaults())}
  end

  defp generate(socket, seed, variant) do
    socket
    |> assign(seed: seed, variant: variant)
    |> assign(:palettes, ThemeTokens.generate(seed, String.to_existing_atom(variant)))
  end

  def render(assigns) do
    assigns = assign(assigns, :palette, assigns.palettes[String.to_existing_atom(assigns.mode)])

    ~H"""
    <Layouts.app flash={@flash} current_page={:theme_creator}>
      <div class="mx-auto w-full px-4 max-w-screen-xl">
        <.page_header eyebrow="Guide" title="Theme Creator">
          Pick a color for every PhoenixPaper token, for light and dark, and watch real
          components repaint. When it looks right, copy the CSS into your app.css. See the
          <.link navigate={~p"/theming"} class="text-pp-primary hover:underline">Theming</.link>
          guide for how the tokens work.
        </.page_header>

        <div class="grid grid-cols-12 gap-6 mb-16">
          <div class="col-span-12 md:col-span-5">
            <.pp_card id="theme-editor">
              <div class="flex flex-col gap-4">
                <div class="flex flex-row gap-2 items-center justify-between">
                  <.pp_button_group variant="connected">
                    <.pp_button
                      :for={mode <- ~w(light dark)}
                      id={"mode-#{mode}"}
                      variant="outlined"
                      size="xs"
                      selected={@mode == mode}
                      phx-click="set_mode"
                      phx-value-mode={mode}
                    >
                      <:start_icon>
                        <.pp_icon
                          name={if(mode == "light", do: "hero-sun", else: "hero-moon")}
                          size="sm"
                        />
                      </:start_icon>
                      {String.capitalize(mode)}
                    </.pp_button>
                  </.pp_button_group>
                  <div class="flex flex-row gap-1">
                    <.pp_button id="theme-random" variant="tonal" size="xs" phx-click="random">
                      <:start_icon><.pp_icon name="hero-sparkles" size="sm" /></:start_icon>
                      Random
                    </.pp_button>
                    <.pp_button id="theme-reset" variant="text" size="xs" phx-click="reset">
                      Reset
                    </.pp_button>
                  </div>
                </div>

                <form id="theme-seed-form" phx-change="generate" phx-submit="generate">
                  <.pp_typography variant="label-small" color="on-surface-variant" class="mb-2">
                    From a seed color
                  </.pp_typography>
                  <div class="flex items-center gap-3">
                    <input
                      type="color"
                      id="theme-seed"
                      name="seed"
                      value={@seed}
                      class="size-10 shrink-0 cursor-pointer rounded-pp-md border border-pp-outline-variant bg-transparent p-0.5"
                    />
                    <.pp_select
                      id="theme-variant"
                      name="variant"
                      label="Scheme variant"
                      value={@variant}
                      options={for v <- ThemeTokens.variants(), do: {variant_label(v), to_string(v)}}
                      class="flex-1"
                    />
                  </div>
                </form>

                <.pp_typography variant="body-small">
                  The seed generates every role for light and dark with phoenix_paper's MD3 color
                  science (the same as mix phoenix_paper.gen.theme). Then fine-tune any token
                  below; you're editing the {@mode} palette.
                </.pp_typography>

                <form id="theme-tokens-form" phx-change="set_tokens">
                  <div class="flex flex-col gap-4">
                    <div :for={{group, names} <- @groups}>
                      <.pp_typography variant="label-small" color="on-surface-variant" class="mb-2">
                        {group}
                      </.pp_typography>
                      <div class="flex flex-col gap-1">
                        <.token_row
                          :for={name <- names}
                          name={name}
                          palette={@palette}
                          mode={@mode}
                        />
                      </div>
                    </div>
                  </div>
                </form>
              </div>
            </.pp_card>
          </div>

          <div class="col-span-12 md:col-span-7">
            <.preview palette={@palette} mode={@mode} />
          </div>
        </div>

        <.section
          title="Your CSS"
          description={
            ~S|Paste this into assets/css/app.css after the phoenix_paper import. It sets every token for light (:root) and dark ([data-theme="dark"]); delete any line you want to keep at the library default.|
          }
        >
          <.code text={ThemeTokens.css(@palettes)} language="css" />
        </.section>
      </div>
    </Layouts.app>
    """
  end

  attr :name, :string, required: true
  attr :palette, :map, required: true
  attr :mode, :string, required: true

  # One token: a native color picker (the one control PhoenixPaper doesn't
  # have), its name and hex, and for an on-* token its contrast against the
  # color it's drawn on.
  defp token_row(assigns) do
    pair = ThemeTokens.pair_of(assigns.name)

    ratio =
      pair && ThemeTokens.contrast(assigns.palette[assigns.name], assigns.palette[pair])

    assigns = assign(assigns, ratio: ratio, rating: ratio && ThemeTokens.rating(ratio))

    ~H"""
    <label class="flex cursor-pointer items-center gap-3">
      <input
        type="color"
        id={"token-#{@mode}-#{@name}"}
        name={"tokens[#{@name}]"}
        value={@palette[@name]}
        class="size-8 shrink-0 cursor-pointer rounded-pp-sm border border-pp-outline-variant bg-transparent p-0.5"
      />
      <span class="min-w-0 flex-1">
        <.pp_typography variant="code" class="block truncate">{@name}</.pp_typography>
        <.pp_typography variant="body-small">{@palette[@name]}</.pp_typography>
      </span>
      <span
        :if={@ratio}
        title={rating_title(@rating)}
        data-contrast={@name}
        class={["shrink-0 rounded-pp-full px-2 py-0.5", role_classes(rating_color(@rating))]}
      >
        <.pp_typography variant="label-small">{@ratio}:1</.pp_typography>
      </span>
    </label>
    """
  end

  defp variant_label(variant),
    do: variant |> to_string() |> String.replace("_", " ") |> String.capitalize()

  defp rating_color(:aaa), do: "primary-container"
  defp rating_color(:aa), do: "secondary-container"
  defp rating_color(:large), do: "tertiary-container"
  defp rating_color(:fail), do: "error-container"

  defp rating_title(:aaa), do: "AAA: readable at any size"
  defp rating_title(:aa), do: "AA: fine for body text"
  defp rating_title(:large), do: "Large text and icons only (below 4.5:1)"
  defp rating_title(:fail), do: "Below 3:1: hard to read"

  attr :palette, :map, required: true
  attr :mode, :string, required: true

  # Real components, inside a container carrying the edited tokens.
  defp preview(assigns) do
    ~H"""
    <div
      id="theme-preview"
      data-theme={@mode}
      style={ThemeTokens.style(@palette)}
      class="rounded-pp-xl border border-pp-outline-variant bg-pp-surface p-6 text-pp-on-surface"
    >
      <div class="flex flex-col gap-6">
        <div class="flex flex-row gap-2 flex-wrap items-center">
          <.pp_button>Filled</.pp_button>
          <.pp_button variant="tonal">Tonal</.pp_button>
          <.pp_button variant="elevated">Elevated</.pp_button>
          <.pp_button variant="outlined">Outlined</.pp_button>
          <.pp_button variant="text">Text</.pp_button>
          <.pp_button color="tertiary">Tertiary</.pp_button>
          <.pp_icon_button variant="tonal" icon="hero-heart" label="Like" />
          <.pp_fab icon="hero-pencil" label="Compose" />
        </div>

        <div class="grid grid-cols-12 gap-4">
          <div class="col-span-12 md:col-span-6">
            <.pp_card class="h-full">
              <:title>
                <div class="flex flex-row gap-2 items-center">
                  <span class="inline-flex shrink-0 select-none items-center justify-center rounded-pp-full size-10 pp-title-medium bg-pp-primary-container text-pp-on-primary-container">AL</span>
                  <span>Ada Lovelace</span>
                </div>
              </:title>
              <:subhead>Surface containers, tonal and filled</:subhead>
              <div class="flex flex-row gap-1 flex-wrap mt-3">
                <.pp_chip variant="filter" selected>Elixir</.pp_chip>
                <.pp_chip variant="filter" selected={false}>Phoenix</.pp_chip>
                <.pp_chip variant="assist">
                  <:icon><.pp_icon name="hero-calendar" size="sm" /></:icon>
                  LiveView
                </.pp_chip>
              </div>
              <:actions>
                <.pp_button variant="text">Message</.pp_button>
                <.pp_button variant="tonal">Follow</.pp_button>
              </:actions>
            </.pp_card>
          </div>

          <div class="col-span-12 md:col-span-6">
            <.pp_card variant="filled" class="h-full">
              <div class="flex flex-col gap-4">
                <.pp_text_field name="preview_email" label="Email" value="ada@example.com" />
                <div class="flex flex-row gap-4 flex-wrap items-center">
                  <.pp_switch name="preview_switch" label="Notifications" checked />
                  <.pp_checkbox name="preview_check" label="Remember me" checked />
                </div>
                <.pp_slider name="preview_slider" label="Volume" value={60} />
                <.pp_progress value={72} />
              </div>
            </.pp_card>
          </div>
        </div>

        <.pp_snackbar positioned={false}>
          Your changes were saved.
          <:action><.pp_button variant="text">Undo</.pp_button></:action>
        </.pp_snackbar>

        <div class="flex flex-row gap-4 flex-wrap items-center justify-between">
          <.pp_button_group variant="connected">
            <.pp_button
              :for={v <- ~w(Day Week Month)}
              variant="tonal"
              size="sm"
              selected={v == "Week"}
            >
              {v}
            </.pp_button>
          </.pp_button_group>
          <div class="flex items-center gap-6">
            <.pp_badge content={3}><.pp_icon name="hero-bell" /></.pp_badge>
            <.pp_badge><.pp_icon name="hero-chat-bubble-left" /></.pp_badge>
          </div>
          <.pp_loading_indicator contained />
        </div>
      </div>
    </div>
    """
  end
end
