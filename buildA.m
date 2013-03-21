function buildA()

    %load('expressionMatrixCombainedByStructure.mat');
    load('onlyCorrelativeProbes.mat'); load('expressionMatrixCombainedByStructure.mat','allStructures','location_std','location_xyz','reverseIndex');
    ontology = load('humanOntology.mat');

    someChecks( allStructures, ontology);

    [ontology.bellowThresholdIndices,ontology.unDirectedDistanceMatrixThresholded]  = thresholdByDistance(ontology.unDirectedDistanceMatrix, 6);
    ontology.adjacancyMatrix = distanceToAdjacancy(ontology.unDirectedDistanceMatrixThresholded);
    reducedOntology = reduceOntologyList(allStructures, ontology);
  
    %[correlationMatrix, validStrcturesIndices1, validStrcturesIndices2] = computeCorrelationBetweenExpressionMatrix(dataMatrix(:,:,1), dataMatrix(:,:,2), allStructures);
    [correlationMatrix, validStrcturesIndices1, validStrcturesIndices2] = computeCorrelationBetweenExpressionMatrix(dataMatrixOfSelectedProbes(:,:,1), dataMatrixOfSelectedProbes(:,:,2), allStructures);
    
    adjacencyMatrixSource = reducedOntology.adjacancyMatrix(validStrcturesIndices1,validStrcturesIndices1);
    adjacencyMatrixDestination = reducedOntology.adjacancyMatrix(validStrcturesIndices2,validStrcturesIndices2);
    allStructuresSource = allStructures(validStrcturesIndices1, :);
    allStructuresDestination = allStructures(validStrcturesIndices2, :);
    
    %threshold the adjacancy
    sortedWeights =  sort(adjacencyMatrixDestination(:));
    theTopForthPercential = adjacencyMatrixDestination > sortedWeights(ceil(length(sortedWeights)* 0.75));
    
    regionSimilarityOnlyCorrelation = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination,0);
    measureSimilarity(regionSimilarityOnlyCorrelation, validStrcturesIndices1, validStrcturesIndices2, reducedOntology )
    
 %   load('regionSimilarity.mat','regionSimilarity');
    %regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination,1);
    regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination,10);
    %save('regionSimilarity.mat','regionSimilarity','regionSimilarityOnlyCorrelation');
    
    measureSimilarity(regionSimilarity, validStrcturesIndices1, validStrcturesIndices2, reducedOntology )
end

function measureSimilarity(regionSimilarity, validStrcturesIndices1, validStrcturesIndices2, reducedOntology )
    
    ontologySimilarity = reducedOntology.similarityMeasure + reducedOntology.similarityMeasure';
    ontologySimilarity = ontologySimilarity(validStrcturesIndices1, validStrcturesIndices2);
    sourceOntology = reduceOntologyToIndexes(reducedOntology, validStrcturesIndices1);
    destinationOntology = reduceOntologyToIndexes(reducedOntology, validStrcturesIndices1);
    
    % PLEASE CHECK THIS !!!!!!!!!!!!!!!!!!
    [bestMatchScore_Source, bestMatchIndex_Source] = max(regionSimilarity,[],2);
    [bestMatchScore_Destination, bestMatchIndex_Destination] = max(regionSimilarity,[],1);
    distances_Source = zeros(size(bestMatchIndex_Source));
    for i =1:length(bestMatchIndex_Source)
        distances_Source(i) = ontologySimilarity(i, bestMatchIndex_Source(i));
    end
    
    distances_Destination = zeros(size(bestMatchIndex_Destination));
    for i =1:length(bestMatchIndex_Source)
        distances_Destination(i) = ontologySimilarity(bestMatchIndex_Destination(i), i);
    end
    
    subplot(2,1,1);
    hist(ontologySimilarity(:),50);
    subplot(2,1,2);
    hist(distances_Destination,50);
    figure; imagesc(regionSimilarity); colorbar;
    
end
function [bellowThresholdIndices,distanceMatrix]  = thresholdByDistance(distanceMatrix, distanceThreshold)
    bellowThresholdIndices = distanceMatrix < distanceThreshold;
    distanceMatrix(~bellowThresholdIndices) = inf;
end

function adjacancyMatrix = distanceToAdjacancy(distanceMatrix)
    % Turn distance scores into adjacancy scores
    % the connection between the nodes should be between 0 and 1
    % where distanced nodes should receive a score near 0
    %
    % I assume that the distances are all positive
    
    adjacancyMatrix = exp(-distanceMatrix);
    adjacancyMatrix = triu(adjacancyMatrix,1);
end

function reducedOntology = reduceOntologyList(allStructures, ontology)

    % use both the full structure name and the short to reduce the ontology
    % so the ontology will contain only structures which appear in the experiment
    
    fullAndShort = strcat(allStructures(:,3), allStructures(:,2));
    fullAndShortOntology = strcat(ontology.structureLabels(:,4), ontology.structureLabels(:,3));
    appears = ismember(fullAndShortOntology , fullAndShort);
    reducedOntology = reduceOntologyToIndexes(ontology, appears);
end

function reducedOntology = reduceOntologyToIndexes(ontology, appears)
    reducedOntology.dependecyMatrix = ontology.dependecyMatrix(appears,appears);
    reducedOntology.structureLabels = ontology.structureLabels(appears,:);
    reducedOntology.unDirectedDistanceMatrix = ontology.unDirectedDistanceMatrix(appears,appears);
    reducedOntology.directedDistanceMatrix = ontology.directedDistanceMatrix(appears,appears);
    reducedOntology.adjacancyMatrix = ontology.adjacancyMatrix(appears,appears);
    reducedOntology.bellowThresholdIndices = ontology.bellowThresholdIndices(appears,appears);
    reducedOntology.similarityMeasure = ontology.similarityMeasure(appears,appears);
 
end

function someChecks(allStructures, ontology)


    % check if every structure which was measured appears in the structure ontology
    
    %full name
    appears = ismember(allStructures(:,3), ontology.structureLabels(:,4) );
    assert(all(appears))

    % short name
    appears = ismember(allStructures(:,2), ontology.structureLabels(:,3) );
    assert(all(appears))
    
    fullAndShort = strcat(allStructures(:,3), allStructures(:,2));
    fullAndShortOntology = strcat(ontology.structureLabels(:,4), ontology.structureLabels(:,3));
    
    appears = ismember(fullAndShort, fullAndShortOntology);
    assert(all(appears))
    
    simalirity = zeros(size(ontology.unDirectedDistanceMatrix));
    simalirity(ontology.unDirectedDistanceMatrix < 7 ) = 1;
    simalirity = simalirity - eye(size(simalirity));
    a = spectralClutering(simalirity,10);
end

function index = duplicates(A)
[uniqueVal, n,m] = unique(A);

c = histc(m, 1:max(m));
multiple = c > 1;
duplicatesVal = uniqueVal(multiple);



end