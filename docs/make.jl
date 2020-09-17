push!(LOAD_PATH,"../src/")
using Documenter, classification, Datasets

Documenter.makedocs(
    sitename = "DDL Documentation",
    repo = "https://github.com/SubhadityaMukherjee/DDL.jl"
)