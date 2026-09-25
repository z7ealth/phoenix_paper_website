defmodule PhoenixPaperWebsiteWeb.Nav do
  @moduledoc """
  The sidebar/drawer navigation structure shared by every page, via
  `Layouts.app`. Categories mirror the nav groups of phoenix_paper's old
  `dev.exs` catalog (removed upstream in 0.2.3), for consistency.
  """

  alias PhoenixPaperWebsiteWeb.DocsComponents

  @changelog_url "https://github.com/z7ealth/phoenix_paper/blob/master/CHANGELOG.md"

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
          %{id: :theming, label: "Theming", path: "/theming", icon: "hero-swatch"},
          %{
            id: :changelog,
            label: "Changelog",
            href: @changelog_url,
            icon: "hero-document-text"
          }
        ]
      },
      %{title: "Components", items: component_items()}
    ]
  end

  @doc """
  The eight component category pages, also used to build the /components
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
          %{label: title, path: "#{category.path}##{DocsComponents.slug(title)}"}
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
          "Button Group",
          "Floating Action Button",
          "Speed Dial",
          "Toggle Button"
        ]
      },
      %{
        id: :forms,
        label: "Forms",
        path: "/components/forms",
        icon: "hero-pencil-square",
        components: [
          "Input",
          "Select",
          "Number Field",
          "Checkbox",
          "Switch",
          "Theme Toggle",
          "Radio Group",
          "Slider",
          "Rating",
          "Autocomplete",
          "Transfer List"
        ]
      },
      %{
        id: :navigation,
        label: "Navigation",
        path: "/components/navigation",
        icon: "hero-bars-3-bottom-left",
        components: ["App Bar", "Drawer", "Tabs", "Breadcrumbs", "Menu", "List"]
      },
      %{
        id: :layout,
        label: "Layout",
        path: "/components/layout",
        icon: "hero-squares-plus",
        components: ["Box", "Container", "Stack", "Grid & GridItem", "Divider"]
      },
      %{
        id: :data_display,
        label: "Data Display",
        path: "/components/data-display",
        icon: "hero-rectangle-group",
        components: ["Card", "Avatar", "Badge", "Chip", "Tooltip", "Icon", "Image List", "Table"]
      },
      %{
        id: :surfaces,
        label: "Surfaces",
        path: "/components/surfaces",
        icon: "hero-square-3-stack-3d",
        components: ["Paper", "Typography", "Accordion", "Collapse"]
      },
      %{
        id: :feedback,
        label: "Feedback",
        path: "/components/feedback",
        icon: "hero-chat-bubble-left-right",
        components: ["Alert", "Backdrop", "Dialog", "Progress", "Skeleton", "Snackbar", "Flash"]
      },
      %{
        id: :helpers,
        label: "Helpers",
        path: "/components/helpers",
        icon: "hero-wrench-screwdriver",
        components: ["Ripple", "Elevation", "Shape"]
      }
    ]
  end
end
