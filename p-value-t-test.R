create_dataset <- function(n_samples, n_subjects)
{
  tib <- tibble(.rows=n_samples)
  tib$g1 <- replicate(n_samples, rnorm(n_subjects, 15, 5), simplify = FALSE)
  tib$g2 <- replicate(n_samples, rnorm(n_subjects, 15, 5), simplify = FALSE)
  tib <- tib %>% rowwise() %>% mutate(p = t.test(g1, g2)[['p.value']])
  tib <- tib %>% filter(p>.05)
  return(tib)
}

add_subjects <- function(tib, n_add)
{
  tib <- tib %>% rowwise() %>% mutate(g1 = list(c(g1, rnorm(n_add, 15, 5))), g2 = list(c(g2, rnorm(n_add, 15, 5))))
  tib <- tib %>% rowwise() %>% mutate(p = t.test(g1, g2)[['p.value']])
  tib <- tib %>% filter(p>.05)
  return(tib)
}

new_dataset <- function(tib, n_subjects)
{
  tib$g1 <- replicate(nrow(tib), rnorm(n_subjects, 15, 5), simplify = FALSE)
  tib$g2 <- replicate(nrow(tib), rnorm(n_subjects, 15, 5), simplify = FALSE)
  tib <- tib %>% rowwise() %>% mutate(p = t.test(g1, g2)[['p.value']])
  tib <- tib %>% filter(p>.05)
  return(tib)
}

remove_outliers <- function(tib, sdv)
{
  tib <- tib %>% rowwise() %>% mutate(g1 = list(g1[(g1<mean(g1)+sdv*sd(g1)) & (g1>mean(g1)-sdv*sd(g1))]), g2 = list(g2[(g2<mean(g2)+sdv*sd(g2)) & (g2>mean(g2)-sdv*sd(g2))]))
  tib <- tib %>% rowwise() %>% mutate(p = t.test(g1, g2)[['p.value']])
  tib <- tib %>% filter(p>.05)
  return(tib)
}
