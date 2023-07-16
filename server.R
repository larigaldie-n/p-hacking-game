server <- function(input, output, session) {
  n_samples <- 25000
  n_subjects <- 30
  initial_alpha <- 0.05
  n_subjects_methods <- reactiveVal(30)
  sd_methods <- reactiveVal("All participants were included in the analysis.\n\n")
  variable_number <- reactiveVal(1)
  final_text <- reactiveVal("")
  text_final <- reactive({final_text()})
  output$text_intro_1 <- renderText("You just gathered a dataset for a study. 60 participants were randomly and evenly assigned to one of two groups - one control, and one experimental (30/group). You also arranged to get as many outcome variables as you could. You proudly recall from your statistics courses that the correct test to do when comparing the means of 2 groups of participants on a single numerical outcome variable is an independent t-test.")
  output$text_intro_2 <- renderText("You take your first outcome of interest and, with a combination of trepidation and excitement, you run a first independent t-test and start hunting for p<.05...")

  texts_remove_outliers <- c("To be honest, some of those data points are really weird after close examination. Now that I really think about it, such extreme values are almost impossible. Subjects most likely misunderstood the task or were distracted. Keeping them that would be un-scientific, really",
                             "I distinctly remember that some participants were not very attentive during the study. I did not remove them then, but it seems obvious that they are outliers that need to be removed. Otherwise, my analysis would be biased.")
  texts_add_subjects <- c("The t-test nearly reached statistical significance, which is already quite unlikely by itself. And if there was no effect, adding a few more subjects would most likely make the p-value bigger. So there's nothing wrong with that: I'll recruit some more.")
  texts_new_dv <- c("Well, this outcome variable was never the one I was REALLY interested about. I even wonder why I bothered to include and analyze this one in the first place. Let's stop fooling around and start analyzing the real variable of interest.",
                    "Of course this outcome variable is unchanged, I could have predicted that. In fact, I know authors who arrived at this conclusion earlier, so it is exactly as if I knew that already. But I have another variable to analyze in mind and for this one I am pretty certain I have the most solid theoretical background, so I will just run another test on this one.")
  texts_new_dataset <- c("Retrospectively, I must admit that the instructions given to participants were not very clear. I probably would not have been able to answer correctly myself, come to think of it. I will change the instructions and recruit another set of participants.",
                         "I am pretty sure my control task was not good enough. I will tweak it a little bit to make sure I have a good baseline, then take another set of participants. I will get it right this time.")

  runjs('document.getElementById("click_publish").style.backgroundColor = "green";')
  runjs('document.getElementById("click_perish").style.backgroundColor = "red";')
  runjs('document.getElementById("click_publish").style.width = "50%";')
  runjs('document.getElementById("click_perish").style.width = "50%";')
  output$final <- renderText(text_final())

  text_log <- reactiveVal("")
  log_text <- reactive({text_log()})
  methods_text <- reactive({paste0("The outcome variable (named Outcome_variable_", variable_number(), " in our data set) was the one and only outcome variable of interest in this dataset, and the only one that was ever analysed, looked at, collected, thought of, or even dreamed about.\n\nAs was originally planned, ", n_subjects_methods(), " subjects per group were recruited to participate in this experiment.\n\n", sd_methods(), "t(", n_subjects_methods()*2-2, ") = x.xxx, p<.05.\n\nIn conclusion, we can safely say that we were right all along.")})

  output$methods <- renderText(methods_text())
  output$log <- renderText(log_text())

  randomize_texts <- function()
  {
    output$text_add_subjects <- renderText(sample(texts_add_subjects, 1))
    output$text_remove_outliers <- renderText(sample(texts_remove_outliers, 1))
    output$text_new_dv <- renderText(sample(texts_new_dv, 1))
    output$text_new_dataset <- renderText(sample(texts_new_dataset, 1))
  }
  randomize_texts()

  tib <- reactiveVal()
  real_alpha <- reactive({round(1-nrow(tib())/n_samples, 4)})
  output$p_value <- renderText(real_alpha())

  observeEvent(input$click_add_subjects_1, {
    show_modal_spinner()
    tib(add_subjects(tib(), 1, initial_alpha))
    n_subjects_methods(n_subjects_methods() + 1)
    text_log(paste0(text_log(), "You added 1 more subject per group. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("All participants were included in the analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$click_add_subjects_3, {
    show_modal_spinner()
    tib(add_subjects(tib(), 3, initial_alpha))
    n_subjects_methods(n_subjects_methods() + 3)
    text_log(paste0(text_log(), "You added 3 more subjects per group. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("All participants were included in the analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$click_add_subjects_5, {
    show_modal_spinner()
    tib(add_subjects(tib(), 5, initial_alpha))
    n_subjects_methods(n_subjects_methods() + 5)
    text_log(paste0(text_log(), "You added 5 more subjects per group. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("All participants were included in the analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$click_remove_outliers_2sd, {
    show_modal_spinner()
    tib(remove_outliers(tib(), 2, initial_alpha))
    text_log(paste0(text_log(), "You removed participants with scores +/- 2sd. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("Participants with scores +/- 2sd were deemed outliers, and removed from further analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$click_remove_outliers_25sd, {
    show_modal_spinner()
    tib(remove_outliers(tib(), 2.5, initial_alpha))
    text_log(paste0(text_log(), "You removed participants with scores +/- 2.5sd. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("Participants with scores +/- 2.5sd were deemed outliers, and removed from further analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$click_remove_outliers_3sd, {
    show_modal_spinner()
    tib(remove_outliers(tib(), 3, initial_alpha))
    text_log(paste0(text_log(), "You removed participants with scores +/- 3sd. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("Participants with scores +/- 3sd were deemed outliers, and removed from further analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$click_new_dv, {
    show_modal_spinner()
    tib(new_dataset(tib(), n_subjects_methods(), initial_alpha))
    text_log(paste0(text_log(), "You changed the outcome variable. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("All participants were included in the analysis.\n\n")
    randomize_texts()
    variable_number(variable_number() + 1)
    remove_modal_spinner()
  })

  observeEvent(input$click_new_dataset, {
    show_modal_spinner()
    tib(new_dataset(tib(), n_subjects, initial_alpha))
    n_subjects_methods(n_subjects)
    text_log(paste0(text_log(), "You recruited a whole new batch of subjects. Probability of a type I error a this point: ", real_alpha(), "\n\n"))
    sd_methods("All participants were included in the analysis.\n\n")
    randomize_texts()
    remove_modal_spinner()
  })
  observeEvent(input$start, {
    updateActionButton(session, "start",
                       label = "Restart from scratch")
    show_modal_spinner()
    hide("starting_text")
    hide("final")
    variable_number(1)
    text_log("")
    tib(create_dataset(n_samples, n_subjects, initial_alpha))
    randomize_texts()
    remove_modal_spinner()
    show("start_hidden")
  })

  observeEvent(input$click_publish, {
    final_text(paste0("Congratulations, you managed to publish an article with a real (approximate) proportion of type I error of ", real_alpha(),", and are now one step closer to a tenured position at a prestigious university!\n\nSince you probably had a 2 hours long mandatory training on research ethics at your current university, the whole world knows you stayed ethical during your data analysis process.\n\nThere is no need for any kind of further scrutiny from your peers or the public, really.\n\nTerrific job!"))
    hide("starting_text")
    hide("start_hidden")
    show("final")
  })
  observeEvent(input$click_perish, {
    final_text("Congratulations, you managed to escape academia thanks to your inability to find another position!\n\nThe icing on the cake is that since you failed to publish non-significant results, generations of academics will be able to get tenured by publishing weirdly unreplicable effects on the topic you were studying.\n\nGreat job!")
    hide("starting_text")
    hide("start_hidden")
    show("final")
  })
}
