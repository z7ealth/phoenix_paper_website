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
          PhoenixPaper.Input, PhoenixPaper.NumberField, PhoenixPaper.Select, and
          PhoenixPaper.Slider. Every one of these also accepts a field from
          to_form/2, the same way a generated core_components.ex input does.
        </p>

        <.section
          title="Input"
          description="A text field with a floating label, pure CSS, no JavaScript. Two variants: outlined and filled."
        >
          <.demo_group label="Outlined" class="items-start">
            <.pp_input name="name" label="Full name" />
            <.pp_input name="email" type="email" label="Email" helper_text="We'll never share it." />
          </.demo_group>

          <.demo_group label="Filled">
            <.pp_input name="company" label="Company" variant="filled" />
          </.demo_group>

          <.demo_group label="States" class="items-start">
            <.pp_input name="disabled" label="Disabled" disabled />
            <.pp_input name="invalid" label="Username" errors={["is already taken"]} />
          </.demo_group>
        </.section>

        <.section
          title="Number Field"
          description="A numeric input with increment / decrement stepper buttons."
        >
          <.demo_group label="Variants">
            <.pp_number_field name="quantity" label="Quantity" value={1} min={0} max={10} />
            <.pp_number_field name="seats" label="Seats" variant="filled" value={4} />
          </.demo_group>
        </.section>

        <.section title="Select" description="A native select styled to match Input's variants.">
          <.demo_group label="Variants">
            <.pp_select
              name="country"
              label="Country"
              options={["Canada", "Mexico", "United States"]}
            />
            <.pp_select
              name="plan"
              label="Plan"
              variant="filled"
              prompt="Choose one"
              options={["Starter", "Pro", "Enterprise"]}
            />
          </.demo_group>
        </.section>

        <.section
          title="Slider"
          description="A native range input colored via the CSS accent-color property, so it stays consistent across browser engines."
        >
          <.demo_group label="Colors">
            <.pp_stack spacing={:lg} class="w-full max-w-sm">
              <.pp_slider name="volume" label="Volume" value={60} />
              <.pp_slider name="brightness" label="Brightness" color="secondary" value={35} />
              <.pp_slider name="contrast" label="Contrast" color="tertiary" value={80} />
            </.pp_stack>
          </.demo_group>
        </.section>

        <.section
          eyebrow="Live component"
          title="Autocomplete"
          description="A text field with a filtered dropdown, filtered entirely server-side over phx-change/phx-debounce. Unlike everything above, this needs interactive state, so it's a Phoenix.LiveComponent — fully live on this page, since it's a real LiveView. Type to filter."
        >
          <.demo_group label="Try it">
            <.pp_box class="w-full max-w-sm">
              <.live_component
                module={PhoenixPaper.Autocomplete}
                id="country-autocomplete"
                name="country"
                label="Country"
                options={["Canada", "Mexico", "United States", "Colombia", "Brazil", "Argentina"]}
              />
            </.pp_box>
          </.demo_group>
        </.section>

        <.section
          eyebrow="Live component"
          title="Transfer List"
          description="Two list boxes with buttons to move checked items between them, state managed entirely inside the component. Also a Phoenix.LiveComponent — try checking a permission and moving it across."
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
end
