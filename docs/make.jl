push!(LOAD_PATH,"../src/")
using Documenter, classification, Datasets
# Documenter.makedocs(
#     root = ".",
#     docs = "docs",
#     clean = true,
#     doctest = true,
#     repo = "",
#     sitename = "DDL Documentation",
#     expandfirst = [],
#     pages = [
#         "Index" => "index.md",
#     ]

# )

Documenter.makedocs(
    sitename = "DDL Documentation",
    repo = "https://github.com/SubhadityaMukherjee/DDL.jl"
)