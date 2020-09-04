### A Pluto.jl notebook ###
# v0.11.10

using Markdown
using InteractiveUtils

# ╔═╡ 758de036-ecdd-11ea-3bb5-010d259ca80d
begin
	using HTTP, Pipe
end

# ╔═╡ 95053d12-ecdd-11ea-3cb2-27f60fc2eb5a
md"""
    downloader(url::String, dest::String, fname::String)
    
This function takes a url and a destination and downloads the file there with a name specified.\n
    url: The url to be downloaded
    dest: Path
    fname: File name
    ```julia
    downloader("http://www.julialang.org/", "/tmp/","index.html")
    ```
"""

# ╔═╡ 94eb9e8e-ecdd-11ea-345c-a121388fc870
function downloader(url::String, dest::String, fname::String)
    HTTP.open(:GET, url) do http
        open(dest*fname, "w") do file
            write(file, http)
        end
    end
    return dest*fname
end

# ╔═╡ 94d3f504-ecdd-11ea-33a6-0787b8e47ccd
md"""
An attempt to have an easy to download list of useful datasets in Machine Learning.
This list was mostly taken from the python fastai documentation and modified for Julia. [Source](https://course.fast.ai/datasets).
Some others were added from the Pytorch documentation. [Source](https://pytorch.org/docs/stable/torchvision/datasets.html)
Please refer to the sources for citations if I missed anything.
"""

# ╔═╡ 94bcd022-ecdd-11ea-35e2-9f09d7ea0cd6
dataset_list = Dict(

    # Computer Vision
        "mnist" => "https://s3.amazonaws.com/fast-ai-imageclas/mnist_png.tgz",
        "cifar10" => "https://s3.amazonaws.com/fast-ai-imageclas/cifar10.tgz",
        "cifar100" => "https://s3.amazonaws.com/fast-ai-imageclas/cifar100.tgz",
        "birds" => "https://s3.amazonaws.com/fast-ai-imageclas/CUB_200_2011.tgz",
        "caltech101" => "https://s3.amazonaws.com/fast-ai-imageclas/caltech_101.tar.gz",
        "pets" => "https://s3.amazonaws.com/fast-ai-imageclas/oxford-iiit-pet.tgz",
        "flowers" => "https://s3.amazonaws.com/fast-ai-imageclas/oxford-102-flowers.tgz",
        "food" => "https://s3.amazonaws.com/fast-ai-imageclas/food-101.tgz",
        "cars" => "https://s3.amazonaws.com/fast-ai-imageclas/stanford-cars.tgz",
        "imagenette" => "https://s3.amazonaws.com/fast-ai-imageclas/imagenette.tgz",
        "imagenette320" => "https://s3.amazonaws.com/fast-ai-imageclas/imagenette-320.tgz",
        "imagenette160" => "https://s3.amazonaws.com/fast-ai-imageclas/imagenette-160.tgz",
        "imagewoof" => "https://s3.amazonaws.com/fast-ai-imageclas/imagewoof.tgz",
        "imagewoof320" => "https://s3.amazonaws.com/fast-ai-imageclas/imagewoof-320.tgz",
        "imagewoof160" => "https://s3.amazonaws.com/fast-ai-imageclas/imagewoof-160.tgz",
    # NLP
        "imdb"=>"https://s3.amazonaws.com/fast-ai-nlp/imdb.tgz",
        "wikitext103"=>"https://s3.amazonaws.com/fast-ai-nlp/wikitext-103.tgz",
        "wikitext2"=>"https://s3.amazonaws.com/fast-ai-nlp/wikitext-2.tgz",
        "wmt"=>"https://s3.amazonaws.com/fast-ai-nlp/giga-fren.tgz",
        "ag"=>"https://s3.amazonaws.com/fast-ai-nlp/ag_news_csv.tgz",
        "amazon"=>"https://s3.amazonaws.com/fast-ai-nlp/amazon_review_full_csv.tgz",
        "p-amazon"=>"https://s3.amazonaws.com/fast-ai-nlp/amazon_review_polarity_csv.tgz",
        "dbpedia"=>"https://s3.amazonaws.com/fast-ai-nlp/dbpedia_csv.tgz",
        "sogou"=>"https://s3.amazonaws.com/fast-ai-nlp/sogou_news_csv.tgz",
        "yahoo"=>"https://s3.amazonaws.com/fast-ai-nlp/yahoo_answers_csv.tgz",
        "yelp"=>"https://s3.amazonaws.com/fast-ai-nlp/yelp_review_full_csv.tgz",
        "p-yelp"=>"https://s3.amazonaws.com/fast-ai-nlp/yelp_review_polarity_csv.tgz",
    # Image Localization
        "camvid"=>"https://s3.amazonaws.com/fast-ai-imagelocal/camvid.tgz",
        "pascal"=>"https://s3.amazonaws.com/fast-ai-imagelocal/pascal-voc.tgz",
    # Video
        "hmbd"=>"http://serre-lab.clps.brown.edu/wp-content/uploads/2013/10/hmdb51_org.rar", #H. Kuehne, H. Jhuang, E. Garrote, T. Poggio, and T. Serre. HMDB: A Large Video Database for Human Motion Recognition. ICCV, 2011
        "ucf"=>"https://www.crcv.ucf.edu/data/UCF101/UCF101.rar", #Khurram Soomro, Amir Roshan Zamir and Mubarak Shah, UCF101: A Dataset of 101 Human Action Classes From Videos in The Wild., CRCV-TR-12-01, November, 2012.
        "kinetics700" => "https://storage.googleapis.com/deepmind-media/Datasets/kinetics700.tar.gz", #https://arxiv.org/abs/1907.06987
        "kinetics600" => "https://storage.googleapis.com/deepmind-media/Datasets/kinetics600.tar.gz", #https://arxiv.org/abs/1808.01340
        "kinetics400" => "https://storage.googleapis.com/deepmind-media/Datasets/kinetics400.tar.gz" #https://arxiv.org/abs/1705.06950
        
)

# ╔═╡ 94a5d226-ecdd-11ea-3824-570792db6b99
md"""
Helper function to return a list of existing datasets
"""

# ╔═╡ 948a3c48-ecdd-11ea-335b-55571ecea719
alldatasets()= keys(dataset_list)

# ╔═╡ 1a473232-ecde-11ea-1b7e-630ba6c299e9
md"""
getext(st::String)

Helper function to get the extension of the datasets. 
Takes into account patterns like .tar, .tar.gz , .zip etc..
"""

# ╔═╡ 1a3164d4-ecde-11ea-04e0-fd1c62efa36b
function getext(st::String)
	@pipe split(st, "/")[end] |> split(_, ".")[2:end] |> "."*join(_, ".")
end

# ╔═╡ 4ec7faae-ecee-11ea-3f38-03b3208a6a87
st = "https:Datasets/kinetics400.zip"

# ╔═╡ 5d0bbd76-ecee-11ea-3c9b-81ac883c4874
getext(st)

# ╔═╡ 2d9a6638-ecde-11ea-3c68-a187bba663c0
md"""
get_data(name::String, path::String)

Main function to download a standard dataset.
Takes input as name from the above list, the destination and a boolean to check if the user wants to extract the data. 
The filename is inferred from the destination and the url.

```julia
get_data("mnist", "/tmp/", 1)
```

If not found, the list of available datasets is returned.
"""

# ╔═╡ 2d81ca74-ecde-11ea-3f54-db31ba1d8bf6
function get_data(name::String, path::String)

    if name in alldatasets()
        @info "Downloading $name"
        url = dataset_list[name]
        finfile = downloader(url, path, name*getext(url))
        # finfile = "/tmp/mnist.tgz"
        @info "Done downloading"
    else
        @info "Please choose something from here"; @info alldatasets()
    end
end

# ╔═╡ 2d6a7e82-ecde-11ea-0b1d-a3be01d621dc


# ╔═╡ 1a199d9a-ecde-11ea-0dc3-8510834a38b9


# ╔═╡ 948a184e-ecdd-11ea-1ba2-f9e84085759a


# ╔═╡ 94606696-ecdd-11ea-23ec-cd16b1e4eab3


# ╔═╡ Cell order:
# ╠═758de036-ecdd-11ea-3bb5-010d259ca80d
# ╟─95053d12-ecdd-11ea-3cb2-27f60fc2eb5a
# ╠═94eb9e8e-ecdd-11ea-345c-a121388fc870
# ╟─94d3f504-ecdd-11ea-33a6-0787b8e47ccd
# ╠═94bcd022-ecdd-11ea-35e2-9f09d7ea0cd6
# ╠═94a5d226-ecdd-11ea-3824-570792db6b99
# ╠═948a3c48-ecdd-11ea-335b-55571ecea719
# ╟─1a473232-ecde-11ea-1b7e-630ba6c299e9
# ╠═1a3164d4-ecde-11ea-04e0-fd1c62efa36b
# ╠═4ec7faae-ecee-11ea-3f38-03b3208a6a87
# ╠═5d0bbd76-ecee-11ea-3c9b-81ac883c4874
# ╟─2d9a6638-ecde-11ea-3c68-a187bba663c0
# ╠═2d81ca74-ecde-11ea-3f54-db31ba1d8bf6
# ╠═2d6a7e82-ecde-11ea-0b1d-a3be01d621dc
# ╠═1a199d9a-ecde-11ea-0dc3-8510834a38b9
# ╠═948a184e-ecdd-11ea-1ba2-f9e84085759a
# ╠═94606696-ecdd-11ea-23ec-cd16b1e4eab3
