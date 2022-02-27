using AbInitioTopo
using Documenter

DocMeta.setdocmeta!(AbInitioTopo, :DocTestSetup, :(using AbInitioTopo); recursive=true)

makedocs(;
    modules=[AbInitioTopo],
    authors="Omar Ashour",
    repo="https://github.com/oashour/AbInitioTopo.jl/blob/{commit}{path}#{line}",
    sitename="AbInitioTopo.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://oashour.github.io/AbInitioTopo.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/oashour/AbInitioTopo.jl",
    devbranch="main",
)
