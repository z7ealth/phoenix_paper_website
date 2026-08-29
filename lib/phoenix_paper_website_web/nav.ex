defmodule PhoenixPaperWebsiteWeb.Nav do
  @moduledoc """
  The sidebar/drawer navigation structure shared by every page, via
  `Layouts.app`. Categories mirror phoenix_paper's own `dev.exs` catalog
  nav groups exactly, for consistency with upstream.
  """

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
          }
        ]
      },
      %{title: "Components", items: component_items()}
    ]
  end

  @doc "The eight component category pages, also used to build the /components index grid."
  def component_items do
    [
      %{
        id: :actions,
        label: "Actions",
        path: "/components/actions",
        icon: "hero-cursor-arrow-rays",
        blurb: "Button, ButtonGroup, Fab, SpeedDial, ToggleButton"
      },
      %{
        id: :forms,
        label: "Forms",
        path: "/components/forms",
        icon: "hero-pencil-square",
        blurb:
          "Input, Select, NumberField, Checkbox, Switch, ThemeToggle, RadioGroup, Slider, Rating, Autocomplete, TransferList"
      },
      %{
        id: :navigation,
        label: "Navigation",
        path: "/components/navigation",
        icon: "hero-bars-3-bottom-left",
        blurb: "AppBar, Drawer, Tabs, Breadcrumbs, List"
      },
      %{
        id: :layout,
        label: "Layout",
        path: "/components/layout",
        icon: "hero-squares-plus",
        blurb: "Box, Container, Stack, Grid, GridItem, Divider"
      },
      %{
        id: :data_display,
        label: "Data Display",
        path: "/components/data-display",
        icon: "hero-rectangle-group",
        blurb: "Card, Badge, Chip, Tooltip, Icon, ImageList, Table"
      },
      %{
        id: :surfaces,
        label: "Surfaces",
        path: "/components/surfaces",
        icon: "hero-square-3-stack-3d",
        blurb: "Paper, Typography, Accordion"
      },
      %{
        id: :feedback,
        label: "Feedback",
        path: "/components/feedback",
        icon: "hero-chat-bubble-left-right",
        blurb: "Alert, Backdrop, Dialog, Progress, Skeleton, Snackbar, Flash"
      },
      %{
        id: :helpers,
        label: "Helpers",
        path: "/components/helpers",
        icon: "hero-wrench-screwdriver",
        blurb: "Ripple, Elevation, Shape, Theming"
      }
    ]
  end
end
