function buildA()

    load('expressionMatrixCombainedByStructure.mat');
    ontology = load('buildStructureOntology/humanOntology.mat');

    someChecks( allStructures, ontology);

    reducedOntology = reduceOntologyList(allStructures, ontology);
    
    ontology.adjacancyMatrix = distanceToAdjacancy(ontology.unDirectedDistanceMatrix/4);
    reducedOntology.adjacancyMatrix = distanceToAdjacancy(reducedOntology.unDirectedDistanceMatrix/4);
    
    regionSimilarity = computeRegionSimilarities(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination);
    
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
    % so the ontology will contain only structures which appear in the expriment
    
    fullAndShort = strcat(allStructures(:,3), allStructures(:,2));
    fullAndShortOntology = strcat(ontology.structureLabels(:,4), ontology.structureLabels(:,3));
    appears = ismember(fullAndShortOntology , fullAndShort);
    
    reducedOntology.dependecyMatrix = ontology.dependecyMatrix(appears,appears);
    reducedOntology.structureLabels = ontology.structureLabels(appears,:);
    reducedOntology.unDirectedDistanceMatrix = ontology.unDirectedDistanceMatrix(appears,appears);
    reducedOntology.directedDistanceMatrix = ontology.directedDistanceMatrix(appears,appears);

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
end

function index = duplicates(A)
[uniqueVal, n,m] = unique(A);

c = histc(m, 1:max(m));
multiple = c > 1;
duplicatesVal = uniqueVal(multiple);



end