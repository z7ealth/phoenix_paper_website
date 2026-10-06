defmodule PhoenixPaperWebsiteWeb.CustomizingLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Customizing")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:customizing}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
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
          <.demo_group label="An elevated Card, three ways to give it the filled background">
            <.pp_card id="customizing-plain" class="w-56 bg-pp-surface-container-highest">
              <:title>class="bg-…-highest"</:title>
              Still surface-container-low.
            </.pp_card>
            <.pp_card id="customizing-important" class="w-56 !bg-pp-surface-container-highest">
              <:title>class="!bg-…-highest"</:title>
              Wins, but keeps the elevated shadow.
            </.pp_card>
            <.pp_card id="customizing-attr" variant="filled" class="w-56">
              <:title>variant="filled"</:title>
              MD3's filled card, no conflict.
            </.pp_card>
          </.demo_group>
          <.pp_typography variant="body-medium" color="on-surface-variant">
            The first one doesn't change: an elevated card already renders
            bg-pp-surface-container-low, which comes after -highest in Tailwind's stylesheet.
            The ! version wins every time, but only replaces the one property. The attr is the
            real fix: it switches the whole look, and nothing conflicts.
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
          <.demo_group label="A filled Button, recolored">
            <.pp_button>Default</.pp_button>
            <.pp_button class="!bg-rose-600 !text-white hover:!bg-rose-700">
              !bg-rose-600
            </.pp_button>
            <.pp_button variant="outlined" class="!rounded-none">!rounded-none</.pp_button>
          </.demo_group>
          <.pp_typography variant="body-medium" color="on-surface-variant">
            Use it for the property you're replacing, not everything: a stray ! also beats your
            own responsive and state variants later. If you're reaching for several on one
            component, an attr or {"paperize={false}"} is probably the better tool.
          </.pp_typography>
        </.section>

        <.section
          title="Reach for an attr first"
          description="Most of what people try to override through class has an attr that does it properly, works with dark mode and the theme tokens, and never conflicts. Check the component's options table before writing an override."
        >
          <div
            class="overflow-x-auto rounded-pp-md border border-pp-outline-variant"
            id="customizing-attrs"
          >
            <table class="pp-body-medium w-full border-collapse text-start text-pp-on-surface [&_td]:py-1.5 [&_th]:py-1.5">
              <thead class="[&_th]:border-b [&_th]:border-pp-outline-variant">
                <tr class="transition-colors hover:bg-pp-on-surface/8">
                  <th class="pp-title-small px-4 text-start">Instead of class=...</th>
                  <th class="pp-title-small px-4 text-start">Use</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  :for={{instead, use} <- attr_alternatives()}
                  class="transition-colors hover:bg-pp-on-surface/8"
                >
                  <td class="px-4 align-top">
                    <.pp_typography variant="code">{instead}</.pp_typography>
                  </td>
                  <td class="px-4 align-top">
                    <.pp_typography variant="code">{use}</.pp_typography>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
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
          <.pp_list>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-adjustments-horizontal" /></:leading>
              A dedicated attr, where the component has one
              <:secondary>
                pp_menu's trigger_class, for the element that opens it
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
          <.pp_list>
            <.pp_list_item :for={item <- checklist()}>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              {item}
            </.pp_list_item>
          </.pp_list>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp attr_alternatives do
    [
      {~s(class="rounded-lg" on pp_button), ~s(shape="square")},
      {~s(class="bg-pp-surface-container ..." on pp_card), ~s(variant="filled")},
      {~s(class="bg-pp-secondary-container ..." on pp_button), ~s(variant="tonal")},
      {~s(class="border ..." on pp_button), ~s(variant="outlined")},
      {~s(class="text-xs px-2" on pp_button), ~s(size="xs")},
      {~s(class="fixed inset-0" on pp_dialog), ~s(variant="fullscreen")},
      {~s(class="size-4" on pp_icon), ~s(size="sm")},
      {~s(class="fixed bottom-6 right-6" on pp_fab),
       ~s(position="fixed" class="bottom-6 right-6")},
      {~s(class="text-pp-on-primary" on a button in a colored bar), ~s(color="inherit")}
    ]
  end

  defp checklist do
    [
      "Is there an attr for it? (color, variant, size, shape, position, ...)",
      "Is it a color? Change the --color-pp-* token in app.css instead.",
      "Does the component already set this property? If not, plain class is enough.",
      "If it does, prefix only that utility with ! (variants first: hover:!bg-...).",
      "Overriding most of the look? Use paperize={false} and style it yourself.",
      "Same tweak everywhere? One [data-pp-component=...] rule in app.css."
    ]
  end

  defp adds_code do
    """
    <%!-- No change: the elevated card's own bg-pp-surface-container-low wins --%>
    <.pp_card class="bg-pp-surface-container-highest">...</.pp_card>

    <%!-- Wins: ! makes it !important (the shadow stays) --%>
    <.pp_card class="!bg-pp-surface-container-highest">...</.pp_card>

    <%!-- Best: the attr, no conflict --%>
    <.pp_card variant="filled">...</.pp_card>\
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
    <.pp_menu id="account-menu" trigger_class="ms-auto">
      ...
    </.pp_menu>

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
