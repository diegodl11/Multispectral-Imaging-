% Clear workspace and close all figures

close all;
clc;

% Specify the path to the multispectral image
imagePath = 'img12.tif'; % Replace with the actual file path

% Read the multispectral image using the imread function
multispectralImage = imread(imagePath);

% Define colormaps for each band
% I create different colormaps because each band is taken 
% In one differente frequence range. So, I put the main color
% (the first one) according to the frequency range the photo is taken
% I will explain in the slides what is representing each band and this
% will make sense. Also I'll explain here what each color does.
bandColormaps = {
    [
        linspace(1,1,256)', linspace(0,1,256)', zeros(256,1);  % Red low reflexion (plants and water) 
        zeros(256,1), linspace(1,1,256)', linspace(0,1,256)';  % Green medioum reflexion (swamp for example)
        linspace(0,1,256)', zeros(256,1), linspace(1,1,256)'  % Blue high reflexion (dessert, snow, clouds) when is purple, is very high
    ];
    [
        zeros(256,1), linspace(1,1,256)', linspace(0,1,256)';  % Green low reflexion (plants and water)
        linspace(1,1,256)', linspace(0,1,256)', zeros(256,1);  % Red medium reflexion (swamp)
        linspace(0,1,256)', zeros(256,1), linspace(1,1,256)'  % Blue high reflexion (dessert, snow, clouds) when is purple, is very high
    ];
    [
        linspace(0,1,256)', zeros(256,1), linspace(1,1,256)';  % Blue low reflexion  if there is water, purple color will appear
                                                                %if there is blue, there is vegetation                                                     
        linspace(1,1,256)', linspace(0,1,256)', zeros(256,1);  % Red medium reflexion (wet surface) yellow for high-medium reflexion
        zeros(256,1), linspace(1,1,256)', linspace(0,1,256)'  % Green very high reflexion. light green (near blue) is very very high reflexion
    ]
};

% Get the dimensions of the image for the image filtering
[rows, cols, bands] = size(multispectralImage);

% Initialize filtered image
% This function creates a matrix filled with zeros. 
% In this case, it's creating a matrix of the same size as multispectralImage 
% but filled with zeros.
filteredImage = zeros(size(multispectralImage)); 

% Initialize an empty cell array for storing images and titles

imageCell = cell(8,1);

% Iterate through each band
for band = 1:bands-1
    
  

    % Create a false-color composite for the current band
    %The choice of different color bands for a multispectral image in a false-color 
    %composite is made with the aim of highlighting specific features or 
    %enhancing the information contained in the image.

    %1. save the false-color composite of normal image
    normalImage = multispectralImage(:, :, band);
    % Display the false-color composite
    figure;
    imagesc(normalImage);
    %each band has one colorComposite
    colormap(bandColormaps{band});
    colorbar;
    title(['Normal  Multispectral Image (Band ', num2str(band), ')']);
    xlabel('Column Index');
    ylabel('Row Index');

    % Guardar la figura en un archivo temporal (formato PNG)
    temp_filename = 'temp_figure.png';
    print('-dpng', temp_filename);
    
    %we should close the window to make the matlab clear
    close all;
    clc;

    % Leer la imagen desde el archivo temporal
    normalImage = imread(temp_filename);

    %NOTE: why am I not taking the image directly without showing
    %it if I'm going to close the window? Because, there is no way
    %to take the colors of all of the colormap with only imwrite


    %-------------IMAGE FILTERING------------

    % Apply a median filter to each band individually
    %The median filter is a nonlinear filtering technique 
    % that replaces each pixel value in the image with the
    % median value in its neighborhood. It is commonly 
    % used for noise reduction and smoothing.
    filteredImage(:, :, band) = medfilt2(multispectralImage(:, :, band));

    % Create a false-color composite for the current band
    filteredBand = filteredImage(:, :, band);
    % Display the false-color composite
    figure;
    imagesc(filteredBand);
    %each band has one colorComposite
    colormap(bandColormaps{band});
    colorbar;
    title(['Filtered  Multispectral Image (Band ', num2str(band), ')']);
    xlabel('Column Index');
    ylabel('Row Index');

    % Guardar la figura en un archivo temporal (formato PNG)
    temp_filename = 'temp_figure.png';
    print('-dpng', temp_filename);
    
    %we should close the window to make the matlab clear
    close all;
    clc;

    % Leer la imagen desde el archivo temporal
    filteredBand = imread(temp_filename);


    %-----------HISTOGRAM EQUALIZATION----------------

    %performing histogram equalization on one specific band of a multispectral image
    %Histogram equalization enhances the contrast of an 
    %image by redistributing the intensity values of the pixels
    equalizedBand = histeq(multispectralImage(:, :, band));

    %3. save the false-color compositethe equalized histogram image
    equalizedImage = equalizedBand(:, :, 1);
     % Display the false-color composite
    figure;
    imagesc(equalizedImage);
    %each band has one colorComposite
    colormap(bandColormaps{band});
    colorbar;
    title(['equalized histogram  Multispectral Image (Band ', num2str(band), ')']);
    xlabel('Column Index');
    ylabel('Row Index');

    % Guardar la figura en un archivo temporal (formato PNG)
    temp_filename = 'temp_figure.png';
    print('-dpng', temp_filename);
    
    %we should close the window to make the matlab clear
    close all;
    clc;

    % Leer la imagen desde el archivo temporal
    equalizedImage = imread(temp_filename);

    %----------IMAGE SEGMENTATION--------------

    % Perform image segmentation 
    % Apply a threshold for segmentation
    %This function calculates a global image threshold using 
    % Otsu's method. It assumes that the input image (or band, in this case) 
    % is grayscale. The threshold calculated by graythresh is the value that minimizes 
    % the intraclass variance of the binarized image.
    % NOTE: I didn't turn the band into the greyScale because it's already in it,
    % the bands ar in black and white.
    threshold = graythresh(multispectralImage(:, :, band));
    %his function converts a grayscale or intensity image (or a specific band of a multispectral image) 
    % into a binary image using a specified threshold. Pixels with values below the threshold are set 
    % to 0 (black), and pixels with values equal to or above the threshold are set to 1 (white).
    binaryImage = imbinarize(multispectralImage(:, :, band), threshold);
    %In the context of image segmentation, this step is commonly used to create a binary mask that highlights 
    % regions of interest based on intensity values in a specific band of a multispectral image

    % Label connected regions in the binary image
    %This function assigns a unique label to each connected component in the binary image. 
    % Connected components are regions of adjacent pixels with the same value (1 in this case)
    labeledImage = bwlabel(binaryImage);
    %Each connected component is assigned a unique label, allowing you to distinguish and analyze 
    % different regions or objects in the binary image independently

    %4. show the segmented image
    segmentedImage = labeledImage(:, :, 1);
    % Display the false-color composite
    figure;
    imagesc(segmentedImage);
    %I didn't did the false color composite because the segmentation
    %already divide the image in regions and give that regions a color.
    title(['segmented  Multispectral Image (Band ', num2str(band), ')']);
    xlabel('Column Index');
    ylabel('Row Index');

    % Guardar la figura en un archivo temporal (formato PNG)
    temp_filename = 'temp_figure.png';
    print('-dpng', temp_filename);
    
    %we should close the window to make the matlab clear
    close all;
    clc;

    % Leer la imagen desde el archivo temporal
    segmentedImage = imread(temp_filename);


    %Now, I'm going to search the max size of images to be able to use tha
    %cat function. The cat funtion, combine images to get a entire image of
    %4 images
    maxHeight = max([size(normalImage, 1), size(filteredBand, 1), size(equalizedImage, 1), size(segmentedImage, 1)]);
    maxWidth = max([size(normalImage, 2), size(filteredBand, 2), size(equalizedImage, 2), size(segmentedImage, 2)]);
    
    % Define el tamaño deseado
    desiredSize = [maxHeight, maxWidth];
    
    %Now the program will resize the images to the same size
    normalImage = imresize(normalImage, desiredSize);
    filteredBand = imresize(filteredBand, desiredSize);
    equalizedImage = imresize(equalizedImage, desiredSize);
    segmentedImage = imresize(segmentedImage, desiredSize);
  
    
    % Display and save the combined image with titles
    % Now the image will be combined in one imae concatenating cat
    % functions
    combinedImage = cat(2, cat(1, normalImage, filteredBand), cat(1, equalizedImage, segmentedImage));
    imwrite(combinedImage, ['combined_image', num2str(band), '.png']);
end