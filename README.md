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

#### IBGE

Use function `ibge` to download a single series from IBGE's API (see [servicodados.ibge.gov.br](servicodados.ibge.gov.br)). The arguments should be: 1. the url for the data series, the query of which you can build using IBGE's website; 2. the frequency of the series (`"m"` for monthly, `"q"` for quarterly).   

For example, to download CPI data:
```julia
url = "https://servicodados.ibge.gov.br/api/v3/agregados/6691/periodos/-6/variaveis/2266?localidades=N1[all]"
ibge_df = ibge(url, "m"); # consumer price index
```

#### Brazilian Central Bank (BCB)

Use function `bcb` to fetch one or more series. The single argument should be the id number of the corresponding series (which you can find on the [BCB's website](https://www3.bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries)). You can pass it as an integer, or as a string, and you can pass a vector of id numbers. For example:
```julia
bcb_df = bcb(1782) # monetary base
bcb_df = bcb(["1780", "1781", "1782"])
```

#### Ipeadata
Use function `ipeadata` to fetch one or more series. The argument should be the id of the series. For example: 
```julia
ipedata_df = ipeadata("BM12_PIB12")
ipedata_df = ipeadata(["BM12_PIB12", "SCN10_VASERVN10"])
```
For convenience, you can use `ipeadata_dictionaries()` to download the dictionaries of themes and time series, and then `ipeadata_print` to filter the dictionary of series.
```julia
themes, series = ipeadata_dictionaries()
ipeadata_print(series; theme_code=8, active=true, frequency=nothing)
```