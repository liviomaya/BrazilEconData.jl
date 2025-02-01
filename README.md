# BrazilEconData.jl

BrazilEconData.jl access the the API and fetches Brazilian macroeconomic data from three sources: the Brazilian Central Bank (BCB), IBGE and Ipeadata.

This package is licensed under the MIT License. There is no documentation beyond this README file.

## Installation

### Getting the code

To use the BrazilEconData package, you can either clone or fork this repository:

- To **clone the repository**, run:
  ```bash
  git clone https://github.com/liviomaya/BrazilEconData.jl.git
  cd MethodMoments.jl
  ```
- To **fork the repository**:
    - Navigate to the GitHub page for the repository: `https://github.com/liviomaya/BrazilEconData.jl`
    - Click the "Fork" button in the top-right corner of the page. This will create a copy of the repository under your GitHub account.

### Setting up the package
    
After obtaining a local copy of the `BrazilEconData` repository through cloning or forking, you can set it up as a Julia package using the following steps:

1. **Activate and instantiate the project**. Navigate to the package directory and use the following Julia commands:

    ```julia
    using Pkg
    Pkg.activate("path/to/BrazilEconData")  # Replace with actual path to MethodMoments
    Pkg.instantiate()
    ```

    `Pkg.activate()` sets the current environment to the package directory, and `Pkg.instantiate()` installs any dependencies listed in the package's `Project.toml` file.

2. **Use the package**. After setting up the environment, you can start using `MethodMoments`.

    ```julia
    using BrazilEconData
    ```

### Accessing data

Use function `ibge`