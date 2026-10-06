defmodule PhoenixPaperWebsiteWeb.Components.FormsLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Forms", country: nil, tags: ["elixir", "phoenix"])
     |> assign(:recipients, ["Ada Lovelace", "Grace Hopper"])
     |> assign(:uploaded, [])
     |> assign(:login_form, login_form(%{"email" => "", "password" => ""}))
     |> allow_upload(:demo_files, accept: ~w(.jpg .jpeg .png .pdf), max_entries: 3)}
  end

  # Text Field's chips demo: each chip's remove control pushes this.
  def handle_event("remove_recipient", %{"name" => name}, socket) do
    {:noreply, update(socket, :recipients, &List.delete(&1, name))}
  end

  def handle_event("reset_recipients", _params, socket) do
    {:noreply, assign(socket, :recipients, ["Ada Lovelace", "Grace Hopper"])}
  end

  # Upload demo: LiveView uploads need a form with phx-change.
  def handle_event("validate_upload", _params, socket), do: {:noreply, socket}

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :demo_files, ref)}
  end

  # Nothing is stored: consuming the entries just reads their names.
  def handle_event("save_upload", _params, socket) do
    names =
      consume_uploaded_entries(socket, :demo_files, fn _meta, entry ->
        {:ok, entry.client_name}
      end)

    {:noreply,
     socket
     |> assign(:uploaded, names)
     |> put_flash(:info, "Received #{length(names)} file(s), then discarded them (demo only).")}
  end

  # The Building a Form demo: a plain <.form> of pp_* inputs. Map params,
  # no schema, so the checks live in login_form/1.
  def handle_event("validate_login", %{"user" => params}, socket) do
    {:noreply, assign(socket, :login_form, login_form(params))}
  end

  def handle_event("login", %{"user" => params}, socket) do
    form = login_form(params)

    socket =
      if form.errors == [],
        do: put_flash(socket, :info, "Signed in as #{params["email"]} (demo only)."),
        else: socket

    {:noreply, assign(socket, :login_form, form)}
  end

  defp login_form(params) do
    errors =
      Enum.reject(
        [
          !String.contains?(params["email"] || "", "@") &&
            {:email, {"must have the @ sign and no spaces", []}},
          String.length(params["password"] || "") < 8 &&
            {:password, {"should be at least %{count} characters", [count: 8]}}
        ],
        &(&1 == false)
      )

    to_form(params, as: :user, errors: errors)
  end

  # The Autocomplete demo's on_change runs in this LiveView's process.
  def handle_info({:country_picked, value}, socket) do
    {:noreply, assign(socket, :country, value)}
  end

  def handle_info({:tags_picked, values}, socket) do
    {:noreply, assign(socket, :tags, values)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:forms}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Forms">
          PhoenixPaper.TextField, PasswordField, Select, NumberField, Checkbox, Switch,
          ThemeToggle, RadioGroup, Slider, DatePicker, TimePicker, Autocomplete and Upload. Every one of them takes a field from to_form/2, the same
          way a generated core_components.ex input does, so they drop straight into Phoenix's
          own &lt;.form&gt;.
        </.page_header>

        <.section
          title="Building a Form"
          component={false}
          description={
            ~S|There's no form component: MD3 doesn't define one, and Phoenix's own <.form> already does the job. Build the form from to_form/2 as usual and give each pp_* input its field; errors show once a field has been used (the same used_input? rule as a generated core_components input). Here, a sign-in card: a Card around a <.form> with a text field, a password field, a checkbox and a submit button.|
          }
          code={login_form_code()}
        >
          <.demo_group label="Try it (an invalid submit shows the errors, a valid one a flash)">
            <.pp_card id="login-card" class="w-full max-w-sm">
              <:title>Sign in</:title>
              <:subhead>Use any email with an @ and an 8+ character password</:subhead>
              <.form
                for={@login_form}
                id="login-form"
                phx-change="validate_login"
                phx-submit="login"
                class="mt-4 flex flex-col gap-4"
              >
                <.pp_text_field
                  field={@login_form[:email]}
                  type="email"
                  label="Email"
                  autocomplete="username"
                />
                <.pp_password_field
                  field={@login_form[:password]}
                  label="Password"
                  autocomplete="current-password"
                />
                <.pp_checkbox field={@login_form[:remember_me]} label="Keep me signed in" />
                <div class="flex items-center justify-between gap-2">
                  <.pp_button variant="text" href="#building-a-form">
                    Forgot password?
                  </.pp_button>
                  <.pp_button id="login-submit" type="submit">Sign in</.pp_button>
                </div>
              </.form>
            </.pp_card>
          </.demo_group>
        </.section>

        <.section
          title="Text Field"
          api={[{PhoenixPaper.TextField, :pp_text_field}]}
          description="MD3's text field, outlined or filled, with a pure-CSS floating label and no JavaScript. supporting_text sits under the field; errors switch it to the error color with a trailing error icon and wire aria-describedby. The :chips slot puts MD3 input chips inside the field, before the text (the row wraps and the label stays raised while there are chips), and :menu anchors content such as a listbox to the field box."
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

          <.demo_group label=":chips (MD3 input chips inside the field)" class="items-start">
            <div class="w-full max-w-md">
              <.pp_text_field id="recipients-demo" name="recipients_q" label="To">
                <:chips :if={@recipients != []}>
                  <.pp_chip
                    :for={r <- @recipients}
                    variant="input"
                    deletable
                    on_delete={JS.push("remove_recipient", value: %{name: r})}
                  >
                    {r}
                  </.pp_chip>
                </:chips>
              </.pp_text_field>
            </div>
            <.pp_button
              :if={@recipients == []}
              id="reset-recipients"
              variant="text"
              phx-click="reset_recipients"
            >
              Bring them back
            </.pp_button>
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
          title="Password Field"
          api={[{PhoenixPaper.PasswordField, :pp_password_field}]}
          description="A text field of type password with MD3's trailing visibility toggle: an icon-button toggle (eye / eye-slash, aria-pressed) that flips the input between password and text on the client, with no round trip. LiveView keeps the flipped type across patches, so a validation error doesn't hide the password again. Give it an id, name or field so the toggle can find its input."
          code={password_field_code()}
        >
          <.demo_group label="Outlined, filled, with an error" class="items-start">
            <.pp_password_field
              id="password-demo"
              name="password_demo"
              label="Password"
              value="correct horse"
            />
            <.pp_password_field
              id="password-filled-demo"
              name="password_filled_demo"
              variant="filled"
              label="New password"
              supporting_text="At least 12 characters"
            />
            <.pp_password_field
              id="password-error-demo"
              name="password_error_demo"
              label="Confirm"
              value="nope"
              errors={["doesn't match"]}
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
          title="Number Field"
          api={[{PhoenixPaper.NumberField, :pp_number_field}]}
          description="An MD3 text field of type number with two trailing icon-button steppers. min, max and step are passed to the input and the steppers respect them; decrease_label and increase_label name the steppers for screen readers."
          code={number_field_code()}
        >
          <.demo_group label="Outlined and filled" class="items-start">
            <.pp_number_field label="Quantity" name="quantity_demo" value={2} min={0} max={10} />
            <.pp_number_field
              variant="filled"
              label="Guests"
              name="guests_demo"
              value={4}
              min={1}
              supporting_text="Up to 8 per table"
              max={8}
            />
            <.pp_number_field label="Amount" name="amount_step_demo" value={1.5} step={0.5} />
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

        <.section
          title="Autocomplete"
          live_component
          description="A text field that suggests options as you type, as a LiveComponent: an MD3 text field over the MD3 menu surface, filtering on the server (case- and accent-insensitive). Arrow keys move through the options, Enter picks, Escape closes. The value is submitted from a hidden input and each pick reaches the form's phx-change; outside a form, on_change is called with the new value."
          props={[
            {"options", "plain values or {label, value} tuples (required)"},
            {"field / name / value", "the selected option's value, submitted from a hidden input"},
            {"label, variant, supporting_text, errors, disabled", "as for TextField"},
            {"multiple",
             "pick several values as input chips; value is a list, submitted as name[] (plus an empty name[] so clearing every chip still submits)"},
            {"on_change", "fn value -> ... end, run in the LiveView process (a list with multiple)"},
            {"no_results_label", ~S|shown when nothing matches (default "No results")|}
          ]}
          code={autocomplete_code()}
        >
          <.demo_group
            label="Try it: type “ca” or “mé”"
            direction="column"
            class="items-start"
          >
            <div class="w-full max-w-sm">
              <.live_component
                module={PhoenixPaper.Autocomplete}
                id="country-autocomplete"
                name="country"
                label="Country"
                options={countries()}
                supporting_text="Accents don't matter"
                on_change={fn value -> send(self(), {:country_picked, value}) end}
              />
            </div>
            <.pp_typography id="country-picked" variant="body-medium" color="on-surface-variant">
              Value: {inspect(@country)}
            </.pp_typography>
          </.demo_group>

          <.demo_group
            label="multiple: picks become input chips (Backspace removes the last)"
            direction="column"
            class="items-start"
          >
            <div class="w-full max-w-md">
              <.live_component
                module={PhoenixPaper.Autocomplete}
                id="tags-autocomplete"
                name="tags"
                label="Tags"
                options={tag_options()}
                value={@tags}
                multiple
                on_change={fn values -> send(self(), {:tags_picked, values}) end}
              />
            </div>
            <.pp_typography id="tags-picked" variant="body-medium" color="on-surface-variant">
              Value: {inspect(@tags)}
            </.pp_typography>
          </.demo_group>
        </.section>

        <.section
          title="Upload"
          api={[{PhoenixPaper.Upload, :pp_upload}]}
          description="LiveView uploads (live_file_input) as an MD3 drop zone: an outline-variant area with a tonal browse button that shows MD3's dragged state while files are over it, then one row per file with an image preview or document icon, a linear progress bar, its errors as text and a cancel button (on_cancel, phx-value-ref). It needs allow_upload/3 in mount and a form with phx-change, LiveView's own requirements."
          code={upload_code()}
        >
          <.demo_group
            label="Try it: up to 3 JPG, PNG or PDF files (nothing is stored)"
            direction="column"
          >
            <.form
              for={%{}}
              id="upload-form"
              phx-change="validate_upload"
              phx-submit="save_upload"
              class="flex w-full max-w-lg flex-col gap-4"
            >
              <.pp_upload
                upload={@uploads.demo_files}
                on_cancel="cancel_upload"
                supporting_text="JPG, PNG or PDF, up to 8 MB each"
              />
              <div class="flex items-center justify-end gap-2">
                <.pp_typography
                  :if={@uploaded != []}
                  id="uploaded-names"
                  variant="body-small"
                  color="on-surface-variant"
                  class="me-auto"
                >
                  Last upload: {Enum.join(@uploaded, ", ")}
                </.pp_typography>
                <.pp_button id="upload-submit" type="submit">Upload</.pp_button>
              </div>
            </.form>
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

    <.pp_text_field multiline rows={3} label="Bio" name="bio" />

    <%!-- Input chips inside the field: pass :chips only when there are some --%>
    <.pp_text_field id="to" name="q" label="To">
      <:chips :if={@recipients != []}>
        <.pp_chip
          :for={r <- @recipients}
          variant="input"
          deletable
          on_delete={JS.push("remove_recipient", value: %{name: r})}
        >
          {r}
        </.pp_chip>
      </:chips>
    </.pp_text_field>\
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

  defp login_form_code do
    String.trim_trailing(~S'''
    <.pp_card class="w-full max-w-sm">
      <:title>Sign in</:title>
      <.form for={@form} id="login-form" phx-change="validate" phx-submit="login" class="mt-4 flex flex-col gap-4">
        <.pp_text_field field={@form[:email]} type="email" label="Email" autocomplete="username" />
        <.pp_password_field field={@form[:password]} label="Password" autocomplete="current-password" />
        <.pp_checkbox field={@form[:remember_me]} label="Keep me signed in" />
        <div class="flex items-center justify-between gap-2">
          <.pp_button variant="text" navigate={~p"/users/reset-password"}>Forgot password?</.pp_button>
          <.pp_button type="submit" phx-disable-with="Signing in...">Sign in</.pp_button>
        </div>
      </.form>
    </.pp_card>

    # In the LiveView: an ordinary changeset-backed form
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :form, to_form(Accounts.change_user_login(%User{})))}
    end

    def handle_event("validate", %{"user" => params}, socket) do
      changeset = Accounts.change_user_login(%User{}, params)
      {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
    end
    ''')
  end

  defp number_field_code do
    """
    <.pp_number_field field={@form[:quantity]} label="Quantity" min={0} max={10} />
    <.pp_number_field label="Amount" name="amount" step={0.5} variant="filled" />\
    """
  end

  defp autocomplete_code do
    String.trim_trailing(~S'''
    <.form for={@form} id="address-form" phx-change="validate">
      <.live_component
        module={PhoenixPaper.Autocomplete}
        id="country"
        field={@form[:country]}
        label="Country"
        options={[{"Canada", "ca"}, {"México", "mx"}, {"United States", "us"}]}
      />
    </.form>

    <%!-- Outside a form: on_change runs in the LiveView process --%>
    <.live_component
      module={PhoenixPaper.Autocomplete}
      id="country-filter"
      name="country"
      label="Country"
      options={@countries}
      on_change={fn value -> send(self(), {:country_picked, value}) end}
    />

    <%!-- Several values as input chips; drop the "" sentinel when casting --%>
    <.live_component
      module={PhoenixPaper.Autocomplete}
      id="tags"
      field={@form[:tags]}
      label="Tags"
      options={@all_tags}
      multiple
    />
    ''')
  end

  defp password_field_code do
    """
    <.pp_password_field field={@form[:password]} label="Password" autocomplete="current-password" />
    <.pp_password_field name="new_password" label="New password" variant="filled" supporting_text="At least 12 characters" />\
    """
  end

  defp upload_code do
    String.trim_trailing(~S'''
    <.form for={@form} id="photos-form" phx-change="validate" phx-submit="save">
      <.pp_upload upload={@uploads.photos} on_cancel="cancel_upload" supporting_text="JPG or PNG, up to 8 MB" />
      <.pp_button type="submit">Upload</.pp_button>
    </.form>

    # In the LiveView
    def mount(_params, _session, socket) do
      {:ok, allow_upload(socket, :photos, accept: ~w(.jpg .png), max_entries: 3)}
    end

    def handle_event("cancel_upload", %{"ref" => ref}, socket),
      do: {:noreply, cancel_upload(socket, :photos, ref)}
    ''')
  end

  defp tag_options do
    ~w(elixir phoenix liveview ecto tailwind erlang otp nerves)
  end

  defp countries do
    [
      {"Argentina", "ar"},
      {"Brasil", "br"},
      {"Canada", "ca"},
      {"Colombia", "co"},
      {"España", "es"},
      {"France", "fr"},
      {"Japan", "jp"},
      {"México", "mx"},
      {"Perú", "pe"},
      {"United States", "us"}
    ]
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
