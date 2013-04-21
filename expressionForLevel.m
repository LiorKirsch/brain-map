function expressionMatrixOfLevel = expressionForLevel(expressionMatrix,ontology, level, structureData)

    load('onlyCorrelativeProbes.mat'); load('expressionMatrixCombainedByStructure.mat','allStructures');
    level = 4;
    ontology = load('humanOntology.mat');
    [region146, region170, grossRegions] = getAllenPaperRegions(ontology);

    expressionMatrix = dataMatrixOfSelectedProbes;
    
    locationInAllStructures = findStructuresInOntologyList(allStructures, ontology);
    
    reducedOntology = reduceToLeafAndParents(ontology, logical(locationInAllStructures));
    
    [allChilds, nodeLevel] = allChildNodes(ontology.dependecyMatrix);
    
    
    childOfNodes = getIndexesOfChilds([1310,1460], ontology); % [white matter, sulci] 
    nodesInLevel =  (nodeLevel == level) & ~childOfNodes;
    childsOfNodesInLevel = logical(allChilds(nodesInLevel, :));
    
    expressionMatrixOfLevel = nan(size(expressionMatrix,1), size(childsOfNodesInLevel,1), size(expressionMatrix,3));

    for i = 1:size(childsOfNodesInLevel,1)
        childOfCurrentNode = childsOfNodesInLevel(i,:);
        translateToAllStructureIndices = locationInAllStructures(childOfCurrentNode);
        translateToAllStructureIndices = translateToAllStructureIndices( translateToAllStructureIndices> 0);
        expressionMatrixOfLevel(:,i,:) = getMeanExpressionOfNodes(expressionMatrix, translateToAllStructureIndices);
    end
    
    noData = any(isnan(expressionMatrixOfLevel),1);
    allSubjectHaveNoDataForRegion = all(noData,3);
    structureLabels = ontology.structureLabels(nodesInLevel,:);
    
    structureLabelsWithData = structureLabels(~allSubjectHaveNoDataForRegion,:);
    expressionMatrixOfLevelWithData = expressionMatrixOfLevel(:,~allSubjectHaveNoDataForRegion,:);
end

function [region146, region170, grossRegions] = getAllenPaperRegions(ontology)
    allenPaper = load('allenPaperStructureData/allenPaper.mat');
    region170 = ismember(ontology.structureLabels(:,1),allenPaper.region170Details(:,1));
    region146 = ismember(ontology.structureLabels(:,1),allenPaper.region146Details(:,1));
    grossRegions = ismember(ontology.structureLabels(:,4),allenPaper.grossRegions(:,1));
end

function childOfNodes = getIndexesOfChilds(nodeIndexes, ontology)
    [allChilds, ~] = allChildNodes(ontology.dependecyMatrix);
    childOfNodes = allChilds(nodeIndexes, :);
    childOfNodes = sum(childOfNodes,1);
end

function meanExpressionMatrix = getMeanExpressionOfNodes(expressionMatrix, spatialIndicesOfNodes)
    
    releventExpressionMatrix = expressionMatrix(:,spatialIndicesOfNodes,:) ;
    meanExpressionMatrix = nan(size(expressionMatrix,1), 1, size(expressionMatrix,3));

    for i=1:size(expressionMatrix,3)
        currentSubjectExpression = releventExpressionMatrix(:,:,i) ;
        regionHasNaN = any(isnan(currentSubjectExpression),1); % check if a region is nan
        meanExpressionMatrix(:,:,i)  = mean(currentSubjectExpression(:,~regionHasNaN) ,2);
    end

end

function [allChilds, nodeLevel] = allChildNodes(dependencyMatrix)
    allChilds = inv(eye(size(dependencyMatrix)) - dependencyMatrix);
    nodeLevel = sum(allChilds,1);
end

function locationInAllStructures = findStructuresInOntologyList(allStructures, ontology)

    % use both the full structure name and the short to reduce the ontology
    % so the ontology will contain only structures which appear in the experiment
    
    fullAndShort = strcat(allStructures(:,3), allStructures(:,2));
    fullAndShortOntology = strcat(ontology.structureLabels(:,4), ontology.structureLabels(:,3));
    [~, locationInAllStructures] = ismember(fullAndShortOntology , fullAndShort);
    
end

function reducedOntology = reduceToLeafAndParents(ontology, leafIndices)

    [allChilds, ~] = allChildNodes(ontology.dependecyMatrix);
    leafParents = allChilds(:,leafIndices);
    leafsAndParents = any(leafParents,2);
    reducedOntology = reduceOntologyToIndexes(ontology, leafsAndParents);
end

function reducedOntology = reduceOntologyToIndexes(ontology, appears)
    reducedOntology.dependecyMatrix = ontology.dependecyMatrix(appears,appears);
    reducedOntology.structureLabels = ontology.structureLabels(appears,:);
    reducedOntology.unDirectedDistanceMatrix = ontology.unDirectedDistanceMatrix(appears,appears);
    reducedOntology.directedDistanceMatrix = ontology.directedDistanceMatrix(appears,appears);
%    reducedOntology.adjacancyMatrix = ontology.adjacancyMatrix(appears,appears);
%    reducedOntology.bellowThresholdIndices = ontology.bellowThresholdIndices(appears,appears);
%    reducedOntology.similarityMeasure = ontology.similarityMeasure(appears,appears);
 
end