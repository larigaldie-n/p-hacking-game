library(tidyverse)
library(shinyjs)
library(shinybusy)
source("p-value-t-test.R")

ui <- fluidPage(theme = bslib::bs_theme(bootswatch = "darkly"),
                tags$style(type='text/css', '#methods {white-space: pre-wrap;}', '#final {white-space: pre-wrap;}', '#log {white-space: pre-wrap;}'),
                useShinyjs(),
                tags$head(tags$style("#p_value{color: red;
                                 font-size: 20px;
                                 }")),
  fluidRow(id="starting_text",
    column(2),
    column(8, align="center", br(), textOutput("text_intro_1"), br(), textOutput("text_intro_2"), br(), h2("Your questionable statistical journey begins!"), br()),
    column(2)

  ),
  fluidRow(
           column(2),
           column(8, align="center",
                  actionButton("start", "Start simulation!"), br()),
           column(2)
  ),
  hidden(span(id="start_hidden", fluidRow(
      column(4),
      column(4, align="center", h5("Game instructions:"), p("This educational game requires you to imagine that you just performed a t-test, and come up with an imaginary p-value. You can choose from a number of common statistical practices, and imagine each time that you performed another t-test granting another p-value of your choice. You can keep going for as long as you decide that you did not obtain p<.05. At any moment, you can scroll down to see how your choices influenced your probability of finding a statistical effect given that there was none (the original meaning of the alpha threshold).", style="color: lightblue"), br()),
      column(4)

    ),
    fluidRow(
      column(4),
      column(4, align="center", h3("Your latest t-test was not significant? No problem!"), br(), h4("Just pick a scientific rationale from the following list of inner dialogues!")),
      column(4)

    ),
  hr(),
  fluidRow(column(1),
           column(10, align="center", textOutput("text_add_subjects"), tags$br(), actionButton("click_add_subjects_1", "Slowly, gently: 1 more per group. I do not want to catch a uselessly tiny effect size by mistake"), br(), br(), actionButton("click_add_subjects_3", "3 more per group. Just enough to catch the effect that's clearly there"), br(), br(), actionButton("click_add_subjects_5", "Participants galore: 5 more per group. More subjects = more power = better science")),
           column(1)),
  hr(),
  fluidRow(column(1),
           column(10, align="center", textOutput("text_remove_outliers"), tags$br(), actionButton("click_remove_outliers_2sd", "Removing at +/-2sd is my usual, and hence correct, way"), br(), br(), actionButton("click_remove_outliers_25sd", "+/-2.5sd is very sciencey: it's not even a round number"), br(), br(), actionButton("click_remove_outliers_3sd", "+/-3sd, because I am a very rigorous person")),
           column(1)),
  hr(),
  fluidRow(column(1),
           column(10, align="center", textOutput("text_new_dv"), tags$br(), actionButton("click_new_dv", "I clearly have a scientifically sound reason to do that")),
           column(1)),
  hr(),
  fluidRow(column(1),
           column(10, align="center", textOutput("text_new_dataset"), tags$br(), actionButton("click_new_dataset", "That is an indisputably good argument, let us proceed")),
           column(1)),
  hr(),
  fluidRow(
    column(4),
    column(4, align="center", h5("Your real probability of wrongly inferring the existence of an effect if your current test is significant at alpha<.05 (type I error) is now approximately:"), verbatimTextOutput("p_value"), br()),
    column(4)
    
  ),
  fluidRow(column(5, align="center", h2("What to report in your article"), verbatimTextOutput("methods")),
           column(2),
           column(5, align="center", h2("Statistical log"), verbatimTextOutput("log"))),
  hr(),
  fluidRow(column(5, align="center", actionButton("click_publish", "Publish")),
           column(2),
           column(5, align="center", actionButton("click_perish", "Perish"))),hr()
  )),
  hidden(span(id="final",
         fluidRow(column(1),
                  column(10, align="center", verbatimTextOutput("final")),
                  column(1))))
  )
