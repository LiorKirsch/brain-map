cross species mapping
=========

[correlationBetweenRegions, rowsIndices, columnIndices] = computeCorrelationBetweenExpressionMatrix(expressionMatrix1, expressionMatrix2, regionLabels)
> Computes the region correlation between two subjects.
> 1. remove NaN columns.
> 2. normalize Rows to zero mean and unit varience.
> 3. compute pearson correlation between the areas of the two subjects.


[A,b] = buildLeastSquareProblem(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination)
> inputs the two adajacencyMatrices between areas, and a correlation matrix between the expression of each two areas.
> It then generates the matrices A and b that are needed to solve the least squares problem.

regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination)
> compute the region similarity between regions. 
> This function first builds the least sqaure problems (using buildLeastSquareProblem) and then obtains the solution.


buildA()
> this is the main function for the project
> 1. First, it loads the data and ontology.
> 2. it then thresholds the distance matrix, so it will become more sparse.
> 3. it then reduce the ontology to only the structure for which we have a expression data (mainly the leaves)
> 4. Then it computes the correlation between the areas (removes areas which have NaNs)

> 5. Next, we compute similarity based on the correlation and the adjacenyMatrix (computeRegionSimilarities).
> 6. And display our results.
