# DDL.jl

- This package aims to provide utilities for working with any kind of data for Machine Learning.
- The main objective is to have a data loader of sorts which works with Flux.jl for any data
- This package also provides easy ways of downloading standard datasets from Computer Vision, Natural Language processing etc

> Note: I will be making a proper documentation and this is temporary

## Datasets available

- "imagenette320", "flowers", "pets", "imagenette", "yahoo", "yelp", "ucf", "kinetics700", "caltech101", "birds", "food", "imagenette160", "kinetics400", "camvid", "hmbd", "cifar100", "wmt", "cifar10", "wikitext2", "imagewoof160", "mnist", "imagewoof320", "dbpedia", "pascal", "amazon", "imdb", "kinetics600", "wikitext103", "cars", "sogou", "p-yelp", "imagewoof", "ag", "p-amazon"

## Modules

### downloader


downloader(url::String, dest::String, fname::String)
    
This function takes a url and a destination and downloads the file there with a name specified. <br>
    url: The url to be downloaded. <br>
    dest: Path. <br>
    fname: File name. <br>
    ```julia
    downloader("http://www.julialang.org/", "/tmp/","index.html")
    ```

### get_data


get_data(name::String, path::String)

Main function to download a standard dataset.
Takes input as name from the above list, the destination and a boolean to check if the user wants to extract the data. 
The filename is inferred from the destination and the url.
If not found, the list of available datasets is returned.

```julia
get_data("mnist", "/tmp/", 1)
```


### getext

```
getext(st::String)
    
Helper function to get the extension of the datasets. 
Takes into account patterns like .tar, .tar.gz , .zip etc..
```

