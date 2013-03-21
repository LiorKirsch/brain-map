function regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination, lambda)
% create a least square problem and solve it.

    m = size(correlationMatrix,1);
    n = size(correlationMatrix,2);
    [A,b] = buildLeastSquareProblem(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination, lambda);
    w = lsqnonneg(A,b); %this function returns non-negative weights (w)
    regionSimilarity = reshape(w,m,n);
    
end