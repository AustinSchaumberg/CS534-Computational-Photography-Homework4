% Austin Schaumberg
% CS 534 | Fall 2016
% HW4-calcHWithRANSAC.m
function H = calcHWithRANSAC(p1, p2)
% Returns the homography that maps p2 to p1 under RANSAC.
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix

    assert(all(size(p1) == size(p2)));  % input matrices are of equal size
    assert(size(p1, 2) == 2);  % input matrices each have two columns
    assert(size(p1, 1) >= 4);  % input matrices each have at least 4 rows

    %------------- YOUR CODE STARTS HERE -----------------
    % 
    % The following code computes a homography matrix using all feature points
    % of p1 and p2. Modify it to compute a homography matrix using the inliers
    % of p1 and p2 as determined by RANSAC.
    %
    % Your implementation should use the helper function calcH in two
    % places - 1) finding the homography between four point-pairs within
    % the RANSAC loop, and 2) finding the homography between the inliers
    % after the RANSAC loop.

    n = size(p1, 1);
    numIter = 100;
    maxDist = 3;
    maxVal = 0;

    % RANSAC, 100 tries
    for RANSAC = 1 : numIter
        
        i = 1;
        origInlinerP1 = [];
        origInlinerP2 = [];
        % inds is a vector of 4 random unique integers in [1, n]
        inds = randperm(n, 4);
        
        H = calcH(p1(inds, :), p2(inds,:));
        
        % Test homography accuracy against all feature pairs
        for j = 1:size(p2,1)
            % Calculate the value of q (see text/slides for refrence)
            b = [ p2(j,:)'; 1 ];
            % q and b are 3 x n matrices and H is a 3 x 3 matrix
            q = H * b;
            q = [ q(1)./q(3) ; q(2)./q(3) ];
            % q and p1(j,:)' are n x 3 matrices and dist is a 1 x n matrix
            dist = sqrt( sum( (q - p1(j,:)').^2) );
            
            % Collect feature pairs which are identified as
            % being consistent with the homography.
            if dist < maxDist
                origInlinerP1(i,:) = p1(j,:);
                origInlinerP2(i,:) = p2(j,:);
                i = i +1;
            end
        end
        
        % Test if new inliers are 'better' than previous ones
        if size(origInlinerP1,1) > maxVal
            maxVal = size(origInlinerP1,1);
            finalSetOfInlinersP1 = origInlinerP1;
            finalSetOfInlinersP2 = origInlinerP2;
        end
    end
 
    % Calculate the final homography using the final set of inliers
    H = calcH(finalSetOfInlinersP1, finalSetOfInlinersP2);
    %------------- YOUR CODE ENDS HERE -----------------
end

% The following function has been implemented for you.
% DO NOT MODIFY THE FOLLOWING FUNCTION
function H = calcH(p1, p2)
% Returns the homography that maps p2 to p1 in the least squares sense
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix

assert(all(size(p1) == size(p2)));
assert(size(p1, 2) == 2);

n = size(p1, 1);
if n < 4
    error('Not enough points');
end
H = zeros(3, 3);  % Homography matrix to be returned

A = zeros(n*3,9);
b = zeros(n*3,1);
for i=1:n
    A(3*(i-1)+1,1:3) = [p2(i,:),1];
    A(3*(i-1)+2,4:6) = [p2(i,:),1];
    A(3*(i-1)+3,7:9) = [p2(i,:),1];
    b(3*(i-1)+1:3*(i-1)+3) = [p1(i,:),1];
end
x = (A\b)';
H = [x(1:3); x(4:6); x(7:9)];

end
