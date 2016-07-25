library('dplyr')

options(warn=-1)

load_formulas <- function(keywords = NULL) {
  fs <- paste('db', dir('db'), 'formulas', sep='/')
  
  if (!is.null(keywords)) {
    grep_res <- unique(unlist(lapply(keywords, grep, fs)))
    if (length(grep_res) > 0)
      fs <- fs[grep_res]
  }
  
  l <- lapply(fs, readLines)
  
  if (length(fs) > 1)
    unique(do.call('append', l))
  else
    l[[1]]
}

formula_find <- function(y, ..., verbose=T, keywords=NULL) {
  # If a sequence is given, create domain.
  domain_vars <- length(list(...))
  if (domain_vars == 0) {
    x1 <- seq(0, length(y) - 1)
    domain_vars <- domain_vars + 1
  }
  
  # Load and combine the various formulas.
  text_formulas <- load_formulas('2')
  
  # Evaluate formulas.
  err <- rep(Inf, length(text_formulas))
  for (i in 1:length(text_formulas))
    err[i] <- sqrt(sum((y - eval(parse(text=text_formulas[i])))^2)) / length(y)
  
  # Best formula.
  results <- data.frame(formula=text_formulas, err) %>% 
    arrange(err) %>% 
    filter(row_number() == 1)
  
  if (verbose)
    cat(paste(ifelse(abs(results$err) < 1e-6, 
      "Found this one (exact): ", "Found this one (approx): "), results$form, '\n'))
  
  as.character(results$form)
}
