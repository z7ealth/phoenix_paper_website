defmodule PhoenixPaperWebsiteWeb.Components.SurfacesLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Surfaces")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:surfaces}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Surfaces</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Paper, Typography, and Accordion.
        </p>

        <.section
          title="Paper"
          description="The base surface (a background, an elevation shadow, and rounded corners). No padding, no slots. Card is built by composing this instead of duplicating its classes."
          props={[
            {"elevation", "resting elevation, 0-24 (default: 1)"},
            {"shape", "corner radius token (default: :lg)"},
            {"component",
             "overrides the data-pp-component marker, used by components like Card (default: \"paper\")"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={paper_code()}
        >
          <.demo_group label="Try it">
            <.pp_paper elevation={4} class="p-4">
              A raised surface: Card is built on this.
            </.pp_paper>
          </.demo_group>
        </.section>

        <.section
          title="Typography"
          description="variant picks both the rendered tag and the text classes together: h1..h6, subtitle1/2, body1/2, caption, overline, button, code."
          props={[
            {"variant",
             "h1..h6 | subtitle1 | subtitle2 | body1 | body2 | caption | overline | button | code (default: body1)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={typography_code()}
        >
          <.demo_group label="Scale" class="flex-col items-start gap-2">
            <.pp_typography variant="h1">h1. Heading</.pp_typography>
            <.pp_typography variant="h2">h2. Heading</.pp_typography>
            <.pp_typography variant="h3">h3. Heading</.pp_typography>
            <.pp_typography variant="h4">h4. Heading</.pp_typography>
            <.pp_typography variant="h5">h5. Heading</.pp_typography>
            <.pp_typography variant="h6">h6. Heading</.pp_typography>
            <.pp_typography variant="subtitle1">
              subtitle1. Manage your profile, notifications, and billing.
            </.pp_typography>
            <.pp_typography variant="subtitle2">
              subtitle2. Manage your profile, notifications, and billing.
            </.pp_typography>
            <.pp_typography variant="body1">
              body1. Manage your profile, notifications, and billing.
            </.pp_typography>
            <.pp_typography variant="body2">
              body2. Manage your profile, notifications, and billing.
            </.pp_typography>
            <.pp_typography variant="caption">caption. Last updated 2 minutes ago</.pp_typography>
            <.pp_typography variant="overline">overline. New</.pp_typography>
            <.pp_typography variant="button">button. Save changes</.pp_typography>
            <.pp_typography variant="code">mix phx.new my_app</.pp_typography>
          </.demo_group>
        </.section>

        <.section
          title="Accordion"
          description="Pure CSS, no JS/LiveView: the same hidden-checkbox-plus-peer-checked trick as Drawer/Rating. AccordionSummary/Details/Actions all need the same id as their parent Accordion, to build the matching for=/peer-checked wiring."
          props={[
            {"id", "required: shared with AccordionSummary/Details/Actions"},
            {"name", "shared across accordions for an exclusive group (radio instead of checkbox)"},
            {"default_expanded", "boolean, initial checked state, uncontrolled (default: false)"},
            {"disabled", "boolean (default: false)"},
            {"disable_gutters", "boolean, skip the extra margin an expanded accordion normally gets"},
            {"elevation / shape / paperize", "same as Card; Accordion is a Paper underneath"}
          ]}
          code={accordion_code()}
        >
          <.demo_group label="Try it" class="flex-col items-stretch">
            <.pp_accordion id="acc1-demo">
              <.pp_accordion_summary id="acc1-demo">Accordion 1</.pp_accordion_summary>
              <.pp_accordion_details id="acc1-demo">
                This is the content of the first accordion.
              </.pp_accordion_details>
              <.pp_accordion_actions id="acc1-demo">
                <.pp_button variant="text">Cancel</.pp_button>
                <.pp_button variant="text">Save</.pp_button>
              </.pp_accordion_actions>
            </.pp_accordion>
            <.pp_accordion id="acc2-demo" default_expanded>
              <.pp_accordion_summary id="acc2-demo">
                Accordion 2 (default expanded)
              </.pp_accordion_summary>
              <.pp_accordion_details id="acc2-demo">This one starts open.</.pp_accordion_details>
            </.pp_accordion>
            <.pp_accordion id="acc3-demo" disabled>
              <.pp_accordion_summary id="acc3-demo">Accordion 3 (disabled)</.pp_accordion_summary>
              <.pp_accordion_details id="acc3-demo">Can't be opened.</.pp_accordion_details>
            </.pp_accordion>
          </.demo_group>

          <.demo_group
            label="Exclusive group (radios, name=&quot;faq-demo&quot;)"
            class="flex-col items-stretch"
          >
            <.pp_accordion id="faq1-demo" name="faq-demo">
              <.pp_accordion_summary id="faq1-demo">FAQ 1</.pp_accordion_summary>
              <.pp_accordion_details id="faq1-demo">Answer 1</.pp_accordion_details>
            </.pp_accordion>
            <.pp_accordion id="faq2-demo" name="faq-demo">
              <.pp_accordion_summary id="faq2-demo">FAQ 2</.pp_accordion_summary>
              <.pp_accordion_details id="faq2-demo">Answer 2</.pp_accordion_details>
            </.pp_accordion>
            <.pp_accordion id="faq3-demo" name="faq-demo">
              <.pp_accordion_summary id="faq3-demo">FAQ 3</.pp_accordion_summary>
              <.pp_accordion_details id="faq3-demo">Answer 3</.pp_accordion_details>
            </.pp_accordion>
          </.demo_group>
          <p class="text-sm text-pp-on-surface/60">
            A checked radio can't be unchecked by clicking it again (an HTML limitation), so an
            exclusive group can't return to "all collapsed": a known, permanent difference from
            MUI's JS-driven version, not a bug.
          </p>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp paper_code do
    """
    <.pp_paper elevation={4} class="p-4">A raised surface: Card is built on this.</.pp_paper>\
    """
  end

  defp typography_code do
    """
    <.pp_typography variant="h1">h1. Heading</.pp_typography>
    <.pp_typography variant="h2">h2. Heading</.pp_typography>
    <.pp_typography variant="h3">h3. Heading</.pp_typography>
    <.pp_typography variant="h4">h4. Heading</.pp_typography>
    <.pp_typography variant="h5">h5. Heading</.pp_typography>
    <.pp_typography variant="h6">h6. Heading</.pp_typography>
    <.pp_typography variant="subtitle1">subtitle1. Manage your profile, notifications, and billing.</.pp_typography>
    <.pp_typography variant="subtitle2">subtitle2. Manage your profile, notifications, and billing.</.pp_typography>
    <.pp_typography variant="body1">body1. Manage your profile, notifications, and billing.</.pp_typography>
    <.pp_typography variant="body2">body2. Manage your profile, notifications, and billing.</.pp_typography>
    <.pp_typography variant="caption">caption. Last updated 2 minutes ago</.pp_typography>
    <.pp_typography variant="overline">overline. New</.pp_typography>
    <.pp_typography variant="button">button. Save changes</.pp_typography>
    <.pp_typography variant="code">mix phx.new my_app</.pp_typography>\
    """
  end

  defp accordion_code do
    """
    <.pp_accordion id="acc1">
      <.pp_accordion_summary id="acc1">Accordion 1</.pp_accordion_summary>
      <.pp_accordion_details id="acc1">
        This is the content of the first accordion.
      </.pp_accordion_details>
      <.pp_accordion_actions id="acc1">
        <.pp_button variant="text">Cancel</.pp_button>
        <.pp_button variant="text">Save</.pp_button>
      </.pp_accordion_actions>
    </.pp_accordion>

    <.pp_accordion id="acc2" default_expanded>
      <.pp_accordion_summary id="acc2">Accordion 2 (default expanded)</.pp_accordion_summary>
      <.pp_accordion_details id="acc2">This one starts open.</.pp_accordion_details>
    </.pp_accordion>

    <.pp_accordion id="acc3" disabled>
      <.pp_accordion_summary id="acc3">Accordion 3 (disabled)</.pp_accordion_summary>
      <.pp_accordion_details id="acc3">Can't be opened.</.pp_accordion_details>
    </.pp_accordion>

    <%!-- exclusive group: same name, radios instead of checkboxes --%>
    <.pp_accordion id="faq1" name="faq">
      <.pp_accordion_summary id="faq1">FAQ 1</.pp_accordion_summary>
      <.pp_accordion_details id="faq1">Answer 1</.pp_accordion_details>
    </.pp_accordion>
    <.pp_accordion id="faq2" name="faq">
      <.pp_accordion_summary id="faq2">FAQ 2</.pp_accordion_summary>
      <.pp_accordion_details id="faq2">Answer 2</.pp_accordion_details>
    </.pp_accordion>\
    """
  end
end
