using Documenter
using DDL

Documenter.makedocs(
    root = ".",
    source = "docs",
    build = "build",
    clean = true,
    doctest = true,
    repo = "",
    sitename = "DDL Documentation",
    expandfirst = [],
    pages = [
        "Index" => "index.md",
    ]

)