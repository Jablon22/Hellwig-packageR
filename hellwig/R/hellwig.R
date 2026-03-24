#' Hellwig's Method for Variable Selection
#'
#' Selects the best subset of explanatory variables for an econometric model
#' using Hellwig's integral capacity criterion. Prefers variables that are
#' strongly correlated with the dependent variable and weakly correlated
#' with each other.
#'
#' @param y A numeric vector representing the dependent variable.
#' @param x A data.frame of candidate explanatory variables.
#' @param top Integer. Number of top subsets to display. Default is 10.
#'
#' @return Invisibly returns a data.frame with subsets and their H values,
#'   sorted in descending order.
#'
#' @examples
#' data <- data.frame(
#'   Y  = c(14000, 11200, 16500, 20000),
#'   X1 = c(15000, 30000, 8000, 5000),
#'   X2 = c(150, 130, 145, 145),
#'   X3 = c(1.0, 1.4, 2.0, 1.6)
#' )
#' hellwig(data$Y, data[, c("X1", "X2", "X3")])
#'
#' @export
hellwig <- function(y, x, top = 10) {
  cor_matrix <- cor(cbind(y, x))
  cor_y <- cor_matrix[1, -1]
  cor_x <- cor_matrix[-1, -1]

  n <- ncol(x)
  variables <- colnames(x)

  subsets <- do.call(c, lapply(1:n, function(k) combn(1:n, k, simplify = FALSE)))

  results <- lapply(subsets, function(subset) {
    h <- sapply(subset, function(j) {
      sum_cor <- sum(abs(cor_x[j, subset[subset != j]]))
      cor_y[j]^2 / (1 + sum_cor)
    })
    H <- sum(h)
    list(variables = paste(variables[subset], collapse = ", "), H = round(H, 4))
  })

  H_values <- sapply(results, function(r) r$H)
  results <- results[order(H_values, decreasing = TRUE)]

  cat("=== Hellwig's Method - Variable Selection ===\n\n")
  for (i in seq_len(min(top, length(results)))) {
    r <- results[[i]]
    cat(sprintf("#%d | H = %.4f | Variables: %s\n", i, r$H, r$variables))
  }

  invisible(
    data.frame(
      rank      = seq_len(length(results)),
      variables = sapply(results, function(r) r$variables),
      H         = sapply(results, function(r) r$H)
    )
  )
}
