defmodule PhoenixPaperWebsiteWeb.CustomizingLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Customizing")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:customizing}>
      <.pp_container max_width="lg">
        <.page_header eyebrow="Guide" title="Customizing">
          Every PhoenixPaper component takes a class attribute for your own Tailwind utilities.
          It adds to the component's built-in classes, it doesn't replace them. This page covers
          when that's enough, when you need Tailwind's ! modifier, and when an attr or {"paperize={false}"} is the better tool. For colors, see the
          <.link navigate={~p"/theming"} class="text-pp-primary hover:underline">Theming</.link>
          guide.
        </.page_header>

        <.section
          title="class adds, it doesn't replace"
          description="Your class is appended to the component's own classes, with no merging step. When yours and a built-in one set the same CSS property (two background colors, two flex directions), both end up on the element, and Tailwind decides the winner by the order the utilities appear in the generated stylesheet, not by the order you wrote them. So the override silently loses about half the time."
          code={adds_code()}
        >
          <.demo_group
            label="A row-direction Stack, three ways to make it a column"
            direction="column"
          >
            <.pp_stack direction="row" spacing={:sm} wrap class="items-center">
              <.pp_typography variant="code" class="w-48 shrink-0">class="flex-col"</.pp_typography>
              <.pp_stack id="customizing-plain" direction="row" spacing={:sm} class="flex-col">
                <.pp_chip>One</.pp_chip>
                <.pp_chip>Two</.pp_chip>
                <.pp_chip>Three</.pp_chip>
              </.pp_stack>
            </.pp_stack>
            <.pp_stack direction="row" spacing={:sm} wrap class="items-center">
              <.pp_typography variant="code" class="w-48 shrink-0">class="!flex-col"</.pp_typography>
              <.pp_stack id="customizing-important" direction="row" spacing={:sm} class="!flex-col">
                <.pp_chip>One</.pp_chip>
                <.pp_chip>Two</.pp_chip>
                <.pp_chip>Three</.pp_chip>
              </.pp_stack>
            </.pp_stack>
            <.pp_stack direction="row" spacing={:sm} wrap class="items-center">
              <.pp_typography variant="code" class="w-48 shrink-0">direction="column"</.pp_typography>
              <.pp_stack id="customizing-attr" direction="column" spacing={:sm}>
                <.pp_chip>One</.pp_chip>
                <.pp_chip>Two</.pp_chip>
                <.pp_chip>Three</.pp_chip>
              </.pp_stack>
            </.pp_stack>
          </.demo_group>
          <.pp_typography variant="body2" color="muted">
            The first one stays a row: Stack already renders flex-row, and flex-row comes after
            flex-col in Tailwind's stylesheet. The ! version wins every time. The attr is the
            real fix: no conflict at all.
          </.pp_typography>
        </.section>

        <.section
          title="Adding utilities: just use class"
          description="Anything the component doesn't already set is safe as plain class: layout and spacing around it (margins, width, max-width, grid placement), positioning, a cursor, a transition. Nothing to override, so nothing to lose."
          code={adding_code()}
        >
          <.demo_group label="Width and margin the components don't set" direction="column">
            <.pp_button class="w-full">Full width (w-full)</.pp_button>
            <.pp_card class="mt-2 max-w-sm">
              <:title>max-w-sm</:title>
              A card capped at a width, with some top margin.
            </.pp_card>
          </.demo_group>
        </.section>

        <.section
          title="Replacing a built-in utility: the ! modifier"
          description="To change something the component already sets (its background, text color, padding, radius, display), prefix your utility with ! to make it !important. It then wins regardless of stylesheet order. Variants go in front of it: hover:!bg-rose-700, md:!px-8. Tailwind v4 also accepts the suffix form, bg-rose-600!; both work."
          code={important_code()}
        >
          <.demo_group label="A raised primary Button, recolored">
            <.pp_button>Default</.pp_button>
            <.pp_button class="!bg-rose-600 !text-white hover:!bg-rose-700">
              !bg-rose-600
            </.pp_button>
            <.pp_button variant="outlined" class="!rounded-none">!rounded-none</.pp_button>
          </.demo_group>
          <.pp_typography variant="body2" color="muted">
            Use it for the property you're replacing, not everything: a stray ! also beats your
            own responsive and state variants later. If you're reaching for several on one
            component, an attr or {"paperize={false}"} is probably the better tool.
          </.pp_typography>
        </.section>

        <.section
          title="Reach for an attr first"
          description="Most of what people try to override through class has an attr that does it properly, works with dark mode and the theme tokens, and never conflicts. Check the component's options table before writing an override."
        >
          <.pp_table_container id="customizing-attrs">
            <.pp_table dense>
              <.pp_table_head>
                <.pp_table_row>
                  <.pp_table_cell variant="head">Instead of class=...</.pp_table_cell>
                  <.pp_table_cell variant="head">Use</.pp_table_cell>
                </.pp_table_row>
              </.pp_table_head>
              <.pp_table_body>
                <.pp_table_row :for={{instead, use} <- attr_alternatives()}>
                  <.pp_table_cell>
                    <.pp_typography variant="code">{instead}</.pp_typography>
                  </.pp_table_cell>
                  <.pp_table_cell>
                    <.pp_typography variant="code">{use}</.pp_typography>
                  </.pp_table_cell>
                </.pp_table_row>
              </.pp_table_body>
            </.pp_table>
          </.pp_table_container>
        </.section>

        <.section
          title="paperize={false}: start from scratch"
          description="When you want a component's behavior but none of its look, pass paperize={false}. Every built-in class is dropped and only your class renders, so there's nothing to override and no ! needed. The structure the component needs to work (a checkbox's hidden input, a link vs. button root, ARIA attributes) stays."
          code={paperize_code()}
        >
          <.demo_group label="Same component, paperize on and off">
            <.pp_button>paperize: true</.pp_button>
            <.pp_button
              paperize={false}
              class="rounded-md border-2 border-dashed border-pp-secondary px-3 py-1 font-mono text-sm text-pp-secondary"
            >
              paperize: false
            </.pp_button>
          </.demo_group>
        </.section>

        <.section
          title="Styling inside a component"
          description="class lands on the component's root element. For the parts inside it, you have three options, in order of preference."
          code={inside_code()}
        >
          <.pp_list dense>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-adjustments-horizontal" /></:leading>
              A dedicated attr, where the component has one
              <:secondary>
                pp_collapse trigger_class / content_class, pp_menu trigger_class
              </:secondary>
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-squares-plus" /></:leading>
              Your own markup in a slot
              <:secondary>
                Slot content is yours: style it directly, or wrap it in an element you style
              </:secondary>
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-code-bracket" /></:leading>
              An arbitrary child variant on the root
              <:secondary>
                [&amp;_svg]:size-4 targets descendants; add ! if it collides with a built-in
              </:secondary>
            </.pp_list_item>
          </.pp_list>
        </.section>

        <.section
          title="Site-wide tweaks in app.css"
          description="To change a component everywhere at once, target its marker instead of editing every call site: each component renders a data-pp-component attribute (button, card, list-item, ...). Put the rule after the phoenix_paper import in app.css. For colors, change the --color-pp-* tokens instead (see Theming): they reach every component, in light and dark."
          code={site_wide_code()}
          code_language="css"
        >
        </.section>

        <.section title="Checklist" description="Before you write an override:">
          <.pp_list dense>
            <.pp_list_item :for={item <- checklist()}>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              {item}
            </.pp_list_item>
          </.pp_list>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp attr_alternatives do
    [
      {~s(class="flex-col" on pp_stack), ~s(direction="column")},
      {~s(class="gap-2" on pp_stack), "spacing={:sm}"},
      {~s(class="p-8" on pp_card), "padding={:xl}"},
      {~s(class="rounded-none"), "shape={:none}"},
      {~s(class="shadow-..."), "elevation={...}"},
      {~s(class="bg-pp-secondary ..."), ~s(color="secondary")},
      {~s(class="border ..." on pp_button), ~s(variant="outlined")},
      {~s(class="text-xs px-2" on pp_button), ~s(size="small")},
      {~s(class="!max-w-2xl" on pp_dialog), ~s(max_width="2xl")},
      {~s(class="size-4" on pp_icon), ~s(size="sm")},
      {~s(class="fixed bottom-6 right-6" on pp_fab),
       ~s(position="fixed" class="bottom-6 right-6")},
      {~s(class="text-pp-on-primary" on a button in a colored bar), ~s(color="inherit")}
    ]
  end

  defp checklist do
    [
      "Is there an attr for it? (color, variant, size, shape, elevation, padding, direction, spacing, max_width, ...)",
      "Is it a color? Change the --color-pp-* token in app.css instead.",
      "Does the component already set this property? If not, plain class is enough.",
      "If it does, prefix only that utility with ! (variants first: hover:!bg-...).",
      "Overriding most of the look? Use paperize={false} and style it yourself.",
      "Same tweak everywhere? One [data-pp-component=...] rule in app.css."
    ]
  end

  defp adds_code do
    """
    <%!-- Stays a row: Stack renders flex-row, which wins over your flex-col --%>
    <.pp_stack direction="row" class="flex-col">...</.pp_stack>

    <%!-- Wins: ! makes it !important --%>
    <.pp_stack direction="row" class="!flex-col">...</.pp_stack>

    <%!-- Best: the attr, no conflict --%>
    <.pp_stack direction="column">...</.pp_stack>\
    """
  end

  defp adding_code do
    """
    <%!-- Nothing built in to conflict with: plain class --%>
    <.pp_button class="w-full">Full width</.pp_button>

    <.pp_card class="mt-2 max-w-sm">
      <:title>max-w-sm</:title>
      A card capped at a width, with some top margin.
    </.pp_card>\
    """
  end

  defp important_code do
    """
    <%!-- Replacing the button's own background/text color: ! on each --%>
    <.pp_button class="!bg-rose-600 !text-white hover:!bg-rose-700">
      Delete
    </.pp_button>

    <%!-- Same for any built-in utility, e.g. the outlined button's radius --%>
    <.pp_button variant="outlined" class="!rounded-none">Square</.pp_button>\
    """
  end

  defp paperize_code do
    """
    <.pp_button
      paperize={false}
      class="rounded-md border-2 border-dashed px-3 py-1 font-mono text-sm"
    >
      Fully custom
    </.pp_button>\
    """
  end

  defp inside_code do
    """
    <%!-- 1. A dedicated attr --%>
    <.pp_collapse id="advanced" trigger_class="font-semibold">
      <:trigger>Advanced options</:trigger>
      ...
    </.pp_collapse>

    <%!-- 2. Your own markup in a slot --%>
    <.pp_card>
      <:title><span class="text-pp-primary">Billing</span></:title>
      ...
    </.pp_card>

    <%!-- 3. A child variant on the root (! if it collides) --%>
    <.pp_button variant="outlined" class="[&_svg]:!size-4">
      <:start_icon><.pp_icon name="hero-trash" /></:start_icon>
      Delete
    </.pp_button>\
    """
  end

  defp site_wide_code do
    ~S'''
    /* assets/css/app.css, after the phoenix_paper import */

    /* Every card: a thin outline */
    [data-pp-component="card"] {
      border: 1px solid color-mix(in srgb, var(--color-pp-outline) 20%, transparent);
    }

    /* Every button: no uppercase-ish tracking */
    [data-pp-component="button"] {
      letter-spacing: normal;
    }
    '''
    |> String.trim_trailing()
  end
end
