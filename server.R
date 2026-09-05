library(shiny)

# Each tab's logic lives in its module's server function (see R/).
# This file just starts each module, passing in the shared `coffee`
# dataset (loaded once in global.R). The id here must match ui.R.
#
# Cross-tab navigation:
#   * input$go_tab: the Overview journey chips set this top-level
#                               input (via a small onclick); we switch to the
#                               named tab here.
#   * nav$country / nav$nonce: the Global tab asks to open Profile with a
#                               chosen origin preselected. Profile listens for
#                               the country; we switch tabs here.

server <- function(input, output, session) {
  nav <- reactiveValues(country = NULL, nonce = 0)

  introductionServer("introduction", coffee)
  locationServer("location", coffee, nav)
  profileServer("profile", coffee, nav)
  analysisServer("analysis", coffee)
  flavorServer("flavor", coffee)
  conclusionServer("conclusion", coffee)

  # An Overview journey chip was clicked -> jump straight to its tab.
  observeEvent(input$go_tab, {
    updateTabsetPanel(session, "tabs", selected = input$go_tab)
  })

  # A country was clicked on the Global tab -> jump to its Profile.
  observeEvent(nav$nonce, {
    req(nav$country)
    updateTabsetPanel(session, "tabs", selected = "Profile")
  }, ignoreInit = TRUE)
}
