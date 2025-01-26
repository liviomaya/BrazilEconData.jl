module BrazilEconData

export ipeadata_dictionaries
export ipeadata_print
export ipeadata
export bcb
export ibge

include("dependencies.jl")
include("ipeadata.jl")
include("bcb.jl")
include("ibge.jl")

end
