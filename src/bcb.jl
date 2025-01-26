base_url(id::String) = "https://api.bcb.gov.br/dados/serie/bcdata.sgs.$id/dados?formato=json"

"""
    ipeadata(id)

Fetch series `id` in the Brazilian Central Bank (BCB) API. `id` can be a string/integer or a vector of strings/integers.
"""
function bcb(id::String)

    # download data
    d = HTTP.request("GET", base_url(id))
    jfile = String(copy(d.body))
    F = JSON.parse(jfile)

    # Data Frame
    sid = "s" * id
    df = DataFrame("date" => Vector{Date}(undef, 0),
        sid => Vector{Float64}(undef, 0))
    for f in F
        val = f["valor"]
        nval = (val == "") ? NaN : parse(Float64, f["valor"])
        sd = DataFrame(
            "date" => Date(f["data"], "dd/mm/yyyy"),
            sid => nval
        )
        df = vcat(df, sd)
    end

    # fixes
    df[isnothing.(df[:, 2]), 2] .= NaN
    df = coalesce.(df, NaN)

    return df
end
bcb(id::Int64) = bcb(string(id))

function bcb(id_vec::Vector{String})
    df = DataFrame("date" => Vector{Date}(undef, 0))
    for id in id_vec
        gh = bcb(id)
        df = outerjoin(df, gh, on=:date)
    end
    sort!(df, :date)
    df = coalesce.(df, NaN)
    return df
end
bcb(id_vec::Vector{Int64}) = bcb(string.(id_vec))