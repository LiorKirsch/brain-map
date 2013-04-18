function [correlationBetweenRegions, rowsIndices, columnIndices] = computeCorrelationBetweenExpressionMatrix(expressionMatrix1, expressionMatrix2, regionLabels)

    assert(all(size(expressionMatrix1) == size(expressionMatrix2)));
    assert(all(size(expressionMatrix1,2) == length(regionLabels)));
    
    [cleanExpressionMatrix1, cleanLabelsRows, rowsIndices] = removeNaNColumn(expressionMatrix1, regionLabels);
    [cleanExpressionMatrix2, cleanLabelsColumns, columnIndices] = removeNaNColumn(expressionMatrix2, regionLabels);
    
    %normalize the expression matrices using to zero mean and varience
    cleanExpressionMatrix1 = normalizeRows(cleanExpressionMatrix1);
    cleanExpressionMatrix2 = normalizeRows(cleanExpressionMatrix2);
    
    correlationBetweenRegions = corr(cleanExpressionMatrix1, cleanExpressionMatrix2);
    %correlationBetweenRegions = corr(expressionMatrix1, expressionMatrix2, 'type', 'Spearman');

    %[cleanCorrelationMatrix, cleanLabelsRows, cleanLabelsColumns, rowsIndices, columnIndices] = removeNaNRowsAndColumn(correlationBetweenRegions, regionLabels);
    imagesc(correlationBetweenRegions); colorbar;
end

% close all
% correlationBetweenRegions = corr(cleanExpressionMatrix1, cleanExpressionMatrix2);
% subplot(1,2,1)
% imagesc(correlationBetweenRegions); colorbar;
% subplot(1,2,2)
% cleanExpressionMatrix1 = normalizeRows(cleanExpressionMatrix1);
% cleanExpressionMatrix2 = normalizeRows(cleanExpressionMatrix2);
% correlationBetweenRegions = corr(cleanExpressionMatrix1, cleanExpressionMatrix2);
% imagesc(correlationBetweenRegions); colorbar;


function normalizedMatrix = normalizeRows(matrix)
    numberOfColumns = size(matrix,2);
    meanMatrix = repmat( mean(matrix,2), 1, numberOfColumns);
    stdMatrix = repmat( std(matrix,0,2), 1, numberOfColumns);
    normalizedMatrix = (matrix - meanMatrix) ./stdMatrix ;
end

function [cleanCorrelationMatrix, cleanLabelsRows, cleanLabelsColumns, rowsIndices, columnIndices] = removeNaNRowsAndColumn(inputMatrix, matrixLabels)
    
    nanElements = isnan(inputMatrix);
    rowsToRemove = all(nanElements,2);
    columnsToRemove = all(nanElements);
    
    rowsIndices = ~rowsToRemove;
    columnIndices = ~columnsToRemove;
    cleanCorrelationMatrix = inputMatrix(rowsIndices, columnIndices);
    cleanLabelsRows = matrixLabels(rowsIndices,:);
    cleanLabelsColumns = matrixLabels(columnIndices,:);
end


function [cleanMatrix, cleanLabelsColumns, columnIndices] = removeNaNColumn(inputMatrix, matrixLabels)
    
    nanElements = isnan(inputMatrix);
    
    columnsToRemove = all(nanElements,1);
    
    columnIndices = ~columnsToRemove;
    cleanMatrix = inputMatrix(:, columnIndices);
    cleanLabelsColumns = matrixLabels(columnIndices,:);
end