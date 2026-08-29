defmodule PhoenixPaperWebsiteWeb.DocsComponents do
  @moduledoc """
  Small presentational building blocks shared by the showcase pages
  (section headers, the bordered demo canvas, a plain-text code block, and a
  link styled like `PhoenixPaper.Button`) -- not part of PhoenixPaper itself.
  """
  use Phoenix.Component

  import PhoenixPaper.Stack, only: [pp_stack: 1]
  import PhoenixPaper.Chip, only: [pp_chip: 1]
  import PhoenixPaper.Paper, only: [pp_paper: 1]

  attr :eyebrow, :string, default: nil
  attr :title, :string, required: true
  attr :description, :string, default: nil

  attr :live_component, :boolean,
    default: false,
    doc:
      "marks the component as a Phoenix.LiveComponent (stateful, needs phx-target={@myself}) instead of a stateless function component -- renders a badge next to the title"

  attr :props, :list,
    default: [],
    doc: "list of {name, description} tuples, rendered as an options table"

  attr :code, :string,
    default: nil,
    doc: "the HEEx snippet that produced the demo, rendered behind a Show code toggle"

  slot :inner_block, required: true

  @doc """
  A titled page section used to group related component demos, with an
  optional options table and an optional toggleable code snippet -- mirrors
  phoenix_paper's own `dev.exs` catalog's `demo_section/1` (title,
  description, live example, options, "Show code").
  """
  def section(assigns) do
    ~H"""
    <section class="mb-16">
      <p :if={@eyebrow} class="mb-1 text-xs font-medium uppercase tracking-wide text-pp-primary">
        {@eyebrow}
      </p>
      <div class="mb-2 flex items-center gap-2">
        <h2 class="text-2xl font-semibold tracking-tight">{@title}</h2>
        <.pp_chip
          :if={@live_component}
          size="small"
          color="primary"
          title="A Phoenix.LiveComponent -- stateful, needs phx-target={@myself} -- not a stateless function component"
        >
          LiveComponent
        </.pp_chip>
      </div>
      <p :if={@description} class="mb-6 max-w-2xl text-sm text-pp-on-surface/70">
        {@description}
      </p>
      {render_slot(@inner_block)}
      <.pp_paper :if={@props != []} elevation={0} class="mt-6 border border-pp-outline/15 p-6">
        <h3 class="mb-3 text-xs font-semibold uppercase tracking-wide text-pp-on-surface/60">
          Options
        </h3>
        <dl class="grid grid-cols-1 gap-x-4 gap-y-2 sm:grid-cols-[11rem_1fr]">
          <div :for={{name, desc} <- @props} class="contents">
            <dt class="font-mono text-xs text-pp-primary">{name}</dt>
            <dd class="mb-2 text-xs text-pp-on-surface/70 sm:mb-0">{desc}</dd>
          </div>
        </dl>
      </.pp_paper>
      <.demo_code :if={@code} id={slug(@title)} text={@code} />
    </section>
    """
  end

  defp slug(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end

  attr :id, :string, required: true
  attr :text, :string, required: true

  @doc """
  A "Show code" / "Hide code" toggle revealing a `<.code>` block -- pure CSS,
  a hidden checkbox plus a `peer-checked:` label, same mechanism as
  `PhoenixPaper.Drawer`/`PhoenixPaper.Accordion` and the same pattern
  `dev.exs`'s own catalog page uses for its code panels.
  """
  def demo_code(assigns) do
    ~H"""
    <div class="mt-4">
      <input type="checkbox" id={"#{@id}-code-toggle"} class="peer sr-only" />
      <label
        for={"#{@id}-code-toggle"}
        class="inline-flex cursor-pointer items-center gap-1.5 rounded-full border border-pp-outline px-3 py-1 text-xs font-medium text-pp-on-surface transition-colors hover:bg-pp-on-surface/10 peer-checked:[&>.pp-show-code]:hidden peer-checked:[&>.pp-hide-code]:inline"
      >
        <span class="pp-show-code">▸ Show code</span>
        <span class="pp-hide-code hidden">▾ Hide code</span>
      </label>
      <div class="hidden peer-checked:mt-3 peer-checked:block">
        <.code text={@text} />
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :class, :any, default: nil
  slot :inner_block, required: true

  @doc """
  A labeled sub-group inside a section, for a single component's variants.

  The demo canvas itself is a `PhoenixPaper.Stack` (`direction="row"`,
  wrapping) -- every demo box on every component page is a live `pp_stack`.
  """
  def demo_group(assigns) do
    ~H"""
    <div class="mb-8">
      <h3 class="mb-3 text-sm font-medium text-pp-on-surface/60">{@label}</h3>
      <.pp_stack
        direction="row"
        spacing={:md}
        wrap
        class={[
          "items-center rounded-xl border border-pp-outline/15 bg-pp-surface-variant/30 p-6",
          @class
        ]}
      >
        {render_slot(@inner_block)}
      </.pp_stack>
    </div>
    """
  end

  attr :text, :string, required: true

  @doc """
  A syntax-highlighted code block for shell/CSS/config/usage snippets.

  Takes the snippet as a `text` attribute (a plain Elixir string), not slot
  content -- a snippet showing HEEx or a `{...}` tuple literal, typed as raw
  slot content, would otherwise be parsed as actual template syntax by the
  HEEx compiler rather than displayed as text. A string value interpolated
  via `{@text}` is just data: Phoenix.HTML escapes it safely no matter what
  characters it contains.

  Highlighting is applied client-side by highlight.js's "elixir" grammar
  (not "xml"/"html" -- `<.pp_button>`'s leading dot isn't valid XML, so that
  grammar silently colors nothing) via the ".Highlight" colocated hook below.
  `phx-update="ignore"` keeps LiveView from ever re-patching this subtree:
  without it, the first connected-mount diff (computed from the server's
  plain, unhighlighted HTML, since the server has no idea the client already
  highlighted it) would wipe the highlighting back out a moment after it
  appeared.
  """
  def code(assigns) do
    ~H"""
    <pre
      id={"code-#{:erlang.phash2(@text)}"}
      phx-update="ignore"
      phx-hook=".Highlight"
      class="overflow-hidden rounded-lg border border-pp-outline/15 text-sm leading-relaxed"
    ><code class="language-elixir">{@text}</code></pre>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".Highlight">
      export default {
        mounted() {
          window.hljs?.highlightElement(this.el.querySelector("code"))
        }
      }
    </script>
    """
  end

  attr :href, :string, required: true
  attr :variant, :string, default: "raised", values: ~w(raised outlined flat)
  attr :color, :string, default: "primary", values: ~w(primary surface)
  attr :class, :any, default: nil
  slot :inner_block, required: true

  @doc """
  A link styled for the landing page's page-to-page navigation CTAs.

  Since phoenix_paper 0.2.0 `pp_button` has a link mode (`href`/`navigate`/
  `patch` render an `<a>`), so a plain navigation button no longer needs a
  local reimplementation -- but this keeps its own `raised`/`outlined`/
  `flat` + `surface` palette, tuned for the hero and the closing CTA band,
  which don't map onto `pp_button`'s brand-color variants.
  """
  def link_button(assigns) do
    ~H"""
    <.link
      navigate={@href}
      class={[
        "inline-flex items-center justify-center gap-2 rounded-full px-6 py-2.5 text-sm font-medium tracking-wide uppercase transition-[box-shadow,background-color,color,border-color] duration-150 ease-out",
        variant_classes(@variant, @color),
        @class
      ]}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  defp variant_classes("raised", "primary"),
    do: "bg-pp-primary text-pp-on-primary pp-elevation-2 hover:pp-elevation-4"

  defp variant_classes("outlined", "primary"),
    do: "border border-pp-primary text-pp-primary hover:bg-pp-primary/10"

  defp variant_classes("flat", "surface"),
    do: "bg-pp-surface text-pp-primary hover:bg-pp-surface/90 pp-elevation-1"

  attr :class, :any, default: nil

  @doc """
  The PhoenixPaper bird mark -- inlined (not an `<img src>`) so `currentColor`
  picks up whatever text color class is passed in `class`, the same way
  `pp_icon` themes with the surrounding text color. Path data copied from
  `priv/static/images/logo/phoenixpaper-mark.svg`, the source of truth --
  update both if the mark ever changes.
  """
  def logo_mark(assigns) do
    ~H"""
    <svg viewBox="0 0 64 64" fill="none" role="img" aria-label="PhoenixPaper" class={@class}>
      <path
        d="M13 21c1-6 7-10 13-9 6 1 10 6 9 12-1 6-5 10-9 15-3 4-5 9-6 15-4-5-6-11-6-18 0-6 1-11-1-15Z M13 18l-7 4 7 3z M23.8 20a1.8 1.8 0 1 0-3.6 0 1.8 1.8 0 1 0 3.6 0z"
        fill="currentColor"
        fill-rule="evenodd"
      />
      <path
        d="M34 24c8 0 16-4 22-12"
        fill="none"
        stroke="currentColor"
        stroke-width="4.6"
        stroke-linecap="round"
      />
      <path
        d="M35 32c9 1 17-3 23-10"
        fill="none"
        stroke="currentColor"
        stroke-width="4.6"
        stroke-linecap="round"
      />
      <path
        d="M32 41c9 1 16-2 21-9"
        fill="none"
        stroke="currentColor"
        stroke-width="4.2"
        stroke-linecap="round"
      />
      <path
        d="M22 48c6 2 10 6 12 12"
        fill="none"
        stroke="currentColor"
        stroke-width="4"
        stroke-linecap="round"
      />
    </svg>
    """
  end

  attr :class, :any, default: nil

  @doc """
  A big, floating, gradient-filled version of `logo_mark/1` for the landing
  hero -- same path data, but filled with `url(#pp-hero-gradient)` instead
  of `currentColor`, so it reads live off the current
  `--color-pp-primary`/`--color-pp-secondary`/`--color-pp-tertiary` tokens
  rather than a single text color. Picking a new accent/secondary/tertiary
  in `PhoenixPaperWebsiteWeb.ThemePicker` repaints it instantly, no JS of
  its own -- an inline `<svg>`'s `stop-color` resolves CSS custom
  properties from the page same as any other computed style, same reason
  `logo_mark/1` itself is inlined rather than an `<img src>`. The float/glow
  animation lives in `assets/css/app.css`'s `.pp-hero-mark` utility.
  """
  def hero_mark(assigns) do
    ~H"""
    <svg
      viewBox="0 0 64 64"
      fill="none"
      role="img"
      aria-hidden="true"
      class={["pp-hero-mark", @class]}
    >
      <defs>
        <linearGradient
          id="pp-hero-gradient"
          x1="4"
          y1="6"
          x2="46"
          y2="60"
          gradientUnits="userSpaceOnUse"
        >
          <stop offset="0%" stop-color="var(--color-pp-primary)" />
          <stop offset="55%" stop-color="var(--color-pp-secondary)" />
          <stop offset="100%" stop-color="var(--color-pp-tertiary)" />
        </linearGradient>
      </defs>
      <path
        d="M13 21c1-6 7-10 13-9 6 1 10 6 9 12-1 6-5 10-9 15-3 4-5 9-6 15-4-5-6-11-6-18 0-6 1-11-1-15Z M13 18l-7 4 7 3z M23.8 20a1.8 1.8 0 1 0-3.6 0 1.8 1.8 0 1 0 3.6 0z"
        fill="url(#pp-hero-gradient)"
        fill-rule="evenodd"
      />
      <path
        d="M34 24c8 0 16-4 22-12"
        fill="none"
        stroke="url(#pp-hero-gradient)"
        stroke-width="4.6"
        stroke-linecap="round"
      />
      <path
        d="M35 32c9 1 17-3 23-10"
        fill="none"
        stroke="url(#pp-hero-gradient)"
        stroke-width="4.6"
        stroke-linecap="round"
      />
      <path
        d="M32 41c9 1 16-2 21-9"
        fill="none"
        stroke="url(#pp-hero-gradient)"
        stroke-width="4.2"
        stroke-linecap="round"
      />
      <path
        d="M22 48c6 2 10 6 12 12"
        fill="none"
        stroke="url(#pp-hero-gradient)"
        stroke-width="4"
        stroke-linecap="round"
      />
    </svg>
    """
  end

  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :class, :any, default: nil

  @doc """
  The full PhoenixPaper wordmark -- `logo_mark/1` plus "Phoenix" (on-surface
  text) + "Paper" (primary) set as one word, no gap. Used anywhere the brand
  needs to read as a lockup rather than just the bare mark (the sidebar
  header, the landing page hero eyebrow).
  """
  def logo_lockup(assigns) do
    ~H"""
    <span class={["inline-flex items-center", gap_classes(@size), @class]}>
      <.logo_mark class={["shrink-0 text-pp-primary", mark_size_classes(@size)]} />
      <span class={text_classes(@size)}>
        <span class="text-pp-on-surface">Phoenix</span><span class="text-pp-primary">Paper</span>
      </span>
    </span>
    """
  end

  defp gap_classes("sm"), do: "gap-1.5"
  defp gap_classes("md"), do: "gap-2"
  defp gap_classes("lg"), do: "gap-2.5"

  defp mark_size_classes("sm"), do: "size-4"
  defp mark_size_classes("md"), do: "size-6"
  defp mark_size_classes("lg"), do: "size-8"

  defp text_classes("sm"), do: "text-xs font-medium uppercase tracking-wide"
  defp text_classes("md"), do: "text-base font-semibold tracking-tight"
  defp text_classes("lg"), do: "text-2xl font-semibold tracking-tight"
end
