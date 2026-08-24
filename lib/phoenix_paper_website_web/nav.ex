defmodule PhoenixPaperWebsiteWeb.Nav do
  @moduledoc "The sidebar/drawer navigation structure shared by every page, via `Layouts.app`."

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
      %{
        title: "Components",
        items: component_items()
      }
    ]
  end

  @doc "The five component category pages, also used to build the /components index grid."
  def component_items do
    [
      %{
        id: :buttons,
        label: "Buttons",
        path: "/components/buttons",
        icon: "hero-cursor-arrow-rays",
        blurb: "Button, ButtonGroup, ToggleButton, Fab"
      },
      %{
        id: :forms,
        label: "Forms",
        path: "/components/forms",
        icon: "hero-pencil-square",
        blurb: "Input, NumberField, Select, Slider, Autocomplete, TransferList"
      },
      %{
        id: :selection,
        label: "Selection Controls",
        path: "/components/selection",
        icon: "hero-check-circle",
        blurb: "Checkbox, Switch, RadioGroup, Rating"
      },
      %{
        id: :navigation,
        label: "Navigation",
        path: "/components/navigation",
        icon: "hero-bars-3-bottom-left",
        blurb: "Navbar, Drawer, List, ListItem, ListSubheader, Divider"
      },
      %{
        id: :surfaces,
        label: "Surfaces",
        path: "/components/surfaces",
        icon: "hero-rectangle-group",
        blurb: "Card, Elevation, Shape"
      },
      %{
        id: :layout,
        label: "Layout",
        path: "/components/layout",
        icon: "hero-squares-plus",
        blurb: "Box, Container, Stack, Grid, GridItem, ImageList, ImageListItem"
      }
    ]
  end
end
