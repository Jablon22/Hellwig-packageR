# hellwig

An R package implementing **Hellwig's integral capacity method** for selecting the optimal subset of explanatory variables in econometric models.

## Installation
```r
remotes::install_github("Jablon22/Hellwig-packageR/hellwig")
```

## Method

Hellwig's method selects the best subset of explanatory variables by maximizing the integral capacity criterion **H**. It prefers variables that are:
- **strongly correlated** with the dependent variable Y
- **weakly correlated** with each other (avoiding multicollinearity)

For each candidate subset, the individual capacity is calculated as:

$$h_{jk} = \frac{r_{Yj}^2}{1 + \sum_{i \neq j} |r_{ij}|}$$

The total capacity of a subset is:

$$H_k = \sum_j h_{jk}$$

The subset with the highest H is recommended for the model.

## Usage
```r
library(hellwig)

# Example data
data <- data.frame(
  Y  = c(14000, 11200, 16500, 20000),
  X1 = c(15000, 30000, 8000, 5000),
  X2 = c(150, 130, 145, 145),
  X3 = c(1.0, 1.4, 2.0, 1.6)
)

hellwig(data$Y, data[, c("X1", "X2", "X3")])
```

Output:
```
=== Hellwig's Method - Variable Selection ===

#1 | H = 0.5942 | Variables: X1, X3
#2 | H = 0.5518 | Variables: X1, X2, X3
#3 | H = 0.3544 | Variables: X1, X2
...
```

## Parameters

| Parameter | Type | Description | Default |
|---|---|---|---|
| `y` | numeric vector | dependent variable | — |
| `x` | data.frame | candidate explanatory variables | — |
| `top` | integer | number of top subsets to display | 10 |

## License

MIT
