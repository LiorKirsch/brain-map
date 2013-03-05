cross species mapping
=========

[A,b] = buildLeastSquareProblem(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination)
> inputs the two adajacencyMatrices between areas, and a correlation matrix between the expression of each two areas.
> It then generates the matrices A and b that are needed to solve the least squares problem.

regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination)
> compute the region similarity between regions. 
> This function first builds the least sqaure problems (using buildLeastSquareProblem) and then obtains the solution.


