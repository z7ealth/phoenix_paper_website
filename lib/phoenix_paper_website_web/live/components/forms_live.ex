defmodule PhoenixPaperWebsiteWeb.Components.FormsLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Forms")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:forms}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Forms</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Input, Select, NumberField, Checkbox, Switch, ThemeToggle, RadioGroup,
          Slider, Rating, Autocomplete, TransferList. Every one of these also accepts a field
          from to_form/2, the same way a generated core_components.ex input does.
        </p>

        <.section
          title="Input"
          description="Modeled on MUI's TextField. Three variants (outlined, filled, standard), pure-CSS floating label, no JavaScript."
          props={[
            {"label / value / name / id", "standard text field attrs"},
            {"type", "any input type, e.g. text | email | password (default: text)"},
            {"variant", "outlined | filled | standard (default: outlined)"},
            {"color",
             "primary | secondary | tertiary | error (default: primary), focus/label accent"},
            {"size", "medium | small (default: medium)"},
            {"shape", "corner radius token (default: :sm), ignored for variant=\"standard\""},
            {"multiline / rows", "renders a textarea instead of an input"},
            {"start_adornment / end_adornment",
             "slots for prefix/suffix content, e.g. an icon or unit"},
            {"field", "a Phoenix.HTML.FormField from to_form/2: sets name/id/value for you"},
            {"errors", "list of error strings: switches to the error color, hides helper_text"},
            {"helper_text", "shown below the field when there are no errors"},
            {"disabled", "boolean (default: false)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={input_code()}
        >
          <.demo_group label="Variants">
            <.pp_input variant="outlined" label="Outlined (default)" name="outlined_demo" />
            <.pp_input variant="filled" label="Filled" name="filled_demo" />
            <.pp_input variant="standard" label="Standard" name="standard_demo" />
          </.demo_group>

          <.demo_group label="States" class="items-start">
            <.pp_input
              label="With helper text"
              name="helper_demo"
              helper_text="We'll never share your email."
            />
            <.pp_input
              label="With an error"
              name="error_demo"
              value="not-an-email"
              errors={["is not a valid email"]}
            />
            <.pp_input label="Disabled" name="disabled_demo" value="Can't touch this" disabled />
          </.demo_group>

          <.demo_group label="Colors">
            <.pp_input color="primary" label="Primary" name="color_primary_demo" />
            <.pp_input color="secondary" label="Secondary" name="color_secondary_demo" />
            <.pp_input color="tertiary" label="Tertiary" name="color_tertiary_demo" />
          </.demo_group>

          <.demo_group label="Size and adornments">
            <.pp_input size="small" label="Small" name="size_small_demo" />
            <.pp_input label="Amount" name="amount_demo" value="42.00">
              <:start_adornment>$</:start_adornment>
              <:end_adornment>USD</:end_adornment>
            </.pp_input>
          </.demo_group>

          <.demo_group label="Multiline" class="items-start">
            <.pp_input
              multiline
              rows={3}
              label="Bio"
              name="bio_demo"
              value="A short bio, spanning a couple lines of text."
              class="w-full max-w-sm"
            />
          </.demo_group>
        </.section>

        <.section
          title="Select"
          description="A native select element styled to match Input's outlined/filled variants."
          props={[
            {"options", "list of {label, value} tuples, or plain values"},
            {"prompt", "an empty/placeholder option's label"},
            {"variant", "outlined | filled (default: outlined)"},
            {"field / errors / helper_text", "same as Input"},
            {"disabled", "boolean (default: false)"}
          ]}
          code={select_code()}
        >
          <.demo_group label="Variants">
            <.pp_select
              label="Country"
              name="country_demo"
              prompt="Choose one"
              options={["Canada", "Mexico", "United States"]}
            />
            <.pp_select
              variant="filled"
              label="Country"
              name="country_filled_demo"
              prompt="Choose one"
              options={["Canada", "Mexico", "United States"]}
            />
          </.demo_group>
        </.section>

        <.section
          title="Number Field"
          description="A numeric input with increment/decrement stepper buttons: plain onclick JS calling stepUp()/stepDown(), no JS hook."
          props={[
            {"min / max / step", "passed straight to the underlying input type=\"number\""},
            {"variant / shape / field / errors / helper_text", "same as Input"},
            {"disabled", "boolean (default: false)"}
          ]}
          code={number_field_code()}
        >
          <.demo_group label="Variants">
            <.pp_number_field label="Quantity" name="qty_demo" value={2} min={0} max={10} />
            <.pp_number_field
              variant="filled"
              label="Quantity"
              name="qty_filled_demo"
              value={2}
              min={0}
              max={10}
            />
          </.demo_group>
        </.section>

        <.section
          title="Checkbox"
          description="Includes the hidden-input trick so an unchecked box still submits false."
          props={[
            {"checked", "boolean (default: nil, meaning unchecked)"},
            {"field", "a Phoenix.HTML.FormField: sets name/id/checked for you"},
            {"label", "text next to the box"},
            {"disabled", "boolean (default: false)"},
            {"ripple", "boolean, the ripple effect on click/tap (default: false)"},
            {"paperize", "false renders a bare native checkbox, no hidden input"}
          ]}
          code={checkbox_code()}
        >
          <.demo_group label="States">
            <.pp_checkbox label="Paperized (default)" checked={true} />
            <.pp_checkbox label="Unchecked" />
            <.pp_checkbox paperize={false} label="paperize: false" class="size-5" />
          </.demo_group>
        </.section>

        <.section
          title="Switch"
          description="An on/off toggle, structured like Checkbox but rendered as a sliding track/thumb."
          props={[
            {"checked / field / label / disabled / ripple / paperize", "same shape as Checkbox"}
          ]}
          code={switch_code()}
        >
          <.demo_group label="States">
            <.pp_switch label="Paperized (default)" checked={true} name="wifi_demo" />
            <.pp_switch label="Unchecked" name="bluetooth_demo" />
            <.pp_switch paperize={false} label="paperize: false" name="bare_switch_demo" />
          </.demo_group>
        </.section>

        <.section
          title="Theme Toggle"
          description="A light/dark mode toggle built on top of Switch's own markup (sun/moon icons live inside the sliding thumb). Wired with a small vanilla onclick that flips data-theme on the target element, computing the effective theme itself rather than trusting the checkbox, no server round-trip needed."
          props={[
            {"label", "text next to the switch (default: \"Dark mode\"), nil for icon-only"},
            {"default_checked", "boolean, initial visual state, uncontrolled (default: false)"},
            {"target", "CSS selector for the element to toggle data-theme on (default: \"html\")"},
            {"on_toggle",
             "extra JS commands run before the built-in flip, e.g. to persist server-side"},
            {"ripple / paperize", "same as Switch"}
          ]}
          code={theme_toggle_code()}
        >
          <.demo_group label="Try it (flips this whole page's theme)">
            <div class="flex flex-col items-center gap-2">
              <.pp_theme_toggle />
              <span class="text-xs text-pp-on-surface/60">default label</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.pp_theme_toggle label={nil} />
              <span class="text-xs text-pp-on-surface/60">icon-only (label: nil)</span>
            </div>
          </.demo_group>
          <p class="text-sm text-pp-on-surface/60">
            This site's own toggle in the top-right corner is this exact component. It doesn't
            persist across a full page reload by default (that's what on_toggle is for, e.g.
            JS.push to save the choice server-side); within a session, LiveView's own
            navigate-based routing keeps it in place as you move between pages, and it already
            falls back to the OS/browser's color-scheme preference with zero clicks, via CSS.
          </p>
        </.section>

        <.section
          title="Radio Group"
          description="A labeled set of mutually exclusive radio buttons sharing one name."
          props={[
            {"options", "list of {label, value} tuples, or plain values"},
            {"value", "the currently selected value"},
            {"label", "the group's legend"},
            {"ripple", "boolean, the ripple effect on click/tap (default: false)"},
            {"field / disabled / paperize", "same as other form controls"}
          ]}
          code={radio_group_code()}
        >
          <.demo_group label="Options">
            <.pp_radio_group
              label="Size"
              name="size_demo"
              value="md"
              options={[{"Small", "sm"}, {"Medium", "md"}, {"Large", "lg"}]}
            />
          </.demo_group>
        </.section>

        <.section
          title="Slider"
          description="A native range input, fully re-skinned via ::-webkit-slider-thumb / ::-moz-range-progress rather than CSS accent-color alone, so the unfilled portion of the track can be controlled too."
          props={[
            {"min / max / step", "default 0 / 100 / 1"},
            {"value", "a number, or a {low, high} tuple for a range slider (two thumbs)"},
            {"color", "primary | secondary | tertiary | error (default: primary)"},
            {"size", "medium | small (default: medium)"},
            {"orientation", "horizontal | vertical (default: horizontal)"},
            {"track", "normal | none | inverted (default: normal), ignored for range sliders"},
            {"marks", "true (tick every step), a list of values, or a list of {value, label} tuples"},
            {"label", "shown above the slider with the current value"},
            {"field / disabled / paperize", "same as other form controls"}
          ]}
          code={slider_code()}
        >
          <.demo_group label="Colors" class="items-start">
            <.pp_slider
              :for={color <- ~w(primary secondary tertiary error)}
              name={"volume_#{color}_demo"}
              label={color}
              value={60}
              color={color}
              class="w-56"
            />
          </.demo_group>

          <.demo_group label="Track modes" class="items-start">
            <.pp_slider
              name="volume_no_track_demo"
              label="track: none"
              value={60}
              track="none"
              class="w-56"
            />
            <.pp_slider
              name="volume_inverted_demo"
              label="track: inverted"
              value={60}
              track="inverted"
              class="w-56"
            />
          </.demo_group>

          <.demo_group label="Marks" class="items-start">
            <.pp_slider
              name="volume_marks_demo"
              label="Discrete (marks)"
              value={40}
              step={20}
              marks={true}
              class="w-56"
            />
            <.pp_slider
              name="temperature_demo"
              label="Custom labeled marks"
              value={30}
              min={0}
              max={100}
              marks={[{0, "0°C"}, {30, "30°C"}, {60, "60°C"}, {100, "100°C"}]}
              class="w-64"
            />
          </.demo_group>

          <.demo_group label="Range, size, disabled" class="items-start">
            <.pp_slider name="price_demo" label="Range slider" value={{20, 80}} class="w-56" />
            <.pp_slider name="volume_small_demo" label="Small" value={60} size="small" class="w-56" />
            <.pp_slider name="volume_disabled_demo" label="Disabled" value={30} disabled class="w-56" />
          </.demo_group>

          <.demo_group label="Vertical">
            <.pp_slider name="volume_vertical_demo" value={60} orientation="vertical" />
            <.pp_slider
              name="volume_vertical_small_demo"
              value={60}
              orientation="vertical"
              size="small"
              color="secondary"
            />
          </.demo_group>
        </.section>

        <.section
          title="Rating"
          description="A row of radio inputs with a pure-CSS hover/checked fill effect: hovering star 3 highlights stars 1-3, no JS."
          props={[
            {"value", "integer, the current/selected rating (default: 0)"},
            {"max", "number of stars (default: 5)"},
            {"readonly",
             "boolean, renders fixed filled/unfilled spans instead of inputs (default: false)"},
            {"field / disabled / paperize", "same as other form controls"}
          ]}
          code={rating_code()}
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

        <.section
          live_component
          title="Autocomplete"
          description="A text field with a filtered dropdown, filtered entirely server-side over phx-change/phx-debounce. Unlike everything above, this needs interactive state, so it's a Phoenix.LiveComponent, fully live on this page, since it's a real LiveView. Type to filter."
          props={[
            {"options", "list of {label, value} tuples, or plain values"},
            {"value / name / label / placeholder", "same intent as Input"},
            {"shape / paperize", "same as other form controls"}
          ]}
          code={autocomplete_code()}
        >
          <.demo_group label="Try it">
            <.pp_box class="w-full max-w-sm">
              <.live_component
                module={PhoenixPaper.Autocomplete}
                id="country-autocomplete"
                name="country"
                label="Country"
                placeholder="Start typing..."
                options={["Canada", "Mexico", "United States", "United Kingdom", "Uruguay"]}
              />
            </.pp_box>
          </.demo_group>
        </.section>

        <.section
          live_component
          title="Transfer List"
          description="Two list boxes with buttons to move checked items between them, state managed entirely inside the component. Also a Phoenix.LiveComponent: try checking a permission and moving it across."
          props={[
            {"items", "the starting list: everything begins on the left"},
            {"left_label / right_label", "column headers (default: \"Available\" / \"Selected\")"}
          ]}
          code={transfer_list_code()}
        >
          <.demo_group label="Try it">
            <.live_component
              module={PhoenixPaper.TransferList}
              id="permissions-transfer"
              items={["Read", "Write", "Admin", "Billing", "Support"]}
              left_label="Available"
              right_label="Granted"
            />
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp input_code do
    """
    <.pp_input variant="outlined" label="Outlined (default)" name="outlined" />
    <.pp_input variant="filled" label="Filled" name="filled" />
    <.pp_input variant="standard" label="Standard" name="standard" />
    <.pp_input label="With an error" name="error" value="not-an-email" errors={["is not a valid email"]} />
    <.pp_input color="secondary" label="Secondary" name="color_secondary" />
    <.pp_input size="small" label="Small" name="size_small" />

    <.pp_input label="Amount" name="amount" value="42.00">
      <:start_adornment>$</:start_adornment>
      <:end_adornment>USD</:end_adornment>
    </.pp_input>

    <.pp_input multiline rows={3} label="Bio" name="bio" />\
    """
  end

  defp select_code do
    """
    <.pp_select
      label="Country"
      name="country"
      prompt="Choose one"
      options={["Canada", "Mexico", "United States"]}
    />
    <.pp_select
      variant="filled"
      label="Country"
      name="country_filled"
      prompt="Choose one"
      options={["Canada", "Mexico", "United States"]}
    />\
    """
  end

  defp number_field_code do
    """
    <.pp_number_field label="Quantity" name="qty" value={2} min={0} max={10} />
    <.pp_number_field variant="filled" label="Quantity" name="qty_filled" value={2} min={0} max={10} />\
    """
  end

  defp checkbox_code do
    """
    <.pp_checkbox label="Paperized (default)" checked={true} />
    <.pp_checkbox paperize={false} label="paperize: false" />\
    """
  end

  defp switch_code do
    """
    <.pp_switch label="Notifications" checked={true} name="notifications" />\
    """
  end

  defp theme_toggle_code do
    """
    <.pp_theme_toggle />

    <%!-- accurate initial state, a scoped target, and persisting the choice server-side --%>
    <.pp_theme_toggle
      label="Dark mode"
      default_checked={@dark_mode?}
      target="#preview"
      on_toggle={JS.push("save_theme_preference")}
    />\
    """
  end

  defp radio_group_code do
    """
    <.pp_radio_group
      label="Size"
      name="size"
      value="md"
      options={[{"Small", "sm"}, {"Medium", "md"}, {"Large", "lg"}]}
    />\
    """
  end

  defp slider_code do
    """
    <.pp_slider name="volume" label="Volume" value={60} />

    <%!-- size --%>
    <.pp_slider name="volume_small" label="Small" value={60} size="small" />

    <%!-- colors --%>
    <.pp_slider :for={color <- ~w(primary secondary tertiary error)} name={"volume_\#{color}"} label={color} value={60} color={color} />

    <%!-- track modes --%>
    <.pp_slider name="volume_no_track" label="track: none" value={60} track="none" />
    <.pp_slider name="volume_inverted" label="track: inverted" value={60} track="inverted" />

    <%!-- discrete marks, evenly spaced --%>
    <.pp_slider name="volume_marks" label="Discrete (marks)" value={40} step={20} marks={true} />

    <%!-- custom labeled marks --%>
    <.pp_slider
      name="temperature"
      label="Temperature"
      value={30}
      min={0}
      max={100}
      marks={[{0, "0°C"}, {30, "30°C"}, {60, "60°C"}, {100, "100°C"}]}
    />

    <%!-- range slider: a {low, high} tuple instead of a single number --%>
    <.pp_slider name="price" label="Price range" value={{20, 80}} />

    <%!-- vertical --%>
    <.pp_slider name="volume_vertical" orientation="vertical" value={60} />

    <.pp_slider name="volume_disabled" label="Disabled" value={30} disabled />\
    """
  end

  defp rating_code do
    """
    <.pp_rating id="stars" name="stars" value={3} />
    <.pp_rating readonly value={4} />\
    """
  end

  defp autocomplete_code do
    """
    <.live_component
      module={PhoenixPaper.Autocomplete}
      id="country"
      name="country"
      label="Country"
      placeholder="Start typing..."
      options={["Canada", "Mexico", "United States", "United Kingdom", "Uruguay"]}
    />\
    """
  end

  defp transfer_list_code do
    """
    <.live_component
      module={PhoenixPaper.TransferList}
      id="permissions"
      items={["Read", "Write", "Admin", "Billing"]}
    />\
    """
  end
end
