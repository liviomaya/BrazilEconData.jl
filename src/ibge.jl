
# convert date string to Date
function ibge_convert_to_date(str::String, freq::String)
    year = parse(Int64, str[1:4])
    compl = parse(Int64, str[end-1:end])
    if freq == "m"
        d = Date(year, compl)
    elseif freq == "q"
        d = Date(year, 3 * compl)
    end
    return d
end

# convert dictionary output to data frame
function ibge_build_frame(D::Vector{Any}, freq::String)

    N = length(D[1]["resultados"])
    df = DataFrame(:date => Vector{Date}(undef, 0))
    for n in 1:N
        if N == 1
            lab = "series"
        else
            lab = "s" * collect(keys(D[1]["resultados"][n]["classificacoes"][1]["categoria"]))[1]
        end
        series_dict = D[1]["resultados"][n]["series"][1]["serie"]
        df_series = DataFrame(:date => Vector{Date}(undef, 0), :series => Vector{Float64}(undef, 0))

        for (key, val) in series_dict
            d = ibge_convert_to_date(key, freq)
            if val == "..."
                val = NaN
            end
            v = parse(Float64, val)
            df_series = vcat(df_series, DataFrame(:date => [d], :series => [v]))
        end

        df = outerjoin(df, df_series, on=:date)
        rename!(df, :series => lab)
    end
    sort!(df, :date)
    df = coalesce.(df, NaN)

    return df
end

# fetch API and return data frame
"""
        df = get(url::String, frequency::String)

Fetch series in IBGE's API under the address `url`. Use the `QUERY BUILD` tab in

_`https://servicodados.ibge.gov.br/api/docs/agregados?versao=3`_.

Argument `frequency` should be `m` = month or `q` = quarterly).
"""
function ibge(url::String, frequency::String)
    response = HTTP.request("GET", url)
    json_file = String(copy(response.body))
    D = JSON.parse(json_file)
    df = ibge_build_frame(D, frequency)
    return df
end