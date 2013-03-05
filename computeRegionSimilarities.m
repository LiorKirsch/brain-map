function regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination)
% create a least square problem and solve it.

    m = size(correlationMatrix,1);
    n = size(correlationMatrix,2);
    [A,b] = buildLeastSquareProblem(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination);
    w = lsqnonneg(A,b); %this function returns non-negative weights (w)
    regionSimilarity = reshape(w,m,n);
    
end