defmodule PhoenixPaperWebsiteWeb.Components.FormsLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Forms")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:forms}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Forms">
          PhoenixPaper.TextField, Select, Checkbox, Switch, ThemeToggle, RadioGroup, Slider,
          DatePicker and TimePicker. Every one of them takes a field from to_form/2, the same
          way a generated core_components.ex input does, so they drop straight into Phoenix's
          own &lt;.form&gt;.
        </.page_header>

        <.section
          title="Text Field"
          api={[{PhoenixPaper.TextField, :pp_text_field}]}
          description="MD3's text field, outlined or filled, with a pure-CSS floating label and no JavaScript. supporting_text sits under the field; errors switch it to the error color with a trailing error icon and wire aria-describedby."
          code={input_code()}
        >
          <.demo_group label="Variants">
            <.pp_text_field variant="outlined" label="Outlined (default)" name="outlined_demo" />
            <.pp_text_field variant="filled" label="Filled" name="filled_demo" />
          </.demo_group>

          <.demo_group label="States" class="items-start">
            <.pp_text_field
              label="With supporting text"
              name="helper_demo"
              supporting_text="We'll never share your email."
            />
            <.pp_text_field
              label="With an error"
              name="error_demo"
              value="not-an-email"
              errors={["is not a valid email"]}
            />
            <.pp_text_field label="Disabled" name="disabled_demo" value="Can't touch this" disabled />
          </.demo_group>

          <.demo_group label="Colors">
            <.pp_text_field color="primary" label="Primary" name="color_primary_demo" />
            <.pp_text_field color="secondary" label="Secondary" name="color_secondary_demo" />
            <.pp_text_field color="tertiary" label="Tertiary" name="color_tertiary_demo" />
          </.demo_group>

          <.demo_group label="Adornments">
            <.pp_text_field label="Search" name="search_adorn_demo">
              <:start_adornment>
                <.pp_icon name="hero-magnifying-glass" size="sm" />
              </:start_adornment>
            </.pp_text_field>
            <.pp_text_field label="Amount" name="amount_demo" value="42.00">
              <:start_adornment>$</:start_adornment>
              <:end_adornment>USD</:end_adornment>
            </.pp_text_field>
          </.demo_group>

          <.demo_group label="Multiline" class="items-start">
            <.pp_text_field
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
          api={[{PhoenixPaper.Select, :pp_select}]}
          description="A native select element styled as MD3's outlined or filled text field, always with a floating label."
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
          title="Checkbox"
          api={[{PhoenixPaper.Checkbox, :pp_checkbox}]}
          description="MD3 metrics with a 40dp state layer, plus the hidden-input trick so an unchecked box still submits false. indeterminate shows a dash (a parent of partially checked children); error switches to the error color."
          code={checkbox_code()}
        >
          <.demo_group label="States">
            <.pp_checkbox label="Checked" checked={true} name="cb_checked_demo" />
            <.pp_checkbox label="Unchecked" name="cb_unchecked_demo" />
            <.pp_checkbox label="Indeterminate" indeterminate name="cb_indeterminate_demo" />
            <.pp_checkbox label="Error" error checked={true} name="cb_error_demo" />
            <.pp_checkbox label="Disabled" disabled checked={true} name="cb_disabled_demo" />
          </.demo_group>
        </.section>

        <.section
          title="Switch"
          api={[{PhoenixPaper.Switch, :pp_switch}]}
          description="An on/off toggle with MD3's track and handle: the handle grows when on and when pressed. icons adds MD3's check/close glyphs inside the handle."
          code={switch_code()}
        >
          <.demo_group label="States">
            <.pp_switch label="On" checked={true} name="wifi_demo" />
            <.pp_switch label="Off" name="bluetooth_demo" />
            <.pp_switch label="With icons" icons checked={true} name="icons_switch_demo" />
            <.pp_switch label="Disabled" disabled checked={true} name="disabled_switch_demo" />
          </.demo_group>
        </.section>

        <.section
          title="Theme Toggle"
          api={[{PhoenixPaper.ThemeToggle, :pp_theme_toggle}]}
          description={
            ~S|Sets data-theme on <html>, the attribute daisyUI and Phoenix 1.8's app.css already key off. The default is a System / Light / Dark segmented control, like the one in Phoenix 1.8's generated layout, with System selected: it removes data-theme so the page follows the OS, live. Which option is selected is pure CSS (read from data-theme), so every toggle on the page agrees and a LiveView re-render can't reset it. The choice is saved in localStorage under phx:theme, the key a Phoenix 1.8 root layout restores on load.|
          }
          code={theme_toggle_code()}
        >
          <.demo_group label="Try it (changes this whole page's theme)">
            <.pp_theme_toggle id="theme-toggle-demo-segmented" />
            <.pp_theme_toggle id="theme-toggle-demo-labeled" label="Theme" />
          </.demo_group>
          <.pp_typography variant="body-medium" color="on-surface-variant">
            Both change the same data-theme, so they stay in sync with each other and with
            the theme picker in the top-right corner. Pick Light or Dark and reload: the choice
            is restored before first paint. Pick System to follow your OS again.
          </.pp_typography>
        </.section>

        <.section
          title="Radio Group"
          api={[{PhoenixPaper.RadioGroup, :pp_radio_group}]}
          description="A labeled set of mutually exclusive radio buttons sharing one name, with MD3 metrics and a 40dp state layer; error switches to the error color."
          code={radio_group_code()}
        >
          <.demo_group label="Options, and error" class="items-start">
            <.pp_radio_group
              label="Size"
              name="size_demo"
              value="md"
              options={[{"Small", "sm"}, {"Medium", "md"}, {"Large", "lg"}]}
            />
            <.pp_radio_group
              label="Plan"
              name="plan_demo"
              error
              options={[{"Free", "free"}, {"Pro", "pro"}]}
            />
          </.demo_group>
        </.section>

        <.section
          title="Slider"
          api={[{PhoenixPaper.Slider, :pp_slider}]}
          description="A native range input re-skinned as MD3's slider: a thin handle between active and inactive track segments, with stop indicators at the ends. M3 Expressive adds track sizes xs–xl, a centered track (filled from the middle) and a value indicator above the handle."
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

          <.demo_group label="Track modes, and a value indicator" class="items-start">
            <.pp_slider
              name="volume_centered_demo"
              label="track: centered"
              value={70}
              min={0}
              max={100}
              track="centered"
              class="w-56"
            />
            <.pp_slider
              name="volume_indicator_demo"
              label="value_indicator"
              value={45}
              value_indicator
              class="w-56"
            />
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
            <.pp_slider name="volume_large_demo" label="size: md" value={60} size="md" class="w-56" />
            <.pp_slider name="volume_disabled_demo" label="Disabled" value={30} disabled class="w-56" />
          </.demo_group>

          <.demo_group label="Vertical">
            <.pp_slider name="volume_vertical_demo" value={60} orientation="vertical" />
            <.pp_slider
              name="volume_vertical_small_demo"
              value={60}
              orientation="vertical"
              size="sm"
              color="secondary"
            />
          </.demo_group>
        </.section>

        <.section
          live_component
          title="Date Picker"
          description="MD3's date picker as a LiveComponent (a calendar keeps state: the month in view, the year grid, a pending choice). docked opens a calendar panel under an outlined field and commits on click; modal opens a dialog with a headline, the calendar, Cancel/OK, and an input mode (the pencil). min/max bound the dates; with field= it renders a hidden input in ISO format."
          props={[
            {"field / name / value", "form integration; the value is a Date (or ISO string)"},
            {"label", "the field's label"},
            {"variant", "docked (default) | modal"},
            {"range",
             "boolean: MD3's date range picker; the second pick ends the range (swapped if earlier), submitted as <name>_start / <name>_end"},
            {"min / max", "the earliest / latest selectable Date"},
            {"first_day_of_week", "1 (Monday) .. 7 (Sunday, default)"},
            {"format", "a function Date -> text for the field (default: ISO)"},
            {"clearable", "boolean: a Clear button"},
            {"month_names / weekday_names", "for translation"},
            {"cancel_label / ok_label / clear_label / headline_label",
             "button and headline texts, for translation"},
            {"range_headline_label / start_label / end_label",
             "the range picker's texts, for translation"},
            {"supporting_text / errors / disabled", "same as Text Field"},
            {"on_change",
             "function called in the LiveView's process with the new Date, outside a form"}
          ]}
          code={date_picker_code()}
        >
          <.demo_group label="docked and modal" class="items-start">
            <div class="w-72">
              <.live_component
                module={PhoenixPaper.DatePicker}
                id="date-picker-docked"
                name="due_on"
                label="Due date"
                min={Date.utc_today()}
              />
            </div>
            <div class="w-72">
              <.live_component
                module={PhoenixPaper.DatePicker}
                id="date-picker-modal"
                name="starts_on"
                label="Start date"
                variant="modal"
              />
            </div>
            <div class="w-72">
              <.live_component
                module={PhoenixPaper.DatePicker}
                id="date-picker-range"
                name="stay"
                label="Stay (range)"
                range
              />
            </div>
          </.demo_group>
        </.section>

        <.section
          live_component
          title="Time Picker"
          description="MD3's time picker as a LiveComponent: the field opens a dialog with the hour/minute selector, a dial (pick the hour, then the minutes) or an input mode (the keyboard icon), and Cancel/OK; nothing changes until OK. hour_cycle={24} puts 13–00 on an inner ring. With the JS hook (Getting Started, step 4) you can also drag the hand to any hour or exact minute."
          props={[
            {"field / name / value", "form integration; the value is a Time (or HH:MM string)"},
            {"label", "the field's label"},
            {"hour_cycle", "12 (default, with an AM/PM selector) | 24"},
            {"supporting_text / errors / disabled", "same as Text Field"},
            {"headline_label / input_headline_label", "the dialog headlines, for translation"},
            {"cancel_label / ok_label / am_label / pm_label", "button texts, for translation"},
            {"on_change",
             "function called in the LiveView's process with the new Time, outside a form"}
          ]}
          code={time_picker_code()}
        >
          <.demo_group label="12-hour and 24-hour" class="items-start">
            <div class="w-72">
              <.live_component
                module={PhoenixPaper.TimePicker}
                id="time-picker-12"
                name="starts_at"
                label="Start time"
              />
            </div>
            <div class="w-72">
              <.live_component
                module={PhoenixPaper.TimePicker}
                id="time-picker-24"
                name="ends_at"
                label="End time"
                hour_cycle={24}
              />
            </div>
          </.demo_group>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp input_code do
    """
    <.pp_text_field variant="outlined" label="Outlined (default)" name="outlined" />
    <.pp_text_field variant="filled" label="Filled" name="filled" />
    <.pp_text_field label="With an error" name="error" value="not-an-email" errors={["is not a valid email"]} />
    <.pp_text_field color="secondary" label="Secondary" name="color_secondary" />

    <.pp_text_field label="Amount" name="amount" value="42.00">
      <:start_adornment>$</:start_adornment>
      <:end_adornment>USD</:end_adornment>
    </.pp_text_field>

    <.pp_text_field label="Search" name="q">
      <:start_adornment><.pp_icon name="hero-magnifying-glass" size="sm" /></:start_adornment>
    </.pp_text_field>

    <.pp_text_field multiline rows={3} label="Bio" name="bio" />\
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
    <%!-- System / Light / Dark, System selected by default --%>
    <.pp_theme_toggle />

    <%!-- With visible text next to it --%>
    <.pp_theme_toggle label="Theme" />

    <%!-- Also save the choice server-side: receives %{"theme" => "dark"} --%>
    <.pp_theme_toggle on_toggle={JS.push("save_theme")} />\
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
    <.pp_slider name="volume_md" label="Medium track" value={60} size="md" />
    <.pp_slider name="volume_no_track" label="track: none" value={60} track="none" />

    <%!-- discrete, evenly-spaced marks --%>
    <.pp_slider name="volume_marks" label="Discrete (marks)" value={40} step={20} marks={true} />

    <%!-- custom labeled marks --%>
    <.pp_slider
      name="temperature"
      label="Temperature"
      value={30}
      max={100}
      marks={[{0, "0°C"}, {50, "50°C"}, {100, "100°C"}]}
    />

    <%!-- range slider: a {low, high} tuple instead of a single number --%>
    <.pp_slider name="price" label="Price range" value={{20, 80}} />

    <.pp_slider name="volume_vertical" orientation="vertical" value={60} />
    <.pp_slider name="volume_disabled" label="Disabled" value={30} disabled />\
    """
  end

  defp date_picker_code do
    """
    <.live_component
      module={PhoenixPaper.DatePicker}
      id="due-on"
      field={@form[:due_on]}
      label="Due date"
      min={Date.utc_today()}
    />

    <.live_component module={PhoenixPaper.DatePicker} id="starts-on" field={@form[:starts_on]} label="Start date" variant="modal" />

    <%!-- A date range: submitted as stay_start / stay_end --%>
    <.live_component module={PhoenixPaper.DatePicker} id="stay" name="stay" label="Stay" range />\
    """
  end

  defp time_picker_code do
    """
    <.live_component module={PhoenixPaper.TimePicker} id="starts-at" field={@form[:starts_at]} label="Start time" />

    <.live_component module={PhoenixPaper.TimePicker} id="ends-at" field={@form[:ends_at]} label="End time" hour_cycle={24} />\
    """
  end
end
