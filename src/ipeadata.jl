base_URL() = "http://www.ipeadata.gov.br/api/odata4/"

function build_theme_list()

    # Download series info
    d = HTTP.request("GET", base_URL() * "Temas")
    jfile = String(copy(d.body))
    dict = JSON.parse(jfile)

    # DataFrame
    N = length(dict["value"])
    df = DataFrame(:theme => Vector{String}(undef, 0), :theme_code => Vector{Int}(undef, 0))
    for n in 1:N
        dict_n = dict["value"][n]
        sd = DataFrame(:theme => dict_n["TEMNOME"], :theme_code => dict_n["TEMCODIGO"])
        df = vcat(df, sd)
    end

    return df
end

"""
    themes, series = ipeadata_dictionaries()

Build dictionaries of themes and series for data available through Ipeadata. 
"""
function ipeadata_dictionaries()

    # Download series info
    d = HTTP.request("GET", base_URL() * "Metadados")
    jfile = String(copy(d.body))
    dict = JSON.parse(jfile)

    # build theme list
    td = build_theme_list()

    # DataFrame
    N = length(dict["value"])
    df = DataFrame(:id => Vector{String}(undef, 0),
        :name => Vector{String}(undef, 0),
        :theme_code => Vector{Int}(undef, 0),
        :active => Vector{Bool}(undef, 0),
        :frequency => Vector{String}(undef, 0),
        :country => Vector{String}(undef, 0),
        :comments => Vector{String}(undef, 0))
    for n in 1:N
        dict_n = dict["value"][n]
        sd = DataFrame(:id => dict_n["SERCODIGO"],
            :name => dict_n["SERNOME"],
            :theme_code => dict_n["TEMCODIGO"],
            :active => dict_n["SERSTATUS"] .== "A",
            :frequency => dict_n["PERNOME"],
            :country => dict_n["PAICODIGO"],
            :comments => dict_n["SERCOMENTARIO"],
        )
        df = vcat(df, sd)
    end

    # merge with theme code
    df = innerjoin(df, td, on=:theme_code)

    # re-order columns
    select!(df, [:id, :name, :theme_code, :theme, :active, :frequency, :country, :comments])

    # remove nothing values
    df = ifelse.(isnothing.(df), "", df)

    return td, df
end

"""
    ipeadata_print(series; theme_code, active, frequency, country)

Print Ipeadata dictionary of series, filtering according to keyword arguments. Use `ipeadata_dictionaries` to download dictionaries.
"""
function ipeadata_print(dict; theme_code=nothing, active=nothing, frequency=nothing, country=nothing)

    filtered = dict[:, [:id, :name, :theme_code, :active, :frequency, :country]]

    if !isnothing(theme_code)
        @assert typeof(theme_code) == Int64
        filtered = filtered[filtered.theme_code.==theme_code, :]
    end

    if !isnothing(active)
        @assert typeof(active) == Bool
        filtered = filtered[filtered.active.==active, :]
    end

    if !isnothing(frequency)
        @assert typeof(frequency) == String
        filtered = filtered[filtered.frequency.==frequency, :]
    end

    if !isnothing(country)
        @assert typeof(country) == String
        filtered = filtered[filtered.country.==country, :]
    end

    filtered = filtered[:, [:id, :name]]

    pretty_table(filtered, columns_width=[0, 100],
        alignment=[:l, :l, :r],
        tf=tf_compact,
        crop=:horizontal)

    return
end

"""
    ipeadata(id)

Fetch series `id` in Ipeadata API. `id` can be a single string or a vector of strings.
"""
function ipeadata(id::String)

    # download the data
    d = HTTP.request("GET", base_URL() * "Metadados('$(id)')/Valores")
    jfile = String(copy(d.body))
    F = JSON.parse(jfile)

    # DataFrame
    T = length(F["value"])
    df = DataFrame("date" => Vector{Date}(undef, 0),
        id => Vector{Float64}(undef, 0))
    for t in 1:T
        dict_t = F["value"][t]
        sd = DataFrame("date" => Date(dict_t["VALDATA"][1:10]),
            id => dict_t["VALVALOR"])
        df = vcat(df, sd)
    end

    return df
end

function ipeadata(id_vec::Vector{String})
    df = DataFrame("date" => Vector{Date}(undef, 0))
    for id in id_vec
        gh = ipeadata(id)
        df = outerjoin(df, gh, on=:date)
    end
    sort!(df, :date)
    df = coalesce.(df, NaN)
    return df
end