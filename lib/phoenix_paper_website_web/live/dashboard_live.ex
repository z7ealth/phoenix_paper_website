defmodule PhoenixPaperWebsiteWeb.DashboardLive do
  @moduledoc """
  A demo admin dashboard: a showcase of PhoenixPaper components working
  together as one app screen (KPI cards, a filterable, sortable, paginated
  orders table, a create dialog behind a FAB, tabs, lists, progress), built
  only from PhoenixPaper components and Tailwind layout classes. The data is
  made up and lives in the LiveView's assigns.
  """
  use PhoenixPaperWebsiteWeb, :live_view

  alias PhoenixPaper.Dialog

  # This file's own source, for the page's "Show code" toggle: read at
  # compile time, so what's shown is always exactly what runs.
  @external_resource __ENV__.file
  @source File.read!(__ENV__.file)

  @statuses ~w(paid pending refunded)
  @periods ~w(day week month)
  @per_page_options [5, 10]

  @customers [
    "Ada Lovelace",
    "Grace Hopper",
    "Alan Turing",
    "Katherine Johnson",
    "Linus Torvalds",
    "Margaret Hamilton",
    "Dennis Ritchie",
    "Barbara Liskov",
    "José Valim",
    "Joe Armstrong",
    "Radia Perlman",
    "Ken Thompson"
  ]
  @products ["Paper notebook", "Fountain pen", "Desk lamp", "Ink set", "Sketchbook", "Planner"]

  # Deterministic made-up orders, newest first.
  @orders (for n <- 24..1//-1 do
             %{
               id: 1000 + n,
               customer: Enum.at(@customers, rem(n * 7, length(@customers))),
               product: Enum.at(@products, rem(n * 5, length(@products))),
               amount: 18 + rem(n * 37, 220),
               # mostly paid, every third pending, every eighth refunded
               status:
                 cond do
                   rem(n, 8) == 1 -> "refunded"
                   rem(n, 3) == 0 -> "pending"
                   true -> "paid"
                 end,
               day: rem(n * 3, 28) + 1
             }
           end)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Dashboard", period: "week", status_filter: [], sort: "desc")
     |> assign(:width, "contained")
     |> assign(:source, @source)
     |> assign(page: 1, per_page: 5, orders: @orders, next_id: 1025)
     |> assign(:order_form, new_order_form())}
  end

  # The layout is a URL param (?layout=full), so it's linkable and survives
  # a reload.
  def handle_params(params, _uri, socket) do
    layout = if params["layout"] == "full", do: "full", else: "contained"
    {:noreply, assign(socket, :width, layout)}
  end

  def handle_event("set_layout", %{"layout" => layout}, socket)
      when layout in ~w(contained full) do
    params = if layout == "full", do: [layout: "full"], else: []
    {:noreply, push_patch(socket, to: ~p"/dashboard?#{params}")}
  end

  # Period: the segmented control above the KPI cards.
  def handle_event("set_period", %{"period" => period}, socket) when period in @periods do
    {:noreply, assign(socket, :period, period)}
  end

  # Status filter chips: toggling one resets to the first page.
  def handle_event("toggle_status", %{"status" => status}, socket) when status in @statuses do
    filter = socket.assigns.status_filter

    filter =
      if status in filter, do: List.delete(filter, status), else: [status | filter]

    {:noreply, assign(socket, status_filter: filter, page: 1)}
  end

  def handle_event("clear_status", _params, socket),
    do: {:noreply, assign(socket, status_filter: [], page: 1)}

  # The Amount header sorts.
  def handle_event("sort", _params, socket) do
    {:noreply, update(socket, :sort, &if(&1 == "desc", do: "asc", else: "desc"))}
  end

  # Table Pagination's events.
  def handle_event("page", %{"page" => page}, socket),
    do: {:noreply, assign(socket, :page, String.to_integer(page))}

  def handle_event("per_page", %{"rows_per_page" => rows}, socket) do
    rows = String.to_integer(rows)
    rows = if rows in @per_page_options, do: rows, else: 5
    {:noreply, assign(socket, per_page: rows, page: 1)}
  end

  # The New order dialog: the browser checks `required`, the form closes the
  # dialog on submit, and the new order lands on top of the table.
  def handle_event("create_order", %{"order" => params}, socket) do
    amount =
      case Integer.parse(params["amount"] || "") do
        {n, _} when n > 0 -> n
        _ -> 1
      end

    order = %{
      id: socket.assigns.next_id,
      customer:
        String.trim(params["customer"] || "") |> then(&if(&1 == "", do: "Guest", else: &1)),
      product: if(params["product"] in @products, do: params["product"], else: hd(@products)),
      amount: amount,
      status: "pending",
      day: 28
    }

    {:noreply,
     socket
     |> update(:orders, &[order | &1])
     |> assign(next_id: order.id + 1, page: 1, status_filter: [], sort: "desc")
     |> assign(:order_form, new_order_form())
     |> put_flash(:info, "Order ##{order.id} created for #{order.customer}.")}
  end

  def handle_event("export", _params, socket),
    do:
      {:noreply, put_flash(socket, :info, "Export started. (Demo only: nothing is downloaded.)")}

  defp new_order_form,
    do: to_form(%{"customer" => "", "product" => hd(@products), "amount" => "40"}, as: :order)

  def render(assigns) do
    assigns =
      assigns
      |> assign(:visible, visible_orders(assigns))
      |> assign(:kpis, kpis(assigns.period, assigns.orders))

    assigns =
      assigns
      |> assign(:rows, page_rows(assigns.visible, assigns.page, assigns.per_page))

    ~H"""
    <Layouts.app flash={@flash} current_page={:dashboard}>
      <%!-- pb-24: room to scroll clear of the fixed FAB. Full width keeps
            MD3's 16/24dp margins, the same as the supporting pane's. --%>
      <div class={[
        "w-full pb-24",
        if(@width == "full",
          do: "px-4 min-[600px]:px-6",
          else: "mx-auto max-w-screen-xl px-4"
        )
      ]}>
        <.page_header eyebrow="Showcase" title="Dashboard" />

        <div id="dashboard-source" class="-mt-8 mb-8">
          <.demo_code id="dashboard" text={@source} />
        </div>

        <div class="mb-6 flex flex-wrap items-center justify-between gap-4">
          <.pp_button_group variant="connected">
            <.pp_button
              :for={period <- ~w(day week month)}
              id={"period-#{period}"}
              variant="outlined"
              size="xs"
              selected={@period == period}
              phx-click="set_period"
              phx-value-period={period}
            >
              {String.capitalize(period)}
            </.pp_button>
          </.pp_button_group>
          <div class="flex items-center gap-2">
            <.pp_button_group id="layout-switch" variant="connected">
              <.pp_button
                :for={
                  {value, icon, label} <- [
                    {"contained", "hero-arrows-pointing-in", "Contained"},
                    {"full", "hero-arrows-pointing-out", "Full width"}
                  ]
                }
                id={"layout-#{value}"}
                variant="outlined"
                size="xs"
                selected={@width == value}
                phx-click="set_layout"
                phx-value-layout={value}
              >
                <:start_icon><.pp_icon name={icon} size="sm" /></:start_icon>
                {label}
              </.pp_button>
            </.pp_button_group>
            <.pp_tooltip title="3 new reviews">
              <.pp_badge content={3}>
                <.pp_icon_button icon="hero-bell" label="Notifications" />
              </.pp_badge>
            </.pp_tooltip>
            <.pp_button id="export" variant="tonal" phx-click="export">
              <:start_icon><.pp_icon name="hero-arrow-down-tray" size="sm" /></:start_icon>
              Export
            </.pp_button>
          </div>
        </div>

        <div id="kpis" class="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <.pp_card :for={kpi <- @kpis} id={"kpi-#{kpi.id}"} variant="filled">
            <div class="flex items-start justify-between gap-3">
              <div>
                <.pp_typography variant="label-large" color="on-surface-variant">
                  {kpi.label}
                </.pp_typography>
                <.pp_typography variant="headline-medium" tag="p" class="mt-1">
                  {kpi.value}
                </.pp_typography>
              </div>
              <.pp_avatar><.pp_icon name={kpi.icon} /></.pp_avatar>
            </div>
            <div class="mt-3 flex items-center gap-1">
              <.pp_icon
                name={
                  if(kpi.delta >= 0, do: "hero-arrow-trending-up", else: "hero-arrow-trending-down")
                }
                size="sm"
                class={if(kpi.delta >= 0, do: "text-pp-primary", else: "text-pp-error")}
              />
              <.pp_typography
                variant="label-medium"
                color={if(kpi.delta >= 0, do: "primary", else: "error")}
              >
                {format_delta(kpi.delta)}
              </.pp_typography>
              <.pp_typography variant="label-medium" color="on-surface-variant">
                vs last {@period}
              </.pp_typography>
            </div>
          </.pp_card>
        </div>

        <%= if @width == "full" do %>
          <%!-- Full width: MD3's supporting pane layout. The orders take the
                flexible pane, the side column a fixed 360dp pane beside it
                (below it under 840dp). --%>
          <.pp_supporting_pane id="dashboard-panes" class="-mx-4 min-[600px]:-mx-6">
            <.orders_panel
              rows={@rows}
              visible={@visible}
              page={@page}
              per_page={@per_page}
              sort={@sort}
              status_filter={@status_filter}
            />
            <:supporting><.side_panel /></:supporting>
          </.pp_supporting_pane>
        <% else %>
          <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
            <div class="min-w-0 lg:col-span-2">
              <.orders_panel
                rows={@rows}
                visible={@visible}
                page={@page}
                per_page={@per_page}
                sort={@sort}
                status_filter={@status_filter}
              />
            </div>
            <div class="min-w-0"><.side_panel /></div>
          </div>
        <% end %>
      </div>

      <.pp_fab
        id="new-order"
        position="fixed"
        class="bottom-6 right-6"
        extended
        icon="hero-plus"
        label="New order"
        phx-click={Dialog.show("new-order-dialog")}
      />

      <.pp_dialog id="new-order-dialog" icon="hero-shopping-bag">
        <:title>New order</:title>
        <.form
          for={@order_form}
          id="new-order-form"
          phx-submit={JS.push("create_order") |> Dialog.hide("new-order-dialog")}
          class="mt-2 flex flex-col gap-4"
        >
          <.pp_text_field field={@order_form[:customer]} label="Customer" required />
          <.pp_select
            field={@order_form[:product]}
            label="Product"
            options={products()}
          />
          <.pp_number_field field={@order_form[:amount]} label="Amount ($)" min={1} required />
          <div class="flex justify-end gap-2">
            <.pp_button
              type="button"
              variant="text"
              phx-click={Dialog.hide("new-order-dialog")}
            >
              Cancel
            </.pp_button>
            <.pp_button id="create-order" type="submit">Create</.pp_button>
          </div>
        </.form>
      </.pp_dialog>
    </Layouts.app>
    """
  end

  attr :rows, :list, required: true
  attr :visible, :list, required: true
  attr :page, :integer, required: true
  attr :per_page, :integer, required: true
  attr :sort, :string, required: true
  attr :status_filter, :list, required: true

  # The orders table with its filters and pagination (both layouts).
  defp orders_panel(assigns) do
    ~H"""
    <div class="flex min-w-0 flex-col gap-4 lg:col-span-2">
      <div class="flex flex-wrap items-center justify-between gap-3">
        <.pp_typography variant="title-large" tag="h2">Orders</.pp_typography>
        <div id="status-filters" class="flex flex-wrap items-center gap-2">
          <.pp_chip
            :for={status <- ~w(paid pending refunded)}
            id={"filter-#{status}"}
            variant="filter"
            selected={status in @status_filter}
            phx-click="toggle_status"
            phx-value-status={status}
          >
            {String.capitalize(status)}
          </.pp_chip>
          <.pp_button
            :if={@status_filter != []}
            id="clear-filters"
            variant="text"
            size="xs"
            phx-click="clear_status"
          >
            Clear
          </.pp_button>
        </div>
      </div>

      <.pp_table_container id="orders">
        <.pp_table>
          <.pp_table_head>
            <.pp_table_row>
              <.pp_table_cell variant="head">Order</.pp_table_cell>
              <.pp_table_cell variant="head">Customer</.pp_table_cell>
              <.pp_table_cell variant="head" class="hidden sm:table-cell">
                Product
              </.pp_table_cell>
              <.pp_table_cell variant="head">Status</.pp_table_cell>
              <.pp_table_cell
                variant="head"
                align="right"
                sortable
                sort_direction={@sort}
                phx-click="sort"
              >
                Amount
              </.pp_table_cell>
            </.pp_table_row>
          </.pp_table_head>
          <.pp_table_body>
            <.pp_table_row :for={order <- @rows} id={"order-#{order.id}"}>
              <.pp_table_cell>
                <.pp_typography variant="label-large">#{order.id}</.pp_typography>
                <.pp_typography variant="body-small" color="on-surface-variant">
                  Oct {order.day}
                </.pp_typography>
              </.pp_table_cell>
              <.pp_table_cell>
                <div class="flex items-center gap-3">
                  <.pp_avatar class="hidden md:inline-flex">
                    {initials(order.customer)}
                  </.pp_avatar>
                  {order.customer}
                </div>
              </.pp_table_cell>
              <.pp_table_cell class="hidden sm:table-cell">{order.product}</.pp_table_cell>
              <.pp_table_cell>
                <span class="inline-flex items-center gap-1">
                  <.pp_icon
                    name={status_icon(order.status)}
                    size="sm"
                    class={status_class(order.status)}
                  />
                  <.pp_typography variant="label-large" color={status_color(order.status)}>
                    {String.capitalize(order.status)}
                  </.pp_typography>
                </span>
              </.pp_table_cell>
              <.pp_table_cell align="right">${order.amount}.00</.pp_table_cell>
            </.pp_table_row>
            <.pp_table_row :if={@rows == []}>
              <.pp_table_cell colspan="5">
                <.pp_typography
                  variant="body-medium"
                  color="on-surface-variant"
                  class="py-6 text-center"
                >
                  No orders match these filters.
                </.pp_typography>
              </.pp_table_cell>
            </.pp_table_row>
          </.pp_table_body>
        </.pp_table>
        <.pp_table_pagination
          id="orders-pagination"
          page={@page}
          count={length(@visible)}
          rows_per_page={@per_page}
          rows_per_page_options={[5, 10]}
          on_page_change="page"
          on_rows_per_page_change="per_page"
        />
      </.pp_table_container>
    </div>
    """
  end

  # Goals, activity/team tabs and the sync card (both layouts).
  defp side_panel(assigns) do
    ~H"""
    <div class="flex min-w-0 flex-col gap-6">
      <.pp_card id="goals" variant="outlined">
        <:title>Monthly goals</:title>
        <div class="mt-3 flex flex-col gap-4">
          <div :for={goal <- goals()} id={"goal-#{goal.id}"}>
            <div class="mb-1.5 flex items-baseline justify-between gap-2">
              <.pp_typography variant="label-large">{goal.label}</.pp_typography>
              <.pp_typography variant="label-medium" color="on-surface-variant">
                {goal.detail}
              </.pp_typography>
            </div>
            <.pp_progress
              value={goal.value}
              label={goal.label}
              color={goal.color}
              wavy={goal.wavy}
            />
          </div>
        </div>
      </.pp_card>

      <.pp_card id="activity" variant="outlined">
        <.pp_tabs id="activity-tabs">
          <.pp_tab id="activity-tabs" value="activity" default_selected>Activity</.pp_tab>
          <.pp_tab id="activity-tabs" value="team" badge={2}>Team</.pp_tab>
        </.pp_tabs>
        <.pp_tab_panel id="activity-tabs" value="activity" default_selected>
          <.pp_list>
            <.pp_list_item :for={{icon, line, time} <- activity()}>
              <:leading><.pp_icon name={icon} /></:leading>
              {line}
              <:secondary>{time}</:secondary>
            </.pp_list_item>
          </.pp_list>
        </.pp_tab_panel>
        <.pp_tab_panel id="activity-tabs" value="team">
          <.pp_list>
            <.pp_list_item :for={{name, role, online} <- team()}>
              <:leading>
                <%!-- A small badge (no content) marks who's online --%>
                <.pp_badge invisible={!online}>
                  <.pp_avatar>{initials(name)}</.pp_avatar>
                </.pp_badge>
              </:leading>
              {name}
              <:secondary>{if online, do: "#{role} · online", else: role}</:secondary>
            </.pp_list_item>
          </.pp_list>
        </.pp_tab_panel>
      </.pp_card>

      <.pp_card id="sync" variant="filled">
        <div class="flex items-center gap-4">
          <.pp_loading_indicator contained size={48} label="Syncing inventory" />
          <div>
            <.pp_typography variant="title-medium">Syncing inventory</.pp_typography>
            <.pp_typography variant="body-medium" color="on-surface-variant">
              142 of 180 products updated
            </.pp_typography>
          </div>
        </div>
      </.pp_card>
    </div>
    """
  end

  # --- data helpers ----------------------------------------------------------

  defp visible_orders(%{orders: orders, status_filter: filter, sort: sort}) do
    orders
    |> Enum.filter(&(filter == [] or &1.status in filter))
    |> Enum.sort_by(& &1.amount, if(sort == "asc", do: :asc, else: :desc))
  end

  defp page_rows(orders, page, per_page), do: Enum.slice(orders, (page - 1) * per_page, per_page)

  # Made-up KPIs that move with the period (and count real orders).
  defp kpis(period, orders) do
    scale = %{"day" => 1, "week" => 7, "month" => 30}[period]
    paid = Enum.filter(orders, &(&1.status == "paid"))
    revenue = Enum.sum(Enum.map(paid, & &1.amount)) * scale

    [
      %{
        id: "revenue",
        label: "Revenue",
        icon: "hero-banknotes",
        value: money(revenue),
        delta: 12.4
      },
      %{
        id: "orders",
        label: "Orders",
        icon: "hero-shopping-cart",
        value: Integer.to_string(length(orders) * scale),
        delta: 8.1
      },
      %{
        id: "customers",
        label: "New customers",
        icon: "hero-user-plus",
        value: Integer.to_string(3 * scale + 2),
        delta: -2.3
      },
      %{
        id: "refunds",
        label: "Refund rate",
        icon: "hero-arrow-uturn-left",
        value: refund_rate(orders),
        delta: -0.6
      }
    ]
  end

  defp money(n) when n >= 1000, do: "$#{Float.round(n / 1000, 1)}k"
  defp money(n), do: "$#{n}"

  defp refund_rate(orders) do
    refunded = Enum.count(orders, &(&1.status == "refunded"))
    "#{Float.round(refunded * 100 / max(length(orders), 1), 1)}%"
  end

  defp format_delta(d) when d >= 0, do: "+#{d}%"
  defp format_delta(d), do: "#{d}%"

  defp status_icon("paid"), do: "hero-check-circle"
  defp status_icon("pending"), do: "hero-clock"
  defp status_icon("refunded"), do: "hero-arrow-uturn-left"

  defp status_class("paid"), do: "text-pp-primary"
  defp status_class("pending"), do: "text-pp-tertiary"
  defp status_class("refunded"), do: "text-pp-error"

  defp status_color("paid"), do: "primary"
  defp status_color("pending"), do: "tertiary"
  defp status_color("refunded"), do: "error"

  defp initials(name), do: name |> String.split() |> Enum.map_join(&String.first/1)

  defp products, do: @products

  defp goals do
    [
      %{
        id: "revenue",
        label: "Revenue",
        detail: "$15.6k of $20k",
        value: 78,
        color: "primary",
        wavy: false
      },
      %{
        id: "customers",
        label: "New customers",
        detail: "27 of 50",
        value: 54,
        color: "tertiary",
        wavy: false
      },
      %{
        id: "shipping",
        label: "Shipped on time",
        detail: "91%",
        value: 91,
        color: "primary",
        wavy: true
      }
    ]
  end

  defp activity do
    [
      {"hero-shopping-cart", "Grace Hopper ordered a Fountain pen", "2 min ago"},
      {"hero-star", "New 5-star review on Desk lamp", "18 min ago"},
      {"hero-truck", "12 orders shipped", "1 h ago"},
      {"hero-arrow-uturn-left", "Refund issued for #1009", "3 h ago"}
    ]
  end

  defp team do
    [
      {"Margaret Hamilton", "Fulfillment", true},
      {"José Valim", "Support", true},
      {"Barbara Liskov", "Finance", false}
    ]
  end
end
