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
  A link styled like `PhoenixPaper.Button` for page-to-page navigation CTAs.

  `pp_button` always renders a `<button>` (see phoenix_paper's AGENTS.md,
  "Conditional root tag: link vs. static element" -- that dual-tag pattern is
  only implemented for `ListItem`), so a real navigation link reuses its
  visual language here instead of nesting a `<button>` inside an `<a>`.
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
end
