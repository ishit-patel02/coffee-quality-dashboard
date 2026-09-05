# Conclusion tab: findings and conclusions
# ------------------------------------------
# The three conditions that score highest (origin, altitude, moisture) as
# cards, then a formal written summary of what the analysis shows. The old
# coffee-finder table now lives on as the Sensory Analysis tab's coffee builder.

# A styled section heading: tiny mono kicker above a clean title.
sum_heading <- function(kicker, title) {
  div(style = "margin:6px 0 14px;",
      div(style = paste0("font-family:ui-monospace,Consolas,monospace; font-size:11px;",
                         "letter-spacing:.16em; text-transform:uppercase; color:#9C5A20;",
                         "margin-bottom:4px;"), kicker),
      h4(style = "margin:0;", title))
}

# One numbered finding card (styling in ui.R: .takeaway-card).
tk_card <- function(i, accent, title, body) {
  div(class = "takeaway-card", style = sprintf("--tk-accent:%s;", accent),
      div(class = "takeaway-num", sprintf("No. %d", i)),
      div(class = "takeaway-title", title),
      p(class = "takeaway-body", body))
}

conclusionUI <- function(id) {
  ns <- NS(id)
  tagList(
      h2("Conclusion"),
      p(style = "max-width:860px; font-size:17px; color:#444; line-height:1.6;",
        "This page consolidates the findings of the analysis. It first reports the ",
        "growing conditions associated with the highest average scores, then ",
        "summarises the sensory patterns in the recorded grades. These comparisons ",
        "describe this dataset and do not establish cause and effect."),

      sum_heading("Growing conditions", "What scores highest"),
      p(style = "color:#888; font-size:13px;",
        "The highest-scoring origin, growing altitude and bean moisture, ranked by ",
        "average cup score. Altitude and moisture bands require at least 20 graded ",
        "coffees to qualify."),
      fluidRow(
        column(4, uiOutput(ns("lift_country"))),
        column(4, uiOutput(ns("lift_altitude"))),
        column(4, uiOutput(ns("lift_moisture")))
      ),

      hr(),

      sum_heading("Key findings", "What the analysis shows"),
      div(class = "takeaway-grid",
        tk_card(1, CAT_COLS[1], "Aftertaste and flavour track the score",
          paste0("Of the ten scored components, aftertaste and flavour track the ",
                 "overall grade most closely in this dataset. These components ",
                 "also contribute to the total, so their correlations should not ",
                 "be read as independent causal effects.")),
        tk_card(2, CAT_COLS[2], "Compare the full sensory profile",
          paste0("The scatter plots let you inspect how total scores vary at a ",
                 "given sensory score. Select a coffee to see all ten components ",
                 "before drawing conclusions from one attribute.")),
        tk_card(3, CAT_COLS[3], "Altitude has a weak positive association",
          paste0("Higher-grown coffees tend to score a little better, though the ",
                 "association is modest and other differences between coffees ",
                 "may contribute to the pattern.")),
        tk_card(4, CAT_COLS[4], "Inspect low-scoring components",
          paste0("Clean cup, sweetness and uniformity often receive high marks. ",
                 "Lower values can help explain an individual coffee's total, ",
                 "but the charts do not diagnose the cause of a defect.")),
        tk_card(5, CAT_COLS[5], "Compare altitude and moisture together",
          paste0("The heatmap compares average scores within altitude and moisture ",
                 "bands. Small cells can give unstable averages; this visual ",
                 "comparison is not a statistical test of an interaction.")),
        tk_card(6, CAT_COLS[6], "Processing-method scores overlap",
          paste0("The processing-method boxplots show overlapping score ",
                 "distributions. No significance test or adjustment for origin ",
                 "is performed, so the dashboard cannot establish which method ",
                 "causes better scores."))
      ),

      hr(),

      sum_heading("In summary", "The overall picture"),
      p(style = "max-width:860px; font-size:16px; color:#2B2018; line-height:1.7;",
        "Use the dashboard to explore associations between origin, growing ",
        "conditions and recorded sensory scores. Sample sizes differ across ",
        "groups, and these historical observations do not establish cause and ",
        "effect or predict the quality of a new coffee.")
  )
}

conclusionServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    scored <- data[!is.na(data$Total.Cup.Points) & data$Total.Cup.Points > 0, ]

    # Average score per country (>= 5 coffees for fairness).
    country_avg <- reactive({
      tab <- summarise_by(scored, "Country.of.Origin")
      tab <- tab[tab$n_coffees >= 5, ]
      tab[order(-tab$avg_score), ]
    })
    # ── What scores highest: origin, altitude band, moisture band ─────────────
    # Highest-scoring altitude band (same bands as the Attributing-Factors
    # heatmap; a band needs >= 20 graded coffees to qualify, for fairness).
    best_alt_band <- reactive({
      d <- scored[!is.na(scored$altitude_mean_meters) &
                  scored$altitude_mean_meters > 0 &
                  scored$altitude_mean_meters < 4000, ]
      d$band <- alt_band(d$altitude_mean_meters)
      agg  <- tapply(d$Total.Cup.Points, d$band, mean, na.rm = TRUE)
      keep <- names(table(d$band))[table(d$band) >= 20]
      agg  <- agg[keep]; agg <- agg[!is.na(agg)]
      if (!length(agg)) return(NULL)
      list(band = names(which.max(agg)), score = max(agg))
    })
    # Highest-scoring bean-moisture band (>= 20 graded coffees).
    best_moist_band <- reactive({
      d <- scored[!is.na(scored$Moisture) & scored$Moisture > 0, ]
      d$band <- moist_band(d$Moisture)
      agg  <- tapply(d$Total.Cup.Points, d$band, mean, na.rm = TRUE)
      keep <- names(table(d$band))[table(d$band) >= 20]
      agg  <- agg[keep]; agg <- agg[!is.na(agg)]
      if (!length(agg)) return(NULL)
      list(band = names(which.max(agg)), score = max(agg))
    })

    output$lift_country <- renderUI({
      ca <- country_avg()
      stat_card("Highest scoring country",
                paste0(ca$group[1], " at ", sprintf("%.1f", ca$avg_score[1])),
                COFFEE_COLS$green)
    })
    output$lift_altitude <- renderUI({
      b <- best_alt_band()
      v <- if (is.null(b)) "N/A" else paste0(b$band, " m at ", sprintf("%.1f", b$score))
      stat_card("Highest scoring altitude", v, COFFEE_COLS$blue)
    })
    output$lift_moisture <- renderUI({
      b <- best_moist_band()
      v <- if (is.null(b)) "N/A" else paste0(b$band, " at ", sprintf("%.1f", b$score))
      stat_card("Highest scoring moisture", v, COFFEE_COLS$orange)
    })
  })
}
