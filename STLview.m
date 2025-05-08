% % Read STL
% TR = stlread('Female_0.stl');  % Returns triangulation object in recent MATLAB versions
% 
% % Visualize
% trisurf(TR, ...
%     'FaceColor', 'cyan', ...
%     'EdgeColor', 'none');
% axis equal;
% camlight;
% lighting gouraud;

% Directory where the STL files are located
outdir = 'C:\Users\siril\Desktop\morphable-lumbar-model\output';

% Get list of all STL files in the directory
stlFiles = dir(fullfile(outdir, '*.stl'));

% Create a new figure
figure;
hold on;  % Keep the current plot active so we can overlay

% Define a colormap (optional)
colormap jet;  % You can use other colormaps, e.g., 'parula', 'hsv', 'cool', etc.
c = colormap;  % Get the current colormap

% Loop through all STL files and plot them with different colors
for k = 1:length(stlFiles)
    % Build the full file name
    filename = fullfile(outdir, stlFiles(k).name);
    
    % Read the STL file
    TR = stlread(filename);
    
    % Get a color from the colormap based on the current index
    color = c(mod(k-1, size(c, 1)) + 1, :);  % Ensure valid indexing within colormap
    
    % Plot the mesh with the color
    trisurf(TR, ...
        'FaceColor', color, ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.5);  % Adjust transparency if needed
end

% Set properties for better visualization
axis equal;
view(3);  % Set the view to 3D
camlight;
lighting gouraud;  % Make lighting smooth

% Optional: Adjust axis limits if necessary
xlim([-50 50]);  % Adjust limits based on the model's size
ylim([-50 50]);
zlim([0 50]);
hold off;  % Release the hold on the figure