function [RESIZED] = MakeMovieVectorFramesSameSize(MOVIE_VECTOR,options)

%MAKEMOVIEVECTORFRAMESSAMESIZE Makes a movie vector have the same size
%
%   [RESIZED] = MAKEMOVIEVECTORFRAMESSAMESIZE(MOVIE_VECTOR) makes all the
%   frames in the MOVIE_VECTOR the same size so that they can be written to
%   a movie.
%
%   [...] =
%   MAKEMOVIEVECTORFRAMESSAMESIZE(MOVIE_VECTOR,option,'optionValue') does
%   as above but uses the name/value pair to specify options.  Some
%   allowable options include:
%
%       'method'    | 'fill' = padding a small frames with white pixels to
%                              make it the same size as the largest frame
%                              (default option)
%                      'shrink' = cut frames down to the smallest frame
%
%   Example usage:
%
%       t = linspace(0,10,15);
%       for k=1:length(t)
%           tk = t(k);
%           x = cos(tk);
%           y = sin(tk);
%           z = tk;
% 
%           plot3(x,y,z,'ro')
%           axis([-5 5 -5 5 0 10])    
% 
%           movieVector = getframe;
%       end
% 
%       movieVector = MakeMovieVectorFramesSameSize(movieVector,'method','shrink');
%
%INPUT:     -MOVIE_VECTOR:  Array of frames obtained using GETFRAME
%
%OUTPUT:    -RESIZED:       Array of frames with all the same size
%
%See also getframe
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/09/19: Created
%11/19/24: Updated documentation.  Changed to use arguments

%----------------------OBTAIN USER PREFERENCES-----------------------------
arguments
    MOVIE_VECTOR    (:,:) struct;
    options.method  (1,1) string = "fill";
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Find the smallest and largest dimension
for k=1:length(MOVIE_VECTOR)
    frame = MOVIE_VECTOR(k);
    cdata = frame.cdata;
    
    [rows,cols,depth] = size(cdata);
    
    if(k==1)
        minRows = rows;
        minCols = cols;
        minDepth = depth;
        
        maxRows = rows;
        maxCols = cols;
        maxDepth = depth;
    else
        if(rows < minRows)
            minRows = rows;
        end
        
        if(cols < minCols)
            minCols = cols;
        end
        
        if(depth < minDepth)
            minDepth = depth;
        end
        
        if(rows > maxRows)
            maxRows = rows;
        end
        
        if(cols > maxCols)
            maxCols = cols;
        end
        
        if(depth > maxDepth)
            maxDepth = depth;
        end
    end
end

%Make each frame the same size
for k=1:length(MOVIE_VECTOR)
    frame = MOVIE_VECTOR(k);
    cdata = frame.cdata;
    
    [rows,cols,depth] = size(cdata);
    
    if(strcmp(options.method,"fill"))
        cdataResized = zeros(maxRows, maxCols, maxDepth);
        cdataResized = uint8(cdataResized);
        cdataResized(1:rows, 1:cols, 1:depth) = cdata(1:rows, 1:cols, 1:depth);
        
    elseif(strcmp(options.method,"shrink"))
        cdataResized = cdata(1:minRows, 1:minCols, 1:depth);
        
    else
        error('Unsupported options.method')
    end
    
    frameResized = frame;
    frameResized.cdata = cdataResized;
    RESIZED(k) = frameResized;
end
