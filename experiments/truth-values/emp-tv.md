# Metta Functions Documentation

This document provides an overview of several Metta functions used for calculating empirical truth values, support estimates, and performing database manipulations. The functions incorporate techniques such as bootstrapping, resampling, and probabilistic estimation. Below you will find a detailed description of each function, including what it does, its inputs, and its outputs.

---

## Table of Contents

- [Empirical Truth Value Functions](#empirical-truth-value-functions)
- [Support and Probability Functions](#support-and-probability-functions)
- [Database and Space Manipulation Functions](#database-and-space-manipulation-functions)
- [Random Sampling Functions](#random-sampling-functions)
- [Bootstrapping Functions](#bootstrapping-functions)
- [Helper Functions](#helper-functions)
- [Usage Summary](#usage-summary)

---

## Empirical Truth Value Functions

### `EMPTV`
- **Description:**  
  Constructor for creating an empirical truth value.
- **Inputs:**  
  - A pattern (or related structure)  
  - A `db_ratio` (database ratio)
- **Output:**  
  - An object of type `TruthValue` that encapsulates a mean and a confidence value.

### `emp-tv`
- **Description:**  
  Calculates the empirical truth value of a pattern in a database.
- **Inputs:**  
  - `$pattern`: The pattern to be evaluated.  
  - `$db`: The database (or space) in which the pattern is searched.
- **Output:**  
  - An empirical truth value (an `EMPTV` object) containing:  
    - **Mean:** Computed as the ratio of the pattern’s support (`sup-num`) to its universe count.  
    - **Confidence:** Derived from the count via `count_to_confidence` (scaled by `1e-1`).

### `emp-tv-bs`
- **Description:**  
  Computes the empirical truth value using bootstrapping (resampling) if necessary.
- **Inputs (Variant 1):**  
  - `$pattern`: The pattern to evaluate.  
  - `$db`: The database.  
  - `$db_size`: The effective database size.  
  - `$db_ratio`: The ratio used to scale the database size.  
  - `$support_estimate`: The estimated support for the pattern.
- **Inputs (Variant 2):**  
  - `$pattern`, `$db`, `$n-resample` (number of resampling iterations), and `$subsize` (subsample size).
- **Output:**  
  - An empirical truth value computed either by:
    - Averaging multiple empirical truth values obtained through resampling (`emp-tv-bs-helper`), or  
    - Directly calculating via `emp-tv` if the subsample size is not less than the database size.

---

## Support and Probability Functions

### `count_to_confidence`
- **Description:**  
  Converts a count to a confidence value using a formula that involves a default constant.
- **Inputs:**  
  - `$x`: A numerical count.
- **Output:**  
  - A confidence value computed as:  
    \[
    \text{confidence} = \frac{x}{x + \text{Default\_k}}
    \]
  where `Default_k` is defined elsewhere (with a default value of 1).

### `prob_to_support`
- **Description:**  
  Estimates the support of a pattern in the database based on a probability estimate.
- **Inputs:**  
  - `$pattern`: The pattern to be evaluated.  
  - `$db`: The database in which the pattern is searched.  
  - `$prob`: A numerical probability estimate.
- **Output:**  
  - The support value, calculated as:  
    \[
    \text{support} = \text{prob} \times \text{(universe count of the pattern in } db)
    \]

### `support_estimate_calculator`
- **Description:**  
  Calculates the support estimate for a pattern and then determines the empirical truth value, possibly using bootstrapping.
- **Inputs:**  
  - `$pattern`: The pattern to be evaluated.  
  - `$db`: The database.  
  - `$prob_estimate`: The probability estimate of the pattern.  
  - `$db_ratio`: A scaling factor for the database size.
- **Output:**  
  - An empirical truth value computed using `emp_tv_pbs`, which chooses between a bootstrapped calculation (`emp-tv-bs`) or a direct calculation (`emp-tv`) based on the estimated support.

### `categorize_by_support_estimate`
- **Description:**  
  Categorizes the support estimate relative to the database size.
- **Inputs:**  
  - `$db_size`: The size of the database.  
  - `$support_estimate`: The estimated support value.
- **Output:**  
  - Returns `1` if the support estimate is greater than or equal to the database size, or `2` if it is lower.

### `emp_tv_pbs`
- **Description:**  
  Selects the appropriate empirical truth value computation method (bootstrapped or direct) based on support estimate categorization.
- **Inputs:**  
  - `$pattern`: The pattern to evaluate.  
  - `$db`: The database.  
  - `$prob_estimate`: The probability estimate.  
  - `$db_ratio`: The database ratio.  
  - `$db_size`: The effective size of the database.  
  - `$support_estimate`: The estimated support for the pattern.
- **Output:**  
  - An empirical truth value computed by either:
    - `emp-tv-bs` (if support estimate is high), or  
    - `emp-tv` (if support estimate is low).

---

## Database and Space Manipulation Functions

### `copy-db`
- **Description:**  
  Creates a copy of the given database.
- **Inputs:**  
  - `$db`: The target (new) database space to which atoms will be added.  
  - `$old-db-content`: A list (sequence) of atoms from the original database.
- **Output:**  
  - A new database containing all atoms copied from the original.

### `add_n_atoms_to_db`
- **Description:**  
  Adds a specified number of atoms to a database recursively.
- **Inputs:**  
  - `$db`: The database to which atoms are to be added.  
  - `$n`: The number of atoms to add.
- **Output:**  
  - A modified database with `$n` new atoms appended.

### `copy-and-add-atom`
- **Description:**  
  Creates a copy of a database and then adds a specified number of atoms to it.
- **Inputs:**  
  - `$db`: The original database.  
  - `$n`: The number of atoms to add.
- **Output:**  
  - A new database that is a copy of the original, expanded by the new atoms.

### `duplicate-and-expand-space`
- **Description:**  
  Duplicates an entire space (database) and expands it by adding a specified number of atoms.
- **Inputs:**  
  - `$space`: The original space.  
  - `$n`: The number of atoms to add.
- **Output:**  
  - A new, expanded space that is a duplicate of the original.

### `copy-db-by-size`
- **Description:**  
  Copies atoms from the original database into a new database until a specified size is reached.
- **Inputs:**  
  - `$db`: The new database space.  
  - `$old-db-content`: The sequence of atoms from the original database.  
  - `$n`: The current count of atoms copied (typically starts at 0).  
  - `$size`: The maximum number of atoms to be copied.
- **Output:**  
  - A new database containing up to `$size` atoms from the original.

### `subsample`
- **Description:**  
  Adjusts the database to match a target subset size.
- **Inputs:**  
  - `$db`: The original database.  
  - `$subsize`: The desired subset size.
- **Output:**  
  - A database that is either:
    - The original database (if its size is less than or equal to `$subsize`), or  
    - A modified database (via duplication/expansion or reduction) to match the subset size, based on categorization by `categorize_subsize`.

### `do_emp_tv`
- **Description:**  
  A high-level function that calculates the empirical truth value for a given pattern.
- **Inputs:**  
  - `$pattern`: The pattern to be evaluated.  
  - `$db`: The database.  
  - `$db_ratio`: The ratio used to scale the database.
- **Output:**  
  - An empirical truth value computed by:
    1. Extracting the sequence of atoms from the database.
    2. Estimating the joint truth value (via `ji_tv_est`).
    3. Using the support estimate calculator to finalize the empirical truth value.

---

## Random Sampling Functions

### `gen-random`
- **Description:**  
  Generates a random integer within the range `[0, $max-value)`.
- **Inputs:**  
  - `$max-value`: The upper bound for the random number.
- **Output:**  
  - A random integer in the specified range.

### `get-element`
- **Description:**  
  Retrieves an element from a list based on its index.
- **Inputs:**  
  - `$index`: The position of the element in the list.  
  - `$list`: The list from which to retrieve the element.
- **Output:**  
  - The element at the given index.

### `gen-random-subsample`
- **Description:**  
  Creates a subsample by randomly selecting atoms from the database.
- **Inputs:**  
  - `$db`: The original database.  
  - `$subsize`: The number of atoms to include in the subsample.  
  - `$space`: The initial target space (often empty) where the subsample will be collected.
- **Output:**  
  - A new space containing a random subsample of atoms, with the number of atoms equal to `$subsize`.

### `emp-tv-subsmp`
- **Description:**  
  Computes the empirical truth value for a pattern based on a random subsample.
- **Inputs:**  
  - `$pattern`: The pattern to evaluate.  
  - `$db`: The database.  
  - `$subsize`: The size of the subsample.
- **Output:**  
  - An empirical truth value computed on the subsample using `emp-tv`.

---

## Bootstrapping Functions

### `emp-tv-bs-helper`
- **Description:**  
  A helper function that performs multiple resampling iterations to collect empirical truth values.
- **Inputs:**  
  - `$pattern`: The pattern to evaluate.  
  - `$db`: The database.  
  - `$n-resample`: The number of resampling iterations.  
  - `$subsize`: The size of each subsample.
- **Output:**  
  - A list (sequence) of empirical truth values, one from each resample iteration.

### `subsmp-size`
- **Description:**  
  Determines an appropriate subsample size based on pattern complexity, database size, and support estimate.
- **Inputs:**  
  - `$pattern`: The pattern to evaluate (used to determine the number of conjuncts).  
  - `$db-size`: The effective size of the database.  
  - `$support-estimate`: The estimated support of the pattern.
- **Output:**  
  - A numerical value representing the chosen subsample size, ensuring it is not below a minimum threshold and does not exceed the database size.

### `mk-stv`
- **Description:**  
  Constructs a statistical truth value based on the mean and variance of empirical truth values.
- **Inputs:**  
  - `$mean`: The average empirical truth value.  
  - `$variance`: The variance of the truth values.
- **Output:**  
  - An `EMPTV` (or `STV`) object that includes:
    - A **mode** (calculated based on the beta distribution parameters derived from the mean and variance).  
    - A **confidence** value based on a computed count and a default constant (`DEFAULT_K`).

---

## Helper Functions

### `ji_tv_est` and `do-ji-tv-est-dummy`
- **Description:**  
  Provide (dummy) implementations for estimating the joint truth value of a pattern.
- **Inputs:**  
  - `$pattern`: The pattern to evaluate.  
  - `$db`: The database.
- **Output:**  
  - A truth value (either `STV` or `EMPTV`), typically with fixed strength and confidence values.

### Other Utility Functions
Several other functions (e.g., `n_conjuncts`, `pow-py`, `tuple-count`, `collapse`, `get-atoms`, `add-atom`, `new-space`, `match`) are referenced within these implementations. These are assumed to be part of the underlying system or library, handling tasks such as:
- Pattern matching in a database.
- Mathematical operations (e.g., power calculations).
- Database/space manipulation.

---

## Usage Summary

- **Empirical Truth Value Calculation:**  
  Use `do_emp_tv` to compute the empirical truth value of a pattern within a given database, adjusting for database size via `$db_ratio`.

- **Bootstrapping and Resampling:**  
  When a support estimate is high relative to the database size, `emp-tv-bs` (with the help of `emp-tv-bs-helper` and `subsmp-size`) is used to perform bootstrapping, yielding a robust empirical truth value.

- **Database Manipulation:**  
  Functions like `copy-db`, `add_n_atoms_to_db`, `copy-and-add-atom`, and `subsample` enable duplication and adjustment of database content for various analyses.

- **Random Sampling:**  
  Use `gen-random-subsample` and `emp-tv-subsmp` to compute empirical truth values on random subsamples of the database, which is useful in stochastic or bootstrapped estimation processes.

---

*Note: Some of the referenced functions (e.g., `n_conjuncts`, `pow-py`) are assumed to be defined in the common utility.*

---

This documentation should serve as a guide to understanding what each function does, what inputs are expected, and what outputs are produced within the context of Metta's empirical truth value computations and database manipulations.
