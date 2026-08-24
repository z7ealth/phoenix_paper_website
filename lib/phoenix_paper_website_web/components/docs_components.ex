defmodule PhoenixPaperWebsiteWeb.DocsComponents do
  @moduledoc """
  Small presentational building blocks shared by the showcase pages
  (section headers, the bordered demo canvas, a plain-text code block, and a
  link styled like `PhoenixPaper.Button`) -- not part of PhoenixPaper itself.
  """
  use Phoenix.Component

  import PhoenixPaper.Stack, only: [pp_stack: 1]

  attr :eyebrow, :string, default: nil
  attr :title, :string, required: true
  attr :description, :string, default: nil
  slot :inner_block, required: true

  @doc "A titled page section used to group related component demos."
  def section(assigns) do
    ~H"""
    <section class="mb-16">
      <p :if={@eyebrow} class="mb-1 text-xs font-medium uppercase tracking-wide text-pp-primary">
        {@eyebrow}
      </p>
      <h2 class="mb-2 text-2xl font-semibold tracking-tight">{@title}</h2>
      <p :if={@description} class="mb-6 max-w-2xl text-sm text-pp-on-surface/70">
        {@description}
      </p>
      {render_slot(@inner_block)}
    </section>
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
  A plain-text code block for shell/CSS/config/usage snippets.

  Takes the snippet as a `text` attribute (a plain Elixir string), not slot
  content -- a snippet showing HEEx or a `{...}` tuple literal, typed as raw
  slot content, would otherwise be parsed as actual template syntax by the
  HEEx compiler rather than displayed as text. A string value interpolated
  via `{@text}` is just data: Phoenix.HTML escapes it safely no matter what
  characters it contains.
  """
  def code(assigns) do
    ~H"""
    <pre class="overflow-x-auto rounded-lg border border-pp-outline/15 bg-pp-on-surface/[0.04] p-4 text-sm leading-relaxed"><code>{@text}</code></pre>
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
