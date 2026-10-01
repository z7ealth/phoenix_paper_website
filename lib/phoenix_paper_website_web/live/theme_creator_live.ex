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
    {:noreply, update(socket, :palettes, &ThemeTokens.random/1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, :palettes, ThemeTokens.defaults())}
  end

  def handle_event("noop", _params, socket), do: {:noreply, socket}

  def render(assigns) do
    assigns = assign(assigns, :palette, assigns.palettes[String.to_existing_atom(assigns.mode)])

    ~H"""
    <Layouts.app flash={@flash} current_page={:theme_creator}>
      <.pp_container max_width="xl">
        <.page_header eyebrow="Guide" title="Theme Creator">
          Pick a color for every PhoenixPaper token, for light and dark, and watch real
          components repaint. When it looks right, copy the CSS into your app.css. See the
          <.link navigate={~p"/theming"} class="text-pp-primary hover:underline">Theming</.link>
          guide for how the tokens work.
        </.page_header>

        <.pp_grid spacing={:lg} class="mb-16">
          <.pp_grid_item span={12} md={5}>
            <.pp_card id="theme-editor">
              <.pp_stack spacing={:md}>
                <.pp_stack direction="row" spacing={:sm} class="items-center justify-between">
                  <.pp_button_group>
                    <.pp_toggle_button
                      :for={mode <- ~w(light dark)}
                      id={"mode-#{mode}"}
                      pressed={@mode == mode}
                      phx-click="set_mode"
                      phx-value-mode={mode}
                    >
                      <.pp_icon
                        name={if(mode == "light", do: "hero-sun", else: "hero-moon")}
                        size="sm"
                      />
                      {String.capitalize(mode)}
                    </.pp_toggle_button>
                  </.pp_button_group>
                  <.pp_stack direction="row" spacing={:xs}>
                    <.pp_button id="theme-random" variant="outlined" size="small" phx-click="random">
                      <:start_icon><.pp_icon name="hero-sparkles" size="sm" /></:start_icon>
                      Random
                    </.pp_button>
                    <.pp_button id="theme-reset" variant="text" size="small" phx-click="reset">
                      Reset
                    </.pp_button>
                  </.pp_stack>
                </.pp_stack>

                <.pp_typography variant="caption">
                  Editing the {@mode} palette. Random picks new brand hues for both.
                </.pp_typography>

                <form id="theme-tokens-form" phx-change="set_tokens">
                  <.pp_stack spacing={:md}>
                    <div :for={{group, names} <- @groups}>
                      <.pp_typography variant="overline" color="muted" class="mb-2">
                        {group}
                      </.pp_typography>
                      <.pp_stack spacing={:xs}>
                        <.token_row
                          :for={name <- names}
                          name={name}
                          palette={@palette}
                          mode={@mode}
                        />
                      </.pp_stack>
                    </div>
                  </.pp_stack>
                </form>
              </.pp_stack>
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12} md={7}>
            <.preview palette={@palette} mode={@mode} />
          </.pp_grid_item>
        </.pp_grid>

        <.section
          title="Your CSS"
          description={
            ~S|Paste this into assets/css/app.css after the phoenix_paper import. It sets every token for light (:root) and dark ([data-theme="dark"]); delete any line you want to keep at the library default.|
          }
        >
          <.code text={ThemeTokens.css(@palettes)} language="css" />
        </.section>
      </.pp_container>
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
        class="size-8 shrink-0 cursor-pointer rounded-md border border-pp-outline/30 bg-transparent p-0.5"
      />
      <span class="min-w-0 flex-1">
        <.pp_typography variant="code" class="block truncate">{@name}</.pp_typography>
        <.pp_typography variant="caption">{@palette[@name]}</.pp_typography>
      </span>
      <.pp_chip
        :if={@ratio}
        size="small"
        variant="outlined"
        color={rating_color(@rating)}
        title={rating_title(@rating)}
        data-contrast={@name}
      >
        {@ratio}:1
      </.pp_chip>
    </label>
    """
  end

  defp rating_color(:aaa), do: "success"
  defp rating_color(:aa), do: "success"
  defp rating_color(:large), do: "warning"
  defp rating_color(:fail), do: "error"

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
      class="rounded-2xl border border-pp-outline/20 bg-pp-surface p-6 text-pp-on-surface"
    >
      <.pp_stack spacing={:lg}>
        <.pp_stack direction="row" spacing={:sm} wrap class="items-center">
          <.pp_button>Primary</.pp_button>
          <.pp_button color="secondary">Secondary</.pp_button>
          <.pp_button color="accent">Accent</.pp_button>
          <.pp_button color="error" variant="outlined">Error</.pp_button>
          <.pp_button variant="text">Text</.pp_button>
          <.pp_fab size="sm" color="secondary"><.pp_icon name="hero-plus" /></.pp_fab>
        </.pp_stack>

        <.pp_grid spacing={:md}>
          <.pp_grid_item span={12}>
            <.pp_card class="h-full">
              <:title>
                <.pp_stack direction="row" spacing={:sm} class="items-center">
                  <.pp_avatar color="primary">AL</.pp_avatar>
                  <span>Ada Lovelace</span>
                </.pp_stack>
              </:title>
              <.pp_typography variant="body2" color="muted">
                Surfaces get lighter with elevation in dark mode.
              </.pp_typography>
              <.pp_stack direction="row" spacing={:xs} wrap class="mt-3">
                <.pp_chip color="primary">Elixir</.pp_chip>
                <.pp_chip color="secondary">Phoenix</.pp_chip>
                <.pp_chip color="accent" variant="outlined">LiveView</.pp_chip>
              </.pp_stack>
              <:actions>
                <.pp_button variant="text" color="secondary">Message</.pp_button>
                <.pp_button>Follow</.pp_button>
              </:actions>
            </.pp_card>
          </.pp_grid_item>

          <.pp_grid_item span={12}>
            <.pp_card class="h-full">
              <.pp_stack spacing={:md}>
                <.pp_input name="preview_email" label="Email" value="ada@example.com" />
                <.pp_stack direction="row" spacing={:md} wrap>
                  <.pp_switch name="preview_switch" label="Notifications" checked />
                  <.pp_checkbox name="preview_check" label="Remember me" checked />
                </.pp_stack>
                <.pp_slider name="preview_slider" label="Volume" value={60} />
                <.pp_progress value={72} />
              </.pp_stack>
            </.pp_card>
          </.pp_grid_item>
        </.pp_grid>

        <.pp_stack spacing={:sm}>
          <.pp_alert severity="success">Your changes were saved.</.pp_alert>
          <.pp_alert severity="info" variant="outlined">A new version is available.</.pp_alert>
          <.pp_alert severity="warning" variant="filled">Your trial ends in 3 days.</.pp_alert>
          <.pp_alert severity="error">Couldn't reach the server.</.pp_alert>
        </.pp_stack>

        <.pp_stack direction="row" spacing={:md} wrap class="items-center justify-between">
          <.pp_pagination page={3} count={8} on_change="noop" />
          <.pp_stack direction="row" spacing={:xs}>
            <.pp_chip color="success" size="small">Completed</.pp_chip>
            <.pp_chip color="warning" size="small">Pending</.pp_chip>
            <.pp_chip color="info" size="small">Draft</.pp_chip>
          </.pp_stack>
        </.pp_stack>
      </.pp_stack>
    </div>
    """
  end
end
