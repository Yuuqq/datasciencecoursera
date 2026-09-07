# Code Review

This document summarizes a review of the repository's R programming scripts. Findings are categorized by severity.

## CRITICAL

### 1. Hardcoded Directory Path Breaks Functionality
- **File:** `R_Programming/air pollution analysis programming week1/corr.R` (line 8)
- **Impact:** The script uses a hardcoded directory name `complete("specdata")` rather than the `directory` argument passed into the function. The function will fail or process the wrong data if any other directory name is provided.
- **Fix Suggestion:** Change `comcases <- complete("specdata")` to `comcases <- complete(directory)`.

### 2. Incorrect Input Validation logic for State
- **File:** `R_Programming/rprog_data_ProgAssignment3 week4/best.R` (line 6), `rankhospital.R` (line 6)
- **Impact:** State validation uses `grepl(state, stateName)`, which does substring matching instead of exact matching. This allows invalid partial inputs to pass validation or match unintended states.
- **Fix Suggestion:** Replace `tem <- grepl(state,stateName)` with exact matching: `if (!(state %in% stateName)) { stop("invalid state") }`.

## HIGH

### 1. Severe Performance Degradation from `rbind` in Loops
- **File:** `R_Programming/air pollution analysis programming week1/complete.R` (line 15), `corr.R` (line 13), `pollutantmean.R` (line 10)
- **Impact:** Growing data frames and vectors iteratively inside a `for` loop (e.g., `comcases <- rbind.data.frame(comcases,case)`) forces R to re-allocate memory and copy the entire object on every iteration. This leads to exponential time complexity O(N^2) and is extremely slow for large datasets.
- **Fix Suggestion:** Pre-allocate lists of the correct length, populate them in the loop, and use `do.call(rbind, ...)` at the end, or use vectorized functions like `lapply`.

### 2. Extremely Slow Vector Iteration for Value Replacement
- **File:** `R_Programming/rprog_data_ProgAssignment3 week4/rankhospital.R` (lines 20-24), `rankall.R` (lines 13-17)
- **Impact:** Using a `for` loop across all rows (`for (i in 1:nrow(subdata))`) to replace `"Not Available"` with `NA` bypasses R's vectorized operations and is unnecessarily slow.
- **Fix Suggestion:** Use vectorized assignment: `subdata[subdata[,2] == "Not Available", 2] <- NA`.

## MEDIUM

### 1. Incorrect Tie-Breaking Logic
- **File:** `R_Programming/rprog_data_ProgAssignment3 week4/best.R` (lines 27-31)
- **Impact:** When multiple hospitals share the lowest death rate, standard requirements dictate returning the first hospital name alphabetically. The current `for` loop overwrites `x` whenever it finds a match, resulting in the *last* hospital in the file matching the minimum score.
- **Fix Suggestion:** Filter the dataset to only include rows matching the minimum value, then sort alphabetically and return the first element.

### 2. Repetitive File I/O
- **File:** `R_Programming/rprog_data_ProgAssignment3 week4/best.R`, `rankhospital.R`, `rankall.R`
- **Impact:** `read.csv` is called on a 3MB file every time these functions are invoked. This makes iterative or batched calls to these functions very slow.
- **Fix Suggestion:** Consider passing the pre-loaded data frame into the function, or implementing a caching mechanism if multiple queries are expected in a single session.

## LOW

### 1. Hardcoded Column Indices (Fragility)
- **File:** `R_Programming/rprog_data_ProgAssignment3 week4/best.R` (lines 12-16), `rankhospital.R` (lines 12-16), `rankall.R` (lines 5-9)
- **Impact:** The code relies on magic numbers (e.g., `c(2, 11)`, `c(2, 17)`) for column selection. If the source CSV's schema changes or columns shift, the code will silently extract incorrect data.
- **Fix Suggestion:** Extract columns by their names (e.g., `"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"`) instead of numeric indices.

### 2. Missing Coercion Warnings Handling
- **File:** `R_Programming/rprog_data_ProgAssignment3 week4/best.R` (line 22)
- **Impact:** `as.numeric(subdata[,2])` will produce warning messages ("NAs introduced by coercion") if `"Not Available"` or other characters remain in the data. While it works, it reduces the developer experience with unexpected console spam.
- **Fix Suggestion:** Wrap the coercion in `suppressWarnings()`, or ensure all non-numeric strings are fully cleaned out beforehand.
