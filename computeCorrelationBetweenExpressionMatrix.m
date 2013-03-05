function [cleanCorrelationMatrix, rowsIndices, columnIndices] = computeCorrelationBetweenExpressionMatrix(expressionMatrix1, expressionMatrix2, regionLabels)

    assert(all(size(expressionMatrix1) == size(expressionMatrix2)));
    assert(all(size(expressionMatrix1,2) == length(regionLabels)));

    correlationBetweenRegions = corr(expressionMatrix1, expressionMatrix2);
    %correlationBetweenRegions = corr(expressionMatrix1, expressionMatrix2, 'type', 'Spearman');

    [cleanCorrelationMatrix, cleanLabelsRows, cleanLabelsColumns, rowsIndices, columnIndices] = removeNaNRowsAndColumn(correlationBetweenRegions, regionLabels);
    %imagesc(cleanCorrelationMatrix); colorbar;
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