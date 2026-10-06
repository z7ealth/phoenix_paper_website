defmodule PhoenixPaperWebsiteWeb.Nav do
  @moduledoc """
  The navigation structure shared by every page (the navigation rail in
  `Layouts.app`): the Overview pages and the component categories, each
  with one entry per section on its page.
  """

  alias PhoenixPaperWebsiteWeb.DocsComponents

  @changelog_url "https://github.com/z7ealth/phoenix_paper/blob/master/CHANGELOG.md"

  # Components added or changed in the latest release, keyed by section
  # title: drives the "New"/"Updated" chips on section headers
  # (DocsComponents.section/1) and in the sidebar. Reset it each release.
  @release "0.5.2"
  @statuses %{
    # back in 0.5.2, rebuilt from MD3 parts
    "Avatar" => :new,
    "Table" => :new,
    "Table Pagination" => :new,
    "Pagination" => :new,
    "Breadcrumbs" => :new,
    "Number Field" => :new,
    "Autocomplete" => :new,
    "Password Field" => :new,
    "Upload" => :new,
    "Pane Layout" => :new,
    # gains the :chips and :menu slots
    "Text Field" => :updated
  }

  @doc "The release the New/Updated chips refer to."
  def release, do: @release

  @doc "`:new`, `:updated` or `nil` for a component section titled `title`."
  def status(title), do: Map.get(@statuses, title)

  @doc "phoenix_paper's CHANGELOG.md on GitHub, linked from the sidebar."
  def changelog_url, do: @changelog_url

  def sections do
    [
      %{
        title: "Overview",
        items: [
          %{id: :home, label: "Introduction", path: "/", icon: "hero-home"},
          %{
            id: :getting_started,
            label: "Getting Started",
            path: "/getting-started",
            icon: "hero-book-open"
          },
          %{
            id: :changelog,
            label: "Changelog",
            href: @changelog_url,
            icon: "hero-document-text"
          },
          %{id: :theming, label: "Theming", path: "/theming", icon: "hero-swatch"},
          %{
            id: :customizing,
            label: "Customizing",
            path: "/customizing",
            icon: "hero-paint-brush"
          },
          %{
            id: :theme_creator,
            label: "Theme Creator",
            path: "/theme-creator",
            icon: "hero-sparkles"
          },
          %{
            id: :dashboard,
            label: "Dashboard demo",
            path: "/dashboard",
            icon: "hero-chart-bar-square"
          }
        ]
      },
      %{title: "Components", items: component_items()}
    ]
  end

  @doc """
  The seven component category pages, also used to build the /components
  index grid. Each carries its `children`: one `#anchor` link per
  `DocsComponents.section/1` on that page, in page order, rendered as the
  sidebar's submenu -- and joined into the index grid's `blurb`, so neither
  can drift from the other. `components` must list each section's exact
  `title` (see nav_test.exs, which checks every anchor exists).
  """
  def component_items do
    Enum.map(categories(), fn category ->
      children =
        Enum.map(category.components, fn title ->
          %{
            label: title,
            path: "#{category.path}##{DocsComponents.slug(title)}",
            status: status(title)
          }
        end)

      category
      |> Map.put(:children, children)
      |> Map.put(:blurb, Enum.join(category.components, ", "))
    end)
  end

  defp categories do
    [
      %{
        id: :actions,
        label: "Actions",
        path: "/components/actions",
        icon: "hero-cursor-arrow-rays",
        components: [
          "Button",
          "Icon Button",
          "Split Button",
          "Button Group",
          "Floating Action Button",
          "FAB Menu"
        ]
      },
      %{
        id: :forms,
        label: "Forms",
        path: "/components/forms",
        icon: "hero-pencil-square",
        components: [
          "Text Field",
          "Password Field",
          "Select",
          "Number Field",
          "Checkbox",
          "Switch",
          "Theme Toggle",
          "Radio Group",
          "Slider",
          "Date Picker",
          "Time Picker",
          "Autocomplete",
          "Upload"
        ]
      },
      %{
        id: :navigation,
        label: "Navigation",
        path: "/components/navigation",
        icon: "hero-bars-3-bottom-left",
        components: [
          "Top App Bar",
          "Navigation Rail",
          "Navigation Bar",
          "Toolbar",
          "Tabs",
          "Breadcrumbs",
          "Pagination",
          "Menu",
          "Search Bar",
          "List"
        ]
      },
      %{
        id: :data_display,
        label: "Data Display",
        path: "/components/data-display",
        icon: "hero-rectangle-group",
        components: [
          "Card",
          "Avatar",
          "Badge",
          "Chip",
          "Tooltip",
          "Icon",
          "Carousel",
          "Table",
          "Table Pagination"
        ]
      },
      %{
        id: :surfaces,
        label: "Surfaces",
        path: "/components/surfaces",
        icon: "hero-square-3-stack-3d",
        components: ["Typography", "Divider", "Pane Layout", "Bottom Sheet", "Side Sheet"]
      },
      %{
        id: :feedback,
        label: "Feedback",
        path: "/components/feedback",
        icon: "hero-chat-bubble-left-right",
        components: [
          "Dialog",
          "Progress",
          "Loading Indicator",
          "Snackbar",
          "Flash"
        ]
      },
      %{
        id: :helpers,
        label: "Helpers",
        path: "/components/helpers",
        icon: "hero-wrench-screwdriver",
        components: ["Ripple", "Elevation", "Shape", "Motion"]
      }
    ]
  end
end
