defmodule PhoenixPaperWebsiteWeb.Components.DataDisplayLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias Phoenix.LiveView.JS

  # Small placeholder "photos" for the ImageList demo -- inline SVG data URIs
  # so the page stays fully self-contained, no external image fetch.
  @photo_1 ~s(data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="%233f51b5"/></svg>)
  @photo_2 ~s(data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="%23ff4081"/></svg>)
  @photo_3 ~s(data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="%23009688"/></svg>)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Data Display")
     |> assign(chips: ["React", "Elixir", "Phoenix", "LiveView"])
     |> assign(photo_1: @photo_1, photo_2: @photo_2, photo_3: @photo_3)}
  end

  # Table's sortable header cells are presentation-only -- this demo doesn't
  # actually reorder rows, just proves the click reaches the LiveView.
  def handle_event("sort", _params, socket), do: {:noreply, socket}

  def handle_event("delete_chip", %{"chip" => chip}, socket) do
    {:noreply, update(socket, :chips, &List.delete(&1, chip))}
  end

  def handle_event("select_filter", _params, socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:data_display}>
      <.pp_container max_width="lg">
        <.page_header eyebrow="Components" title="Data Display">
          PhoenixPaper.Card, Avatar, Badge, Chip, Tooltip, Icon, ImageList / ImageListItem, and
          the Table family.
        </.page_header>

        <.section
          title="Card"
          description="A surface container with optional title and actions slots. Give it href, navigate or patch and the whole card becomes clickable (MUI's CardActionArea): the hover tint and focus ring cover the entire card, and a click anywhere except on an action button follows the link. :actions stay outside the <a> (valid HTML); the link is stretched over the card and the actions sit above it."
          props={[
            {"href / navigate / patch",
             "makes the whole card clickable: a plain href, a LiveView navigation, or a patch (default: nil)"},
            {"ripple", "the Material ripple on click in link mode (default: true)"},
            {"target / rel",
             "link mode: forwarded to the link, e.g. target=\"_blank\" rel=\"noopener\" (default: nil)"},
            {"elevation", "resting elevation, 0-24 (default: 1)"},
            {"padding", "a Spacing token (default: :md)"},
            {"shape", "corner radius token (default: :lg)"},
            {"paperize", "boolean (default: true)"}
          ]}
          slots={[{":title", "a heading above the body"}, {":actions", "trailing buttons"}]}
          code={card_code()}
        >
          <.demo_group label="Basic" class="items-start">
            <.pp_card class="w-72">
              <:title>Account</:title>
              You have no pending invoices this month.
              <:actions>
                <.pp_button variant="text">Dismiss</.pp_button>
              </:actions>
            </.pp_card>
          </.demo_group>

          <.demo_group label="Link mode (navigate)" class="items-start">
            <.pp_card id="card-link-demo" navigate="/components/layout" class="w-72">
              <:title>Layout components</:title>
              Box, Container, Stack, Grid, Divider. Click anywhere on the card except the button.
              <:actions>
                <.pp_button variant="text" href="/components/surfaces">Surfaces</.pp_button>
              </:actions>
            </.pp_card>
          </.demo_group>

          <.demo_group label="Padding tokens">
            <.pp_card
              :for={padding <- ~w(none xs sm md lg xl 2xl)a}
              padding={padding}
              class="w-24 text-center text-xs"
            >
              {padding}
            </.pp_card>
          </.demo_group>
        </.section>

        <.section
          title="Avatar"
          description="A user's profile picture, initials, or icon, in the spirit of MUI's Avatar. No src falls back to the :inner_block slot (initials or an icon); no :inner_block either falls back further, to a generic person icon. A broken image also falls back to the same slot underneath it: a small vanilla onerror, no JS hook, no LiveView round-trip."
          props={[
            {"src / alt", "an image, with alt text (default: nil, falls back to :inner_block)"},
            {"color",
             "default | primary | secondary | accent | error (default: default, neutral grey): the fallback's background and foreground"},
            {"variant", "circular | rounded | square (default: circular)"},
            {"size", "small | medium | large (default: medium)"},
            {"paperize", "boolean (default: true)"}
          ]}
          slots={[
            {":inner_block", "initials or an icon: shown with no src, or if the image fails to load"}
          ]}
          code={avatar_code()}
        >
          <.demo_group label="Fallback chain: image, initials, icon">
            <.pp_avatar src={@photo_1} alt="A placeholder photo" />
            <.pp_avatar>OP</.pp_avatar>
            <.pp_avatar />
          </.demo_group>

          <.demo_group label="color">
            <.pp_avatar :for={color <- ~w(default primary secondary accent error)} color={color}>
              <.pp_icon name="hero-sparkles" />
            </.pp_avatar>
          </.demo_group>

          <.demo_group label="variant">
            <.pp_avatar variant="circular">OP</.pp_avatar>
            <.pp_avatar variant="rounded">OP</.pp_avatar>
            <.pp_avatar variant="square">OP</.pp_avatar>
          </.demo_group>

          <.demo_group label="size">
            <.pp_avatar size="small">OP</.pp_avatar>
            <.pp_avatar size="medium">OP</.pp_avatar>
            <.pp_avatar size="large">OP</.pp_avatar>
          </.demo_group>
        </.section>

        <.section
          title="Badge"
          description="A small count/status indicator overlapping the corner of its child, in the spirit of MUI's Badge."
          props={[
            {"content", "badge content: a number or short string (default: nil)"},
            {"max", "caps a numeric content at max+, e.g. 99+ (default: 99)"},
            {"show_zero", "show the badge when content is the integer 0 (default: false)"},
            {"variant", "standard | dot (default: standard)"},
            {"color",
             "primary | secondary | accent | error | success | warning | info (default: error)"},
            {"overlap",
             "rectangular | circular, pulls the badge inward onto a circular child (default: rectangular)"},
            {"anchor_origin", "which corner (default: top-right)"},
            {"invisible", "force-hide the badge (default: false)"}
          ]}
          code={badge_code()}
        >
          <.demo_group label="Variants">
            <.pp_badge content={4}>
              <.pp_icon name="hero-bell" />
            </.pp_badge>
            <.pp_badge content={150}>
              <.pp_icon name="hero-bell" />
            </.pp_badge>
            <.pp_badge variant="dot" color="success">
              <.pp_icon name="hero-user" />
            </.pp_badge>
            <.pp_badge content={1} overlap="circular" color="primary">
              <.pp_avatar />
            </.pp_badge>
          </.demo_group>
        </.section>

        <.section
          title="Chip"
          description="A compact element for input, attribute, or action, in the spirit of MUI's Chip."
          props={[
            {"variant", "filled | outlined (default: filled)"},
            {"color",
             "default | primary | secondary | accent | error | success | warning | info (default: default)"},
            {"size", "small | medium (default: medium)"},
            {"clickable",
             "renders a real button with a ripple, for filter/action chips (default: false)"},
            {"deletable", "renders a trailing delete control wired to on_delete (default: false)"},
            {"on_delete", "JS command run when the delete control is clicked"},
            {"disabled", "dims and disables the chip and its delete control (default: false)"}
          ]}
          slots={[{":icon", "a leading icon or avatar"}]}
          code={chip_code()}
        >
          <.demo_group label="Variants">
            <.pp_chip>Basic</.pp_chip>
            <.pp_chip variant="outlined" color="primary">Outlined</.pp_chip>
            <.pp_chip color="success">Success</.pp_chip>
            <.pp_chip size="small">Small</.pp_chip>
            <.pp_chip>
              Tagged
              <:icon><.pp_icon name="hero-check" /></:icon>
            </.pp_chip>
          </.demo_group>

          <.demo_group label="Deletable, clickable">
            <.pp_chip
              :for={tag <- @chips}
              deletable
              on_delete={JS.push("delete_chip", value: %{chip: tag})}
            >
              {tag}
            </.pp_chip>
            <.pp_chip clickable phx-click="select_filter">Clickable</.pp_chip>
            <.pp_chip clickable disabled>Disabled</.pp_chip>
          </.demo_group>
        </.section>

        <.section
          title="Tooltip"
          description="A short text label shown on hover/focus, in the spirit of MUI's Tooltip. Pure CSS (group-hover/group-focus-within): no JS, no collision detection/auto-flip. Styled with the same attrs as Button: color, variant, size and shape; the arrow matches the bubble, outlined border included."
          props={[
            {"title", "the tooltip text: nil or \"\" disables the tooltip (default: nil)"},
            {"placement", "top | bottom | left | right (default: top)"},
            {"arrow", "a small triangle pointing at the trigger (default: false)"},
            {"color",
             "default | primary | secondary | accent | error (default: default, the inverted Material tooltip)"},
            {"variant", "raised | flat | outlined (default: raised)"},
            {"size", "small | medium | large (default: medium)"},
            {"shape", "corner radius token (default: :sm)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={tooltip_code()}
        >
          <.demo_group label="Try hovering">
            <.pp_tooltip title="Delete">
              <.pp_button variant="icon"><.pp_icon name="hero-trash" /></.pp_button>
            </.pp_tooltip>
            <.pp_tooltip title="Bottom" placement="bottom">
              <.pp_button variant="outlined">Bottom</.pp_button>
            </.pp_tooltip>
            <.pp_tooltip title="With an arrow" arrow>
              <.pp_button variant="outlined">Arrow</.pp_button>
            </.pp_tooltip>
          </.demo_group>

          <.demo_group label="color (hover each)">
            <.pp_tooltip
              :for={color <- ~w(default primary secondary accent error)}
              title={color}
              color={color}
              arrow
            >
              <.pp_button variant="outlined">{color}</.pp_button>
            </.pp_tooltip>
          </.demo_group>

          <.demo_group label="variant, size and shape">
            <.pp_tooltip
              :for={variant <- ~w(raised flat outlined)}
              title={variant}
              variant={variant}
              color="primary"
              arrow
            >
              <.pp_button variant="text">{variant}</.pp_button>
            </.pp_tooltip>
            <.pp_tooltip :for={size <- ~w(small medium large)} title={"size: #{size}"} size={size}>
              <.pp_button variant="text">{size}</.pp_button>
            </.pp_tooltip>
            <.pp_tooltip title="shape: :full" shape={:full}>
              <.pp_button variant="text">full</.pp_button>
            </.pp_tooltip>
          </.demo_group>
        </.section>

        <.section
          title="Icon"
          description="Just renders the app's existing heroicon classes: no bundled icon set, no extra dependency."
          props={[
            {"name", "a heroicon class, e.g. \"hero-check\" (required)"},
            {"paperize", "boolean, only affects default sizing, not which icon shows (default: true)"}
          ]}
          code={icon_code()}
        >
          <.demo_group label="Try it">
            <.pp_icon name="hero-check" class="text-pp-accent" />
            <.pp_icon name="hero-star" class="text-pp-secondary" />
            <.pp_icon name="hero-home" class="text-pp-primary" />
            <.pp_icon name="hero-bell" class="text-pp-error" />
          </.demo_group>
        </.section>

        <.section
          title="Image List"
          description="A grid gallery of images, in the spirit of MUI's ImageList (the standard variant; masonry/quilted/woven aren't implemented). Tiles below are generated placeholder SVGs, not real photos."
          props={[
            {"pp_image_list cols", "1-6 (default: 3)"},
            {"pp_image_list_item src / alt", "the image"},
            {"pp_image_list_item title / subtitle",
             "an overlay bar along the bottom edge, omitted if no title"}
          ]}
          code={image_list_code()}
        >
          <.demo_group label="cols={3}" direction="column">
            <.pp_image_list cols={3}>
              <.pp_image_list_item src={@photo_1} title="Breakfast" />
              <.pp_image_list_item src={@photo_2} title="Burger" subtitle="Restaurant" />
              <.pp_image_list_item src={@photo_3} />
            </.pp_image_list>
          </.demo_group>
        </.section>

        <.section
          title="Table"
          description="A family of small components: Table, TableContainer, TableHead, TableBody, TableRow, TableCell, TableFooter, composed by hand like MUI's own Table parts. dense/sticky_header/striped cascade to descendant cells via CSS, not a prop threaded through every cell."
          props={[
            {"pp_table dense / sticky_header",
             "tighter cell padding / pins the header while scrolling"},
            {"pp_table_body striped", "alternating row background"},
            {"pp_table_row selected", "a stronger, persistent highlight"},
            {"pp_table_cell variant", "head (th) | body (td, default)"},
            {"pp_table_cell align", "left | center | right"},
            {"pp_table_cell sortable / sort_direction",
             "a clickable header arrow: wire your own phx-click, presentation only"}
          ]}
          code={table_code()}
        >
          <.demo_group label="Try it" direction="column">
            <.pp_table_container>
              <.pp_table>
                <.pp_table_head>
                  <.pp_table_row>
                    <.pp_table_cell variant="head" sortable sort_direction="asc" phx-click="sort">
                      Dessert
                    </.pp_table_cell>
                    <.pp_table_cell variant="head" align="right" sortable phx-click="sort">
                      Calories
                    </.pp_table_cell>
                    <.pp_table_cell variant="head" align="right">Fat (g)</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_head>
                <.pp_table_body striped>
                  <.pp_table_row>
                    <.pp_table_cell>Frozen yoghurt</.pp_table_cell>
                    <.pp_table_cell align="right">159</.pp_table_cell>
                    <.pp_table_cell align="right">6.0</.pp_table_cell>
                  </.pp_table_row>
                  <.pp_table_row selected>
                    <.pp_table_cell>Ice cream sandwich</.pp_table_cell>
                    <.pp_table_cell align="right">237</.pp_table_cell>
                    <.pp_table_cell align="right">9.0</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_body>
                <.pp_table_footer>
                  <.pp_table_row>
                    <.pp_table_cell>Total</.pp_table_cell>
                    <.pp_table_cell align="right">396</.pp_table_cell>
                    <.pp_table_cell align="right">15.0</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_footer>
              </.pp_table>
            </.pp_table_container>
          </.demo_group>

          <.demo_group label="dense + sticky_header (scroll the box)" direction="column">
            <.pp_table_container class="max-h-40 overflow-y-auto">
              <.pp_table dense sticky_header>
                <.pp_table_head>
                  <.pp_table_row>
                    <.pp_table_cell variant="head">Dessert</.pp_table_cell>
                    <.pp_table_cell variant="head" align="right">Calories</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_head>
                <.pp_table_body>
                  <.pp_table_row :for={
                    {name, cal} <- [
                      {"Frozen yoghurt", 159},
                      {"Ice cream sandwich", 237},
                      {"Eclair", 262},
                      {"Cupcake", 305},
                      {"Gingerbread", 356}
                    ]
                  }>
                    <.pp_table_cell>{name}</.pp_table_cell>
                    <.pp_table_cell align="right">{cal}</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_body>
              </.pp_table>
            </.pp_table_container>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp card_code do
    """
    <.pp_card>
      <:title>Account</:title>
      You have no pending invoices.
      <:actions>
        <.pp_button variant="text">Dismiss</.pp_button>
      </:actions>
    </.pp_card>

    <.pp_card :for={padding <- ~w(none xs sm md lg xl 2xl)a} padding={padding}>
      padding: {padding}
    </.pp_card>

    <%!-- The whole card is clickable; :actions stay outside the link --%>
    <.pp_card navigate={~p"/components/layout"}>
      <:title>Layout components</:title>
      Box, Container, Stack, Grid, Divider.
      <:actions>
        <.pp_button variant="text" href={~p"/components/surfaces"}>Surfaces</.pp_button>
      </:actions>
    </.pp_card>\
    """
  end

  defp avatar_code do
    """
    <.pp_avatar src="/images/1.jpg" alt="A profile photo" />
    <.pp_avatar>OP</.pp_avatar>
    <.pp_avatar />

    <.pp_avatar variant="rounded">OP</.pp_avatar>
    <.pp_avatar variant="square">OP</.pp_avatar>

    <.pp_avatar size="small">OP</.pp_avatar>
    <.pp_avatar size="large">OP</.pp_avatar>

    <.pp_avatar :for={color <- ~w(default primary secondary accent error)} color={color}>
      <.pp_icon name="hero-sparkles" />
    </.pp_avatar>\
    """
  end

  defp badge_code do
    """
    <.pp_badge content={4}>
      <.pp_icon name="hero-bell" />
    </.pp_badge>

    <.pp_badge content={150}>
      <.pp_icon name="hero-bell" />
    </.pp_badge>

    <.pp_badge variant="dot" color="success">
      <.pp_icon name="hero-user" />
    </.pp_badge>

    <%!-- overlap="circular" pulls the badge inward to sit on a circular avatar --%>
    <.pp_badge content={1} overlap="circular" color="primary">
      <.pp_avatar />
    </.pp_badge>\
    """
  end

  defp chip_code do
    """
    <.pp_chip>Basic</.pp_chip>
    <.pp_chip variant="outlined" color="primary">Outlined</.pp_chip>
    <.pp_chip color="success">Success</.pp_chip>
    <.pp_chip size="small">Small</.pp_chip>

    <.pp_chip>
      Tagged
      <:icon><.pp_icon name="hero-check" /></:icon>
    </.pp_chip>

    <.pp_chip
      :for={tag <- @chips}
      deletable
      on_delete={JS.push("delete_chip", value: %{chip: tag})}
    >
      {tag}
    </.pp_chip>

    <.pp_chip clickable phx-click="select_filter">Clickable</.pp_chip>
    <.pp_chip clickable disabled>Disabled</.pp_chip>\
    """
  end

  defp tooltip_code do
    """
    <.pp_tooltip title="Delete">
      <.pp_button variant="icon"><.pp_icon name="hero-trash" /></.pp_button>
    </.pp_tooltip>

    <.pp_tooltip title="Bottom" placement="bottom">
      <.pp_button variant="outlined">Bottom</.pp_button>
    </.pp_tooltip>

    <.pp_tooltip title="With an arrow" arrow>
      <.pp_button variant="outlined">Arrow</.pp_button>
    </.pp_tooltip>

    <%!-- Same styling attrs as pp_button --%>
    <.pp_tooltip title="Saved" color="accent" variant="outlined" size="large" shape={:full} arrow>
      <.pp_button variant="outlined">Styled</.pp_button>
    </.pp_tooltip>\
    """
  end

  defp icon_code do
    """
    <.pp_icon name="hero-check" class="text-pp-accent" />\
    """
  end

  defp image_list_code do
    """
    <.pp_image_list cols={3}>
      <.pp_image_list_item src="/images/1.jpg" title="Breakfast" />
      <.pp_image_list_item src="/images/2.jpg" title="Burger" subtitle="Restaurant" />
    </.pp_image_list>\
    """
  end

  defp table_code do
    """
    <.pp_table_container>
      <.pp_table>
        <.pp_table_head>
          <.pp_table_row>
            <.pp_table_cell variant="head" sortable sort_direction="asc" phx-click="sort">Dessert</.pp_table_cell>
            <.pp_table_cell variant="head" align="right" sortable phx-click="sort">Calories</.pp_table_cell>
            <.pp_table_cell variant="head" align="right">Fat (g)</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_head>
        <.pp_table_body striped>
          <.pp_table_row>
            <.pp_table_cell>Frozen yoghurt</.pp_table_cell>
            <.pp_table_cell align="right">159</.pp_table_cell>
            <.pp_table_cell align="right">6.0</.pp_table_cell>
          </.pp_table_row>
          <.pp_table_row selected>
            <.pp_table_cell>Ice cream sandwich</.pp_table_cell>
            <.pp_table_cell align="right">237</.pp_table_cell>
            <.pp_table_cell align="right">9.0</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_body>
        <.pp_table_footer>
          <.pp_table_row>
            <.pp_table_cell>Total</.pp_table_cell>
            <.pp_table_cell align="right">396</.pp_table_cell>
            <.pp_table_cell align="right">15.0</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_footer>
      </.pp_table>
    </.pp_table_container>\
    """
  end
end
