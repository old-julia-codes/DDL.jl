module DDL

using HTTP, ZipFile, Tar

"""
This function takes a url and a destination and downloads the file there with a name specified.\n
url: The url to be downloaded
dest: Path
fname: File name
```julia
downloader("http://www.julialang.org/", "/tmp/","index.html")
```
"""

function downloader(url::String, dest::String, fname::String)
    HTTP.open(:GET, url) do http
        open(dest*fname, "w") do file
            write(file, http)
        end
    end
end


end
