module classification

using Markdown
using InteractiveUtils
using CSV
using DataFrames
export get_img_paths, load_classes, labelFromPattern, examplelabeller, load_train_imgs
# MAIN FUNCTIONS

"""
Get all images in folder
"""
function get_img_paths(data_dir,extra_format = "")
    img_path = []
    for i in readdir(data_dir)
        if split(i, ".")[end] == "jpg" || split(i, ".")[end] == "png" || split(i, ".")[end] == extra_format
            push!(img_path, joinpath(data_dir, i))
        end
    end
    img_path
end


"""
- Identify the number of classes in the data. Return an array with all image paths and class labels
- Does not actually load the images. Just returns paths
- Assuming heirarchy of classes to be:
    - Main Folder
        - class1
            -img1
            -img2...
        - class2
            -img1
            -img2...
"""
function from_folder(data_dir)
    classes = readdir(main_path)
    @info length(classes), classes
    total_files = sum([length(readdir(main_path*classes[x])) for x in 1:length(classes)] )
    @info "Total images: $total_files"
    labels, paths = Array{String}(undef, total_files), Array{String}(undef, total_files)
    current_index = 1
    for path in classes
        current_path = readdir(main_path*path)
        current_length = length(current_path)
        labels[current_index:current_length+current_index-1] .= path 
        # @info paths[current_index:current_length]
        paths[current_index:current_length+current_index-1] = main_path*path.*current_path
        current_index += current_length
    end
    labels, paths
end

"""
- Read paths from a csv file along with labels given path column name and label column name
- Further can be passed into labellers and encoders
- Just a convinence function really
"""
function from_csv(fname,pathcol, namecol, header = true,delim = ",", ignore = [])
        df = CSV.File(fname, delim = delim, header = header) |> DataFrame
        return df.namecol , df.pathcol
end

"""
- Takes paths generated from load_classes as input
- Takes a function defining a custom label
- eg: labeller(x) = split(x, "/")[-1]
- Returns labels based on function specified
"""
function labelFromPattern(paths, labeller)
    labeller.(paths)
end

"""
- A function to show a custom labeller function as an example
- This splits the path based on "/" and returns the lower case of the last element
"""
examplelabeller(x) = lowercase(split(x,"/")[end-1])

"""
- Input path -> Read an image -> Convert to array -> Resize to given dimensions -> Convert to float
"""
loadim(path, dims = (128, 128)) = float.(permutedims(channelview(imresize(load(path), dims...)), (2, 3, 1)))

"""
- Return a label encoded vector from 1..number of unique vals
- Also returns a copy of the labels for later use, use as encoded, _ if you do not care about re encoding it again
"""
function encoder(arr)
        uniquevals = unique(arr)
        hot = Dict(uniquevals[x] =>x for x in 1:length(uniquevals))
        @info hot
        return replace(arr, hot...) , reverse.(hot)
end

"""
- Load all images
- Resize them to given size
- one hot encode labels
"""
function load_train_imgs(labels, train_img_paths, dims = (128,128))
    train_imgs = zeros()
    imgs_loaded = 0
    Threads.@spawn for i in train_img_paths
        push!(train_imgs, loadim(i, dims...))
        imgs_loaded += 1
        if imgs_loaded % 1000 == 0
            @info "$imgs_loaded Images have been loaded"
        end
    end
end



# EXAMPLE WORKFLOW

# load filepaths, images
main_path = "/home/subhaditya/Desktop/Datasets/asl-downloaded/"

labels, paths = from_folder(main_path)

# label it in whatever way you want
@info labelFromPattern(paths, examplelabeller)[1:3]

#one hot encoded labels (for classification)
labels,d = encoder(labels)










