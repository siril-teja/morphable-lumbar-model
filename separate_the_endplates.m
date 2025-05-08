% Read the STL file
TR = stlread('Female_0.stl');
vertices = TR.Points;
faces = TR.ConnectivityList;

% Visualize the loaded STL to check the content
figure;
trisurf(TR, 'FaceColor', 'cyan', 'EdgeColor', 'none');
axis equal;
camlight;
lighting gouraud;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% Initialize visited array
visited = false(size(vertices, 1), 1);
num_vertebrae = 0;
regions = {};

% DFS to find connected components
for i = 1:size(vertices, 1)
    if ~visited(i)
        num_vertebrae = num_vertebrae + 1;
        stack = i;
        current_region = [];
        
        % Depth-first search
        while ~isempty(stack)
            v = stack(end);
            stack(end) = [];
            
            if ~visited(v)
                visited(v) = true;
                current_region = [current_region; v];
                
                % Find adjacent faces and add vertices to stack
                adj_faces = faces(any(faces == v, 2), :);
                for f = 1:size(adj_faces, 1)
                    stack = union(stack, adj_faces(f, :));
                end
            end
        end
        
        % Store the region
        regions{end+1} = current_region;
    end
end

% Reindex faces to make sure they refer to the subset of vertices
for i = 1:num_vertebrae
    % Get the indices of vertices in the current region
    region_vertices = vertices(regions{i}, :);
    
    % Get the faces that correspond to the current region
    region_faces = faces(ismember(faces(:, 1), regions{i}), :);
    region_faces = region_faces(:, 1:3); % Ensure we only take the first 3 columns
    
    % Reindex the faces so that they refer to the new vertex list
    [~, ~, new_face_indices] = intersect(region_faces, region_vertices, 'rows');
    region_faces = new_face_indices;
    
    % Ensure the faces are within the valid index range
    if any(region_faces(:) > length(region_vertices))
        error('Face indices exceed the number of vertices.');
    end
    
    % Create the triangulation object for the current region
    TR_region = triangulation(region_faces, region_vertices);
    
    % Visualize the region (vertebra)
    figure;
    trisurf(TR_region, 'FaceColor', 'cyan', 'EdgeColor', 'none');
    axis equal;
    camlight;
    lighting gouraud;
    title(['Vertebra ' num2str(i)]);
end
