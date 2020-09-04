using Markdown
using InteractiveUtils
using Flux: onehot, onecold
# MAIN FUNCTIONS
function get_img_paths(data_dir,extra_format = "")
    """
    Get all images in folder
    """
    img_path = []
    for i in readdir(data_dir)
        if split(i, ".")[end] == "jpg" || split(i, ".")[end] == "png" || split(i, ".")[end] == extra_format
            push!(img_path, joinpath(data_dir, i))
        end
    end
    img_path
end

function load_classes(data_dir)
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

function labelFromPattern(paths, labeller)
    """
    - Takes paths generated from load_classes as input
    - Takes a function defining a custom label
    - eg: labeller(x) = split(x, "/")[-1]
    - Returns labels based on function specified
    """
    labeller.(paths)
end

"""
- A function to show a custom labeller function as an example
- This splits the path based on "/" and returns the lower case of the last element
"""
examplelabeller(x) = lowercase(split(x,"/")[end])

"""
- Input path -> Read an image -> Convert to array -> Resize to given dimensions -> Convert to float
"""
loadim(path, dims = (128, 128)) = float.(permutedims(channelview(imresize(load(path), dims...)), (2, 3, 1)))

function load_train_imgs(labels, train_img_paths, dims = (128,128))
    """
    - Load all images
    - Resize them to given size
    - one hot encode labels
    """
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

main_path = "/home/subhaditya/Desktop/Datasets/asl-downloaded/"
labels, paths = load_classes(main_path)
@info labelFromPattern(paths, examplelabeller)[1:3]
