defmodule PhoenixPaperWebsiteWeb.Components.DataDisplayLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias Phoenix.LiveView.JS

  # Small placeholder "photos" for the Card and Carousel demos -- inline SVG data URIs
  # so the page stays fully self-contained, no external image fetch.
  @photo_1 ~s(data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="%233f51b5"/></svg>)
  @photo_2 ~s(data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="%23ff4081"/></svg>)
  @photo_3 ~s(data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="%23009688"/></svg>)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Data Display")
     |> assign(chips: ["React", "Elixir", "Phoenix", "LiveView"])
     |> assign(photo_1: @photo_1, photo_2: @photo_2, photo_3: @photo_3)
     |> assign(tp_page: 1, tp_rows: 5, sort: "asc")}
  end

  @tp_users for n <- 1..47, do: %{id: n, name: "User #{n}", email: "user#{n}@example.com"}

  # Table Pagination demo: the events carry phx-value-page / phx-value-rows_per_page.
  def handle_event("tp_page", %{"page" => page}, socket) do
    {:noreply, assign(socket, :tp_page, String.to_integer(page))}
  end

  def handle_event("tp_rows", %{"rows_per_page" => rows}, socket) do
    {:noreply, assign(socket, tp_rows: String.to_integer(rows), tp_page: 1)}
  end

  # The Table demo's sortable header flips the order of its rows.
  def handle_event("sort", _params, socket) do
    {:noreply, update(socket, :sort, &if(&1 == "asc", do: "desc", else: "asc"))}
  end

  def handle_event("delete_chip", %{"chip" => chip}, socket) do
    {:noreply, update(socket, :chips, &List.delete(&1, chip))}
  end

  def handle_event("select_filter", _params, socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:data_display}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Data Display">
          PhoenixPaper.Card, Avatar, Badge, Chip, Tooltip, Icon, Carousel, the Table family and
          TablePagination. The options tables on these pages are pp_tables too.
        </.page_header>

        <.section
          title="Card"
          api={[{PhoenixPaper.Card, :pp_card}]}
          description="MD3's three card styles: elevated (surface-container-low with a level-1 shadow), filled (surface-container-highest) and outlined (outline-variant border). Slots for :media (edge to edge on top), :title, :subhead and :actions. Give it href, navigate or patch and the whole card becomes clickable, with a state layer and focus ring; :actions stay outside the link."
          code={card_code()}
        >
          <.demo_group label="variant" class="items-stretch">
            <.pp_card :for={variant <- ~w(elevated filled outlined)} variant={variant} class="w-56">
              <:title>{variant}</:title>
              <:subhead>Card variant</:subhead>
              Body text on the card's own surface.
            </.pp_card>
          </.demo_group>

          <.demo_group label=":media, and link mode (navigate)" class="items-start">
            <.pp_card class="w-72">
              <:media><img src={@photo_1} alt="" class="h-36 w-full object-cover" /></:media>
              <:title>Breakfast</:title>
              <:subhead>Open until 11am</:subhead>
              Pancakes, eggs and fresh coffee.
              <:actions>
                <.pp_button variant="text">Directions</.pp_button>
                <.pp_button variant="tonal">Book</.pp_button>
              </:actions>
            </.pp_card>
            <.pp_card
              id="card-link-demo"
              variant="outlined"
              navigate="/components/surfaces"
              class="w-72"
            >
              <:title>Surfaces</:title>
              Typography, Divider and the sheets. Click anywhere except the button.
              <:actions>
                <.pp_button variant="text" href="/components/feedback">Feedback</.pp_button>
              </:actions>
            </.pp_card>
          </.demo_group>
        </.section>

        <.section
          title="Avatar"
          api={[{PhoenixPaper.Avatar, :pp_avatar}]}
          description="MD3's list leading element: a 40dp primary-container circle holding title-medium initials, an icon, or an image (src). If the image fails to load, the initials show instead. One MD3 size, shape and color; it's most at home in a list item's :leading slot."
          code={avatar_code()}
        >
          <.demo_group label="Initials, icon, image">
            <.pp_avatar>AL</.pp_avatar>
            <.pp_avatar><.pp_icon name="hero-user" /></.pp_avatar>
            <.pp_avatar src={@photo_2} alt="Grace Hopper">GH</.pp_avatar>
            <.pp_avatar src="/images/missing.jpg" alt="Alan Turing">AT</.pp_avatar>
          </.demo_group>
        </.section>

        <.section
          title="Badge"
          api={[{PhoenixPaper.Badge, :pp_badge}]}
          description="MD3's two badges, anchored to the corner of their child, always in the error color. Without content it's the small 6dp dot; with content it's the large badge holding a count or short label. Counts above max (999 by default) show as 999+, and a count of 0 hides the badge. invisible hides it without removing it."
          code={badge_code()}
        >
          <.demo_group label="Small (no content) and large (content)">
            <.pp_badge><.pp_icon name="hero-chat-bubble-left" /></.pp_badge>
            <.pp_badge content={4}><.pp_icon name="hero-envelope" /></.pp_badge>
            <.pp_badge content="New"><.pp_icon name="hero-sparkles" /></.pp_badge>
          </.demo_group>
          <.demo_group label="max and zero">
            <.pp_badge content={1500}><.pp_icon name="hero-bell" /></.pp_badge>
            <.pp_badge content={150} max={99}><.pp_icon name="hero-inbox" /></.pp_badge>
            <.pp_badge content={0}><.pp_icon name="hero-shopping-cart" /></.pp_badge>
          </.demo_group>
        </.section>

        <.section
          title="Chip"
          api={[{PhoenixPaper.Chip, :pp_chip}]}
          description="MD3's four chips: assist (a smart action with a leading icon), filter (toggles; a check appears when selected), input (a user-entered value, removable) and suggestion (a generated reply or query). 32dp, 8dp corners, outlined; elevated swaps the outline for a filled shadowed chip. Filter chips toggle like buttons: selected + phx-click, or toggle on the client."
          code={chip_code()}
        >
          <.demo_group label="assist and suggestion">
            <.pp_chip variant="assist">
              <:icon><.pp_icon name="hero-calendar" size="sm" /></:icon>
              Add to calendar
            </.pp_chip>
            <.pp_chip variant="assist" elevated>
              <:icon><.pp_icon name="hero-map-pin" size="sm" /></:icon>
              Directions
            </.pp_chip>
            <.pp_chip variant="suggestion">Sounds good</.pp_chip>
            <.pp_chip variant="suggestion">See you then</.pp_chip>
          </.demo_group>
          <.demo_group label="filter (click to toggle)">
            <.pp_chip
              :for={{label, on} <- [{"Unread", true}, {"Starred", false}, {"Attachments", false}]}
              variant="filter"
              toggle
              selected={on}
            >
              {label}
            </.pp_chip>
          </.demo_group>
          <.demo_group label="input (✕ removes)">
            <.pp_chip
              :for={chip <- @chips}
              id={"chip-#{chip}"}
              variant="input"
              deletable
              on_delete={JS.push("delete_chip", value: %{chip: chip})}
            >
              {chip}
            </.pp_chip>
          </.demo_group>
        </.section>

        <.section
          title="Tooltip"
          api={[{PhoenixPaper.Tooltip, :pp_tooltip}]}
          description="A label shown on hover/focus. plain is MD3's small inverse-surface tooltip for a short title; rich is a surface-container card with a subhead, supporting text and optional :actions, for more context. Pure CSS (group-hover/group-focus-within), no collision detection."
          code={tooltip_code()}
        >
          <.demo_group label="plain (hover each)">
            <.pp_tooltip title="Delete">
              <.pp_icon_button icon="hero-trash" label="Delete" title={false} />
            </.pp_tooltip>
            <.pp_tooltip
              :for={placement <- ~w(bottom left right)}
              title={placement}
              placement={placement}
            >
              <.pp_button variant="outlined">{placement}</.pp_button>
            </.pp_tooltip>
          </.demo_group>
          <.demo_group label="rich">
            <.pp_tooltip
              variant="rich"
              subhead="Rich tooltip"
              title="Supporting text that explains a little more about the control it's attached to."
            >
              <.pp_button variant="tonal">Hover me</.pp_button>
              <:actions><.pp_button variant="text" size="xs">Learn more</.pp_button></:actions>
            </.pp_tooltip>
          </.demo_group>
        </.section>

        <.section
          title="Icon"
          api={[{PhoenixPaper.Icon, :pp_icon}]}
          description={
            ~S|Renders the app's own heroicon classes: no bundled icon set, no extra dependency. Size it with size (MD3's 24dp is md, the default), not class: a plain class="size-4" would lose to the built-in size.|
          }
          code={icon_code()}
        >
          <.demo_group label="Colors via text color">
            <.pp_icon name="hero-check" class="text-pp-tertiary" />
            <.pp_icon name="hero-star" class="text-pp-secondary" />
            <.pp_icon name="hero-home" class="text-pp-primary" />
            <.pp_icon name="hero-bell" class="text-pp-error" />
          </.demo_group>
          <.demo_group label="size">
            <.pp_icon :for={size <- ~w(xs sm md lg xl)} name="hero-star" size={size} />
          </.demo_group>
        </.section>

        <.section
          title="Carousel"
          api={[{PhoenixPaper.Carousel, :pp_carousel}]}
          description="An M3 Expressive carousel: a horizontally scrolling row of visual items with snap points. multi_browse items narrow as they reach the edges and open up as they scroll in (a CSS scroll-timeline mask); hero shows one large item plus a peek; uncontained is plain fixed-size items; full_screen is one item per screen. controls adds previous/next buttons for mice."
          code={carousel_code()}
        >
          <.demo_group label="multi_browse, with controls" direction="column">
            <.pp_carousel id="carousel-demo" label="Photos" controls>
              <:item :for={{photo, label} <- carousel_items(assigns)} label={label}>
                <img src={photo} alt="" class="size-full object-cover" />
              </:item>
            </.pp_carousel>
          </.demo_group>
          <.demo_group label="hero" direction="column">
            <.pp_carousel id="carousel-hero" layout="hero" height="sm" label="Featured">
              <:item :for={{photo, label} <- carousel_items(assigns)} label={label}>
                <img src={photo} alt="" class="size-full object-cover" />
              </:item>
            </.pp_carousel>
          </.demo_group>
        </.section>

        <.section
          title="Table"
          api={[
            {PhoenixPaper.TableContainer, :pp_table_container},
            {PhoenixPaper.Table, :pp_table},
            {PhoenixPaper.TableHead, :pp_table_head},
            {PhoenixPaper.TableBody, :pp_table_body},
            {PhoenixPaper.TableRow, :pp_table_row},
            {PhoenixPaper.TableCell, :pp_table_cell},
            {PhoenixPaper.TableFooter, :pp_table_footer}
          ]}
          description="A data table from MD3 parts: title-small headers over body-medium rows, outline-variant dividers, the state layer on row hover, and secondary-container for selected rows. A sortable header cell renders an icon arrow with aria-sort. TableContainer is the card surface around it (variant as for Card, outlined by default); sticky_header pins the header while the container scrolls."
          code={table_code()}
        >
          <.demo_group label="Sortable header, a selected row, a footer" direction="column">
            <.pp_table_container id="table-demo">
              <.pp_table>
                <.pp_table_head>
                  <.pp_table_row>
                    <.pp_table_cell
                      variant="head"
                      sortable
                      sort_direction={@sort}
                      phx-click="sort"
                    >
                      Dessert
                    </.pp_table_cell>
                    <.pp_table_cell variant="head" align="right">Calories</.pp_table_cell>
                    <.pp_table_cell variant="head" align="right">Protein (g)</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_head>
                <.pp_table_body>
                  <.pp_table_row
                    :for={{name, kcal, protein} <- sorted_desserts(@sort)}
                    selected={name == "Eclair"}
                  >
                    <.pp_table_cell>{name}</.pp_table_cell>
                    <.pp_table_cell align="right">{kcal}</.pp_table_cell>
                    <.pp_table_cell align="right">{protein}</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_body>
                <.pp_table_footer>
                  <.pp_table_row>
                    <.pp_table_cell>Total</.pp_table_cell>
                    <.pp_table_cell align="right">{total_kcal()}</.pp_table_cell>
                    <.pp_table_cell align="right"></.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_footer>
              </.pp_table>
            </.pp_table_container>
          </.demo_group>
        </.section>

        <.section
          title="Table Pagination"
          api={[{PhoenixPaper.TablePagination, :pp_table_pagination}]}
          description="A table footer bar from MD3 parts: a rows-per-page picker (a pp_menu), the range (1–5 of 47) and previous/next icon buttons. count is the total number of rows and page is 1-based. Give path a (page, rows_per_page) function for links, or on_page_change and on_rows_per_page_change event names; picking a new page size goes back to page 1."
          code={table_pagination_code()}
        >
          <.demo_group label="47 rows, events" direction="column">
            <.pp_table_container id="tp-demo">
              <.pp_table id="tp-table">
                <.pp_table_head>
                  <.pp_table_row>
                    <.pp_table_cell variant="head">Name</.pp_table_cell>
                    <.pp_table_cell variant="head">Email</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_head>
                <.pp_table_body>
                  <.pp_table_row :for={user <- tp_rows(@tp_page, @tp_rows)}>
                    <.pp_table_cell>{user.name}</.pp_table_cell>
                    <.pp_table_cell>{user.email}</.pp_table_cell>
                  </.pp_table_row>
                </.pp_table_body>
              </.pp_table>
              <.pp_table_pagination
                id="tp-pagination"
                page={@tp_page}
                count={47}
                rows_per_page={@tp_rows}
                rows_per_page_options={[5, 10, 25]}
                on_page_change="tp_page"
                on_rows_per_page_change="tp_rows"
              />
            </.pp_table_container>
          </.demo_group>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp avatar_code do
    """
    <.pp_avatar>AL</.pp_avatar>
    <.pp_avatar><.pp_icon name="hero-user" /></.pp_avatar>

    <%!-- An image, falling back to the initials if it fails to load --%>
    <.pp_avatar src={@user.avatar_url} alt={@user.name}>GH</.pp_avatar>\
    """
  end

  defp table_code do
    """
    <.pp_table_container>
      <.pp_table>
        <.pp_table_head>
          <.pp_table_row>
            <.pp_table_cell variant="head" sortable sort_direction={@sort} phx-click="sort">
              Dessert
            </.pp_table_cell>
            <.pp_table_cell variant="head" align="right">Calories</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_head>
        <.pp_table_body>
          <.pp_table_row :for={d <- @desserts} selected={d.id == @selected_id}>
            <.pp_table_cell>{d.name}</.pp_table_cell>
            <.pp_table_cell align="right">{d.calories}</.pp_table_cell>
          </.pp_table_row>
        </.pp_table_body>
      </.pp_table>
    </.pp_table_container>\
    """
  end

  defp table_pagination_code do
    String.trim_trailing(~S'''
    <.pp_table_container>
      <.pp_table>...</.pp_table>

      <%!-- Links: (page, rows_per_page) -> URL --%>
      <.pp_table_pagination
        id="users-pagination"
        page={@page}
        count={@total_rows}
        rows_per_page={@per_page}
        path={&~p"/users?page=#{&1}&per_page=#{&2}"}
      />
    </.pp_table_container>

    <%!-- Or events: phx-value-page / phx-value-rows_per_page --%>
    <.pp_table_pagination
      id="users-pagination"
      page={@page}
      count={@total_rows}
      rows_per_page={@per_page}
      on_page_change="page"
      on_rows_per_page_change="per_page"
    />
    ''')
  end

  @desserts [
    {"Frozen yoghurt", 159, 4.0},
    {"Ice cream sandwich", 237, 4.3},
    {"Eclair", 262, 6.0},
    {"Cupcake", 305, 4.3},
    {"Gingerbread", 356, 3.9}
  ]

  defp sorted_desserts("asc"), do: Enum.sort_by(@desserts, &elem(&1, 0))
  defp sorted_desserts("desc"), do: Enum.sort_by(@desserts, &elem(&1, 0), :desc)

  defp total_kcal, do: @desserts |> Enum.map(&elem(&1, 1)) |> Enum.sum()

  defp tp_rows(page, per_page), do: Enum.slice(@tp_users, (page - 1) * per_page, per_page)

  defp card_code do
    """
    <.pp_card :for={variant <- ~w(elevated filled outlined)} variant={variant}>
      <:title>{variant}</:title>
      <:subhead>Card variant</:subhead>
      Body text on the card's own surface.
    </.pp_card>

    <.pp_card>
      <:media><img src="/images/1.jpg" alt="" class="h-36 w-full object-cover" /></:media>
      <:title>Breakfast</:title>
      <:subhead>Open until 11am</:subhead>
      Pancakes, eggs and fresh coffee.
      <:actions>
        <.pp_button variant="text">Directions</.pp_button>
        <.pp_button variant="tonal">Book</.pp_button>
      </:actions>
    </.pp_card>

    <%!-- The whole card is clickable; :actions stay outside the link --%>
    <.pp_card variant="outlined" navigate={~p"/components/surfaces"}>
      <:title>Surfaces</:title>
      Typography, Divider and the sheets.
    </.pp_card>\
    """
  end

  defp badge_code do
    """
    <%!-- small badge: no content --%>
    <.pp_badge><.pp_icon name="hero-chat-bubble-left" /></.pp_badge>

    <%!-- large badge: a count or short label --%>
    <.pp_badge content={4}><.pp_icon name="hero-envelope" /></.pp_badge>
    <.pp_badge content={150} max={99}><.pp_icon name="hero-inbox" /></.pp_badge>

    <%!-- a count of 0 hides it --%>
    <.pp_badge content={@unread}><.pp_icon name="hero-bell" /></.pp_badge>\
    """
  end

  defp chip_code do
    """
    <.pp_chip variant="assist" phx-click="add_to_calendar">
      <:icon><.pp_icon name="hero-calendar" size="sm" /></:icon>
      Add to calendar
    </.pp_chip>

    <%!-- filter: a client-side toggle (or selected={@unread} + phx-click) --%>
    <.pp_chip variant="filter" toggle selected={false}>Unread</.pp_chip>

    <%!-- input: removable --%>
    <.pp_chip variant="input" deletable on_delete={JS.push("remove_tag", value: %{tag: "elixir"})}>
      elixir
    </.pp_chip>

    <.pp_chip variant="suggestion" phx-click="reply" phx-value-text="Sounds good">Sounds good</.pp_chip>\
    """
  end

  defp tooltip_code do
    """
    <.pp_tooltip title="Delete">
      <.pp_icon_button icon="hero-trash" label="Delete" title={false} />
    </.pp_tooltip>

    <.pp_tooltip title="Bottom" placement="bottom">
      <.pp_button variant="outlined">Bottom</.pp_button>
    </.pp_tooltip>

    <.pp_tooltip variant="rich" subhead="Rich tooltip" title="Supporting text with more context.">
      <.pp_button variant="tonal">Hover me</.pp_button>
      <:actions><.pp_button variant="text" size="xs">Learn more</.pp_button></:actions>
    </.pp_tooltip>\
    """
  end

  defp icon_code do
    """
    <.pp_icon name="hero-check" class="text-pp-tertiary" />

    <%!-- size, not class="size-4" (which loses to the built-in size) --%>
    <.pp_icon :for={size <- ~w(xs sm md lg xl)} name="hero-star" size={size} />\
    """
  end

  defp carousel_items(assigns) do
    [
      {assigns.photo_1, "Breakfast"},
      {assigns.photo_2, "Burger"},
      {assigns.photo_3, "Camera"},
      {assigns.photo_1, "Morning"},
      {assigns.photo_2, "Lunch"},
      {assigns.photo_3, "Gear"}
    ]
  end

  defp carousel_code do
    """
    <.pp_carousel id="featured" label="Featured places" controls>
      <:item :for={place <- @places} label={place.name} navigate={~p"/places/\#{place.id}"}>
        <img src={place.photo} alt="" class="size-full object-cover" />
      </:item>
    </.pp_carousel>

    <.pp_carousel id="hero" layout="hero" height="sm" label="Featured">
      <:item :for={place <- @places} label={place.name}>
        <img src={place.photo} alt="" class="size-full object-cover" />
      </:item>
    </.pp_carousel>\
    """
  end
end
