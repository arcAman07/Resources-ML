using Pkg

Pkg.add("Images")

Pkg.add("FileIO")
Pkg.add("ImageMagick")
Pkg.add("ImageIO")
Pkg.add("TestImages")

using Images, FileIO, TestImages

img_path = "C:/Users/amans/Downloads/weeknd.jpg"

image = load(img_path)

# To save an image, you can just use save(img_path, img), where save is also provided by FileIO.

size(image)

img = testimage("mandrill")

img1 = testimage("mandrill") # 512*512 RGB image
img2 = testimage("blobs") # 254*256 Gray image
mosaicview(img1, img2; nrow=1)

img = testimage("mri-stack") # 226×186×27 Gray image
mosaicview(img; fillvalue=0.5, npad=2, ncol=7, rowmajor=true)

Pkg.add("Dates")
using Dates

today()

versioninfo()

Pkg.status()

img = rand(4, 3)

# generate an image that starts black in the upper left
# and gets bright in the lower right
img = Array(reshape(range(0,stop=1,length=10^4), 100, 100))
# make a copy
img_c = img[51:70, 21:70] # red
# make a view
img_v = @view img[16:35, 41:90] # blue

fill!(img_c, 1) # red region in original doesn't change
fill!(img_v, 0) # blue

Pkg.add("Unitful")
Pkg.add("AxisArrays")

using Unitful, AxisArrays
using Unitful: mm, s

img = AxisArray(rand(256, 256, 6, 50), (:x, :y, :z, :time), (0.4mm, 0.4mm, 1mm, 2s))

Gray(0.0) # black
Gray(1.0) # white
RGB(1.0, 0.0, 0.0) # red
RGB(0.0, 1.0, 0.0) # green
RGB(0.0, 0.0, 1.0) # blue

img_gray = rand(Gray, 2, 2)

img_rgb = rand(RGB, 2, 2)

img_lab = rand(Lab, 2, 2)

RGB.(img_gray) # Gray => RGB

Gray.(img_rgb) # RGB => Gray

# the ImageMetadata package (incorporated into Images itself) allows you to "tag" images with custom metadata

# the IndirectArrays package supports indexed (colormap) images

# the MappedArrays package allows you to represent lazy value-transformations, facilitating work with images that may be too large to store in memory at once

# ImageTransformations allows you to encode rotations, shears, deformations, etc., either eagerly or lazily

# It's recommended to use Gray instead of the Number type in JuliaImages since it indicates that the array of numbers is best interpreted as a grayscale image. 
# For example, it triggers Atom/Juno and Jupyter to display the array as an image instead of a matrix of numbers. 
# There's no performance overhead for using Gray over Number.

# Conversions between different Colorants are straightforward:

RGB.(img_gray)

Gray.(img_rgb)

# Sometimes, to work with other packages, you'll need to convert a m \times nm×n RGB image to m \times n \times 3m×n×3 numeric array and vice versa. 
# The functions channelview and colorview are designed for this purpose. For example:

img_CHW = channelview(img_rgb)

img_HWC = permutedims(img_CHW, (2, 3, 1)) # 2 * 2 * 3

img_CHW = permutedims(img_HWC, (3, 1, 2)) # 3 * 2 * 2

img_rgb = colorview(RGB, img_CHW) # 2 * 2

# Don't overuse channelview because it loses the colorant information by converting an image to a raw numeric array.

# It's very likely that users from other languages will have the tendency to channelview every image they're going to process. 

# Unfamiliarity of the pixel concept provided by JuliaImages doesn't necessarily mean it's bad.

img_num = rand(4, 4)

img_gray_copy = Gray.(img_num)

img_num_copy = Float64.(img_gray_copy)

img_gray_view = colorview(Gray, img_num) 

img_num_view = channelview(img_gray_view)

img_n0f8 = rand(N0f8, 2, 2)

float.(img_n0f8)

img_n0f8_raw = rawview(img_n0f8)

float.(img_n0f8_raw)

# Conversions between the storage type, i.e., the actual numeric type, 
# without changing the color type are supported by the following functions:

img = rand(Gray{N0f8}, 2, 2)

img_float32 = float32.(img)

img_n0f16 = n0f16.(img_float32)

# Although it's not recommended, but you can use rawview to get the underlying storage data and 
# convert it to UInt8 (or other types) if you insist.

img = rand(Gray{N0f8}, 2, 2)

img_float32 = float32.(img) # Gray{N0f8} => Gray{Float32}

# Constructors, conversions, and traits:

# Construction: use constructors of specialized packages, e.g., AxisArray, ImageMeta, etc.
# "Conversion": colorview, channelview, rawview, normedview, PermutedDimsArray, paddedviews
# Traits: pixelspacing, sdims, timeaxis, timedim, spacedirections
# Contrast/coloration:

# clamp01, clamp01nan, scaleminmax, colorsigned, scalesigned
# Algorithms:

# Reductions: maxfinite, maxabsfinite, minfinite, meanfinite, sad, ssd, integral_image, boxdiff, gaussian_pyramid
# Resizing and spatial transformations: restrict, imresize, warp
# Filtering: imfilter, imfilter!, imfilter_LoG, mapwindow, imROF, padarray
# Filtering kernels: Kernel. or KernelFactors., followed by ando[345], guassian2d, imaverage, imdog, imlaplacian, prewitt, sobel
# Exposure : build_histogram, adjust_histogram, imadjustintensity, imstretch, imcomplement, AdaptiveEqualization, GammaCorrection, cliphist
# Gradients: backdiffx, backdiffy, forwarddiffx, forwarddiffy, imgradients
# Edge detection: imedge, imgradients, thin_edges, magnitude, phase, magnitudephase, orientation, canny
# Corner detection: imcorner, harris, shi_tomasi, kitchen_rosenfeld, meancovs    , gammacovs, fastcorners
# Blob detection: blob_LoG, findlocalmaxima, findlocalminima
# Morphological operations: dilate, erode, closing, opening, tophat, bothat, morphogradient, morpholaplace, feature_transform, distance_transform
# Connected components: label_components, component_boxes, component_lengths, component_indices, component_subscripts, component_centroids
# Interpolation: bilinear_interpolation
# Test images and phantoms (see also TestImages.jl):

# shepp_logan

Pkg.add("ImageTransformations")
Pkg.add("PaddedViews")

Pkg.add("CoordinateTransformations")

Pkg.add("Rotations")

using ImageTransformations

img = testimage("mandrill")
img_small = imresize(img, ratio=1/8)
img_medium = imresize(img_small, size(img_small).*2)

size(img)

size(img_small)

size(img_medium)

using ImageTransformations, TestImages, CoordinateTransformations, Rotations

img = testimage("camera");

# define transformation
trfm = recenter(RotMatrix(pi/8), center(img));
imgw = warp(img, trfm)

using PaddedViews

a = collect(reshape(1:9, 3, 3))

PaddedView(-1, a, (4, 5))

img_n0f8 = rand(N0f8, 2, 2)

float.(img_n0f8)

img_n0f8_raw = rawview(img_n0f8)

float.(img_n0f8_raw)












