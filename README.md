# Multispectral Imaging in MATLAB
![img10_1](https://github.com/user-attachments/assets/75b7ed08-37d4-4131-8fbf-1adc85feed66)

## Introduction
This project focuses on implementing and visualizing multispectral imaging techniques using MATLAB. Multispectral imaging captures information from multiple wavelengths across the electromagnetic spectrum, unlike traditional RGB images that capture only three bands. These images can be used for applications in agriculture, medical imaging, and remote sensing, among other fields.

## Project Overview
This project uses MATLAB to load, process, and visualize multispectral images from different bands. It implements techniques for image filtering, contrast enhancement, and visual inspection of various bands, allowing users to observe features like vegetation health, water presence, and more.

## Files
- **`Multispectral_imaging.m`**: Contains the MATLAB code to read and process multispectral images, applying various techniques like image filtering and enhancement.
- **`sample_image.tif`** (not provided): A sample multispectral image used in the script. You need to provide your own image.

## Prerequisites
- MATLAB installed with the Image Processing Toolbox.
- A multispectral image file (preferably in `.tif` format with multiple bands).

## How to Run the Code
1. **Load the Image**: The path to the multispectral image is specified, indicating the file name (`'sample_image.tif'`). Update this in the code with the actual path to your image.
2. **Read the Image**: The MATLAB `imread` function reads the multispectral image, which is stored in the variable `multispectral_image`.

### Example Code
```matlab
% Step 1: Specify the path to the multispectral image
file_path = 'path_to_your_image.tif';

% Step 2: Read the multispectral image
multispectral_image = imread(file_path);

% Step 3: Visualize each band separately
for i = 1:size(multispectral_image, 3)
    figure;
    imagesc(multispectral_image(:, :, i));
    colormap(jet);
    colorbar;
    title(['Band ', num2str(i)]);
end

% Step 4: Apply a median filter to remove noise
filtered_image = medfilt2(multispectral_image(:, :, 1));

% Step 5: Contrast enhancement using histogram equalization
equalized_image = histeq(multispectral_image(:, :, 1));

% Step 6: Display filtered and equalized images
figure;
subplot(1, 2, 1);
imshow(filtered_image);
title('Filtered Image');
subplot(1, 2, 2);
imshow(equalized_image);
title('Equalized Image');
