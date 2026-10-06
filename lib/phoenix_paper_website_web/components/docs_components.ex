defmodule PhoenixPaperWebsiteWeb.DocsComponents do
  @moduledoc """
  Small presentational building blocks shared by the showcase pages
  (section headers, the bordered demo canvas, a plain-text code block, and a
  link styled like `PhoenixPaper.Button`) -- not part of PhoenixPaper itself.
  """
  use Phoenix.Component

  use PhoenixPaper.Components

  attr :eyebrow, :string, required: true
  attr :title, :string, required: true
  slot :inner_block, required: true, doc: "the lead paragraph"

  @doc """
  The eyebrow / title / lead paragraph block every page opens with, all
  `PhoenixPaper.Typography`.
  """
  def page_header(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 mb-12">
      <.pp_typography variant="label-small" color="primary">{@eyebrow}</.pp_typography>
      <.pp_typography variant="display-small">{@title}</.pp_typography>
      <.pp_typography variant="body-large" color="on-surface-variant" class="max-w-2xl">
        {render_slot(@inner_block)}
      </.pp_typography>
    </div>
    """
  end

  attr :eyebrow, :string, default: nil
  attr :title, :string, required: true
  attr :description, :string, default: nil

  attr :component, :boolean,
    default: true,
    doc:
      "false for a guide section (not a component): left out of the sidebar, which lists data-docs-section sections only"

  attr :live_component, :boolean,
    default: false,
    doc:
      "marks the component as a Phoenix.LiveComponent (stateful, needs phx-target={@myself}) instead of a stateless function component -- renders a badge next to the title"

  attr :props, :list,
    default: [],
    doc: "list of {name, description} tuples, rendered as an options table"

  attr :slots, :list,
    default: [],
    doc:
      "list of {name, description} tuples for the component's named slots, rendered as their own table, separate from props"

  attr :code, :string,
    default: nil,
    doc: "the HEEx snippet that produced the demo, rendered behind a Show code toggle"

  attr :api, :list,
    default: [],
    doc:
      "{Module, :function} pairs: options and slots tables generated from the library's own component metadata (types, defaults, allowed values, attr docs), so they always match the installed version"

  attr :code_language, :string,
    default: "elixir",
    doc: "highlight.js language for code (elixir, css or javascript)"

  slot :inner_block, required: true

  @doc """
  A titled page section used to group related component demos, with an
  optional options table, an optional slots table, and an optional
  toggleable code snippet -- mirrors phoenix_paper's own `dev.exs` catalog's
  `demo_section/1` (title, description, live example, options, "Show code").

  `props` and `slots` are kept as two separate tables rather than one list
  with a `:`-prefixed naming convention: a slot isn't just another attr (it
  takes rendered content, not a value), and a caller skimming the page
  shouldn't have to notice a leading colon to tell the two apart.
  """
  def section(assigns) do
    assigns = assign(assigns, :status, PhoenixPaperWebsiteWeb.Nav.status(assigns.title))

    ~H"""
    <section id={slug(@title)} data-docs-section={@component} class="mb-16 scroll-mt-20">
      <.pp_typography :if={@eyebrow} variant="label-small" color="primary">
        {@eyebrow}
      </.pp_typography>
      <div class="flex flex-row gap-2 mb-2 items-center">
        <.pp_typography variant="headline-medium">{@title}</.pp_typography>
        <.pill
          :if={@live_component}
          color="primary-container"
          title="A Phoenix.LiveComponent -- stateful, needs phx-target={@myself} -- not a stateless function component"
        >
          LiveComponent
        </.pill>
        <.status_chip status={@status} />
      </div>
      <.pp_typography
        :if={@description}
        variant="body-medium"
        color="on-surface-variant"
        class="mb-6 max-w-2xl"
      >
        {@description}
      </.pp_typography>
      {render_slot(@inner_block)}
      <.generated_api :if={@api != []} id={slug(@title)} api={@api} />
      <.api_table :if={@props != []} id={"#{slug(@title)}-options"} label="Option" rows={@props} />
      <.api_table :if={@slots != []} id={"#{slug(@title)}-slots"} label="Slot" rows={@slots} />
      <.demo_code :if={@code} id={slug(@title)} text={@code} language={@code_language} />
    </section>
    """
  end

  attr :id, :string, required: true
  attr :api, :list, required: true

  # Options/slots tables built from Phoenix.Component metadata
  # (Module.__components__/0): attr type, default, allowed values and doc.
  defp generated_api(assigns) do
    multiple? = length(assigns.api) > 1

    {attrs, slots} =
      Enum.reduce(assigns.api, {[], []}, fn {mod, fun}, {attrs, slots} ->
        meta = mod.__components__()[fun]
        prefix = if multiple?, do: "#{fun} ", else: ""

        new_attrs =
          for a <- meta.attrs, a.name not in [:rest, :class] do
            %{
              name: prefix <> to_string(a.name),
              type: attr_type(a),
              default: attr_default(a),
              doc: a.doc
            }
          end

        new_slots =
          for sl <- meta.slots do
            %{
              name: prefix <> ":" <> to_string(sl.name),
              attrs: Enum.map_join(sl.attrs, ", ", &to_string(&1.name)),
              doc: sl.doc,
              required: sl.required
            }
          end

        {attrs ++ new_attrs, slots ++ new_slots}
      end)

    assigns = assign(assigns, attrs: attrs, slots: slots)

    ~H"""
    <.pp_table_container
      :if={@attrs != []}
      id={"#{@id}-options"}
      class="mt-6"
    >
      <.pp_table>
        <.pp_table_head>
          <.pp_table_row>
            <.pp_table_cell variant="head">Option</.pp_table_cell>
            <.pp_table_cell variant="head">Type</.pp_table_cell>
            <.pp_table_cell variant="head">Default</.pp_table_cell>
            <.pp_table_cell variant="head">Description</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_head>
        <.pp_table_body>
          <.pp_table_row :for={a <- @attrs}>
            <.pp_table_cell>
              <.pp_typography variant="code">{a.name}</.pp_typography>
            </.pp_table_cell>
            <.pp_table_cell>
              <.pp_typography variant="code">{a.type}</.pp_typography>
            </.pp_table_cell>
            <.pp_table_cell>
              <.pp_typography variant="code">{a.default}</.pp_typography>
            </.pp_table_cell>
            <.pp_table_cell>{a.doc}</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_body>
      </.pp_table>
    </.pp_table_container>
    <.pp_table_container
      :if={@slots != []}
      id={"#{@id}-slots"}
      class="mt-4"
    >
      <.pp_table>
        <.pp_table_head>
          <.pp_table_row>
            <.pp_table_cell variant="head">Slot</.pp_table_cell>
            <.pp_table_cell variant="head">Attrs</.pp_table_cell>
            <.pp_table_cell variant="head">Description</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_head>
        <.pp_table_body>
          <.pp_table_row :for={sl <- @slots}>
            <.pp_table_cell>
              <.pp_typography variant="code">{sl.name}</.pp_typography>
              <.pp_typography :if={sl.required} variant="body-small" color="error">
                required
              </.pp_typography>
            </.pp_table_cell>
            <.pp_table_cell>
              <.pp_typography variant="code">{sl.attrs}</.pp_typography>
            </.pp_table_cell>
            <.pp_table_cell>{sl.doc}</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_body>
      </.pp_table>
    </.pp_table_container>
    """
  end

  defp attr_type(%{required: required} = a) do
    base =
      case a.opts[:values] do
        nil -> type_name(a.type)
        values -> values |> Enum.reject(&is_nil/1) |> Enum.map_join(" | ", &inspect/1)
      end

    if required, do: base <> " (required)", else: base
  end

  defp type_name({:struct, mod}), do: inspect(mod) |> String.replace("Phoenix.LiveView.", "")
  defp type_name(t), do: to_string(t)

  defp attr_default(a) do
    case Keyword.fetch(a.opts, :default) do
      {:ok, %Phoenix.LiveView.JS{}} -> "%JS{}"
      {:ok, value} -> inspect(value)
      :error -> ""
    end
  end

  attr :id, :string, required: true
  attr :label, :string, required: true, doc: "the name column's heading"
  attr :rows, :list, required: true, doc: "{name, description} tuples"

  # A section's Options or Slots reference, as a PhoenixPaper.Table.
  defp api_table(assigns) do
    ~H"""
    <.pp_table_container id={@id} class="mt-6">
      <.pp_table>
        <.pp_table_head>
          <.pp_table_row>
            <.pp_table_cell variant="head">{@label}</.pp_table_cell>
            <.pp_table_cell variant="head">Description</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_head>
        <.pp_table_body>
          <.pp_table_row :for={{name, desc} <- @rows}>
            <.pp_table_cell>
              <.pp_typography variant="code">{name}</.pp_typography>
            </.pp_table_cell>
            <.pp_table_cell>{desc}</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_body>
      </.pp_table>
    </.pp_table_container>
    """
  end

  attr :status, :atom, default: nil, values: [nil, :new, :updated]

  @doc """
  The "New"/"Updated" chip for a component added or changed in the latest
  release (`PhoenixPaperWebsiteWeb.Nav.status/1`), on section headers and in
  the sidebar. Renders nothing for `nil`.
  """
  def status_chip(assigns) do
    assigns = assign(assigns, :release, PhoenixPaperWebsiteWeb.Nav.release())

    ~H"""
    <.pill
      :if={@status == :new}
      color="tertiary-container"
      title={"New in v#{@release}"}
      data-pp-status="new"
    >
      New
    </.pill>
    <.pill
      :if={@status == :updated}
      color="secondary-container"
      title={"Updated in v#{@release}"}
      data-pp-status="updated"
    >
      Updated
    </.pill>
    """
  end

  attr :color, :string, required: true
  attr :rest, :global
  slot :inner_block, required: true

  # A small rounded label (MD3 chips are interactive, so status markers are a
  # container-colored span with label-small text instead).
  defp pill(assigns) do
    ~H"""
    <span
      class={["inline-flex shrink-0 rounded-pp-full px-2 py-0.5", role_classes(@color)]}
      {@rest}
    >
      <.pp_typography variant="label-small">{render_slot(@inner_block)}</.pp_typography>
    </span>
    """
  end

  @doc """
  The background/foreground pair for an MD3 color role, e.g.
  `"primary-container"` -> `"bg-pp-primary-container text-pp-on-primary-container"`.
  Literal strings so Tailwind's scanner sees every class.
  """
  def role_classes("surface"), do: "bg-pp-surface text-pp-on-surface"

  def role_classes("surface-container-lowest"),
    do: "bg-pp-surface-container-lowest text-pp-on-surface"

  def role_classes("surface-container-low"), do: "bg-pp-surface-container-low text-pp-on-surface"
  def role_classes("surface-container"), do: "bg-pp-surface-container text-pp-on-surface"

  def role_classes("surface-container-high"),
    do: "bg-pp-surface-container-high text-pp-on-surface"

  def role_classes("surface-container-highest"),
    do: "bg-pp-surface-container-highest text-pp-on-surface"

  def role_classes("surface-dim"), do: "bg-pp-surface-dim text-pp-on-surface"
  def role_classes("surface-bright"), do: "bg-pp-surface-bright text-pp-on-surface"
  def role_classes("surface-variant"), do: "bg-pp-surface-variant text-pp-on-surface-variant"
  def role_classes("primary"), do: "bg-pp-primary text-pp-on-primary"
  def role_classes("secondary"), do: "bg-pp-secondary text-pp-on-secondary"
  def role_classes("tertiary"), do: "bg-pp-tertiary text-pp-on-tertiary"
  def role_classes("error"), do: "bg-pp-error text-pp-on-error"

  def role_classes("primary-container"),
    do: "bg-pp-primary-container text-pp-on-primary-container"

  def role_classes("secondary-container"),
    do: "bg-pp-secondary-container text-pp-on-secondary-container"

  def role_classes("tertiary-container"),
    do: "bg-pp-tertiary-container text-pp-on-tertiary-container"

  def role_classes("error-container"), do: "bg-pp-error-container text-pp-on-error-container"
  def role_classes("inverse-surface"), do: "bg-pp-inverse-surface text-pp-inverse-on-surface"

  @doc """
  The DOM id a `section/1` titled `title` gets, e.g. `"App Bar"` ->
  `"app-bar"` -- also what `PhoenixPaperWebsiteWeb.Nav` builds its
  per-component `#anchor` links from, so the two can't disagree.
  """
  def slug(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end

  attr :id, :string, required: true
  attr :text, :string, required: true
  attr :language, :string, default: "elixir"

  @doc """
  A "Show code" toggle revealing a `<.code>` block -- a native
  `<details>`, since MD3 has no disclosure component.
  """
  def demo_code(assigns) do
    ~H"""
    <details id={"#{@id}-code"} class="group mt-4">
      <summary class="pp-label-large inline-flex cursor-pointer list-none items-center gap-1 rounded-pp-full px-3 py-2 text-pp-primary transition-colors hover:bg-pp-primary/8 [&::-webkit-details-marker]:hidden">
        <.pp_icon
          name="hero-chevron-right"
          size="sm"
          class="transition-transform duration-200 group-open:rotate-90"
        /> Show code
      </summary>
      <div class="mt-2">
        <.code text={@text} language={@language} />
      </div>
    </details>
    """
  end

  attr :label, :string, required: true
  attr :direction, :string, default: "row", values: ~w(row column)
  attr :spacing, :atom, default: :md, values: ~w(xs sm md lg)a
  attr :class, :any, default: nil
  slot :inner_block, required: true

  @doc """
  A labeled sub-group inside a section, for a single component's variants.

  The demo canvas is a flex box (wrapping rows). Pass `direction` and
  `spacing` rather than overriding with `flex-col` / `gap-*` in `class`:
  Tailwind resolves conflicting utilities by stylesheet order, not class
  order, so `flex-row` beats `flex-col` and `gap-4` beats `gap-2`. Rows
  center their items; columns keep flexbox's default stretch, so an
  `items-*` in `class` never conflicts with a default.
  """
  def demo_group(assigns) do
    ~H"""
    <div class="mb-8">
      <.pp_typography variant="title-small" tag="h3" color="on-surface-variant" class="mb-3">
        {@label}
      </.pp_typography>
      <div class={[
        "flex rounded-pp-md border border-pp-outline-variant bg-pp-surface-container-lowest p-6",
        if(@direction == "row", do: "flex-row flex-wrap items-center", else: "flex-col"),
        gap(@spacing),
        @class
      ]}>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp gap(:xs), do: "gap-1"
  defp gap(:sm), do: "gap-2"
  defp gap(:md), do: "gap-4"
  defp gap(:lg), do: "gap-6"

  attr :text, :string, required: true
  attr :language, :string, default: "elixir", values: ~w(elixir css javascript)

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

  Every block has a copy button (a `pp_icon_button`, top-right)
  wired to the ".CopyCode" hook (`position="absolute"`, not
  `class="absolute"`: the ripple's own `relative` would outrank it): it copies the `<code>` element's text
  (highlight.js only wraps it in spans, so the text is the original
  snippet) and swaps the clipboard icon for a check for 2s via a
  `data-copied` attribute and `group-data-copied:` variants.
  """
  def code(assigns) do
    assigns = assign(assigns, :id, "code-#{:erlang.phash2(assigns.text)}")

    ~H"""
    <div class="relative">
      <pre
        id={@id}
        phx-update="ignore"
        phx-hook=".Highlight"
        class="overflow-hidden rounded-pp-sm border border-pp-outline-variant text-sm leading-relaxed"
      ><code class={"language-#{@language}"}>{@text}</code></pre>
      <%!-- On the always-dark code panel: color="inherit" follows the panel's
            light text instead of on-surface-variant. --%>
      <.pp_icon_button
        id={"#{@id}-copy"}
        label="Copy code"
        size="xs"
        color="inherit"
        position="absolute"
        phx-hook=".CopyCode"
        data-target={@id}
        class="group top-2 right-2 text-white/80"
      >
        <%!-- The show/hide lives on wrapper spans: pp_icon's own inline-block
              would outrank a hidden on the icon itself. --%>
        <span class="group-data-copied:hidden">
          <.pp_icon name="hero-clipboard-document" size="sm" />
        </span>
        <span class="hidden group-data-copied:inline"><.pp_icon name="hero-check" size="sm" /></span>
      </.pp_icon_button>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".CopyCode">
      // navigator.clipboard needs a secure context (https or localhost);
      // fall back to a hidden textarea + execCommand elsewhere.
      const copy = async (text) => {
        if (navigator.clipboard && window.isSecureContext) return navigator.clipboard.writeText(text)
        const area = document.createElement("textarea")
        area.value = text
        area.setAttribute("readonly", "")
        area.style.position = "fixed"
        area.style.opacity = "0"
        document.body.appendChild(area)
        area.select()
        const ok = document.execCommand("copy")
        area.remove()
        if (!ok) throw new Error("copy failed")
      }

      export default {
        mounted() {
          this.onClick = async () => {
            const code = document.querySelector(`#${this.el.dataset.target} code`)
            if (!code) return
            try {
              await copy(code.textContent)
              this.flash("Copied", true)
            } catch {
              this.flash("Copy failed", false)
            }
          }
          this.el.addEventListener("click", this.onClick)
        },
        flash(label, copied) {
          clearTimeout(this.timer)
          this.el.setAttribute("aria-label", label)
          this.el.setAttribute("title", label)
          if (copied) this.el.setAttribute("data-copied", "")
          this.timer = setTimeout(() => {
            this.el.removeAttribute("data-copied")
            this.el.setAttribute("aria-label", "Copy code")
            this.el.setAttribute("title", "Copy code")
          }, 2000)
        },
        destroyed() {
          clearTimeout(this.timer)
          this.el.removeEventListener("click", this.onClick)
        }
      }
    </script>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".Highlight">
      export default {
        mounted() {
          window.hljs?.highlightElement(this.el.querySelector("code"))
        }
      }
    </script>
    """
  end

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

  attr :id, :string,
    default: "pp-hero",
    doc: "prefix for the gradient's id -- give each hero_mark on a page its own"

  attr :class, :any, default: nil

  @doc """
  A big, floating, gradient-filled version of `logo_mark/1` for the landing
  hero -- same path data, but filled with `url(#<id>-gradient)` instead
  of `currentColor`, so it reads live off the current
  `--color-pp-primary`/`--color-pp-secondary`/`--color-pp-tertiary` tokens
  rather than a single text color. Picking a new primary/secondary/tertiary
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
          id={"#{@id}-gradient"}
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
        fill={"url(##{@id}-gradient)"}
        fill-rule="evenodd"
      />
      <path
        d="M34 24c8 0 16-4 22-12"
        fill="none"
        stroke={"url(##{@id}-gradient)"}
        stroke-width="4.6"
        stroke-linecap="round"
      />
      <path
        d="M35 32c9 1 17-3 23-10"
        fill="none"
        stroke={"url(##{@id}-gradient)"}
        stroke-width="4.6"
        stroke-linecap="round"
      />
      <path
        d="M32 41c9 1 16-2 21-9"
        fill="none"
        stroke={"url(##{@id}-gradient)"}
        stroke-width="4.2"
        stroke-linecap="round"
      />
      <path
        d="M22 48c6 2 10 6 12 12"
        fill="none"
        stroke={"url(##{@id}-gradient)"}
        stroke-width="4"
        stroke-linecap="round"
      />
    </svg>
    """
  end
end
