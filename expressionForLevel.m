function expressionMatrixOfLevel = expressionForLevel(expressionMatrix,ontology, level)


    [allChilds, nodeLevel] = allChildNodes(ontology.dependencyMatrix);
    nodesInLevel = find( nodeLevel == level);
    
    expressionMatrixOfLevel = nan(size(expressionMatrix,1), length(nodesInLevel), size(expressionMatrix,3));
    i =1;
    for nodeIndex = nodesInLevel
        childOfCurrentNode = allChilds(nodeIndex, :);
        expressionMatrixOfLevel(:,i,:) = getMeanExpressionOfNodes(expressionMatrix, childOfCurrentNode);
        i = i+1;
    end

    structureLabels = ontology.structureLabels(nodesInLevel,:);
end


function matrix = removeNodeAndChilds(matrix, nodeIndex, ontology)
    [allChilds, ~] = allChildNodes(ontology.dependencyMatrix);
    childOfCurrentNode = allChilds(nodeIndex, :);
    
    matrix = matrix(:,~childOfCurrentNode,:);
end

function meanExpressionMatrix = getMeanExpressionOfNodes(expressionMatrix, spatialIndicesOfNodes)
    
    releventExpressionMatrix = expressionMatrix(:,spatialIndicesOfNodes,:) ;
    meanExpressionMatrix = nan(size(expressionMatrix,1), 1, size(expressionMatrix,3));

    for i=1:size(expressionMatrix,3)
        currentSubjectExpression = releventExpressionMatrix(:,:,i) ;
        regionHasNaN = any(isnan(currentSubjectExpression),1); % check if a region is nan
        meanExpressionMatrix(:,:,i)  = mean(currentSubjectExpression(:,regionHasNaN) ,2);
    end

end

function [allChilds, nodeLevel] = allChildNodes(dependencyMatrix)
    allChilds = inv(eye(size(dependencyMatrix)) - dependencyMatrix);
    nodeLevel = sum(allChilds,1);
end