function meansureDistanceFromMapping()
% finds the first common parent of all posible pairs
    load('humanOntology.mat');

    [totalNumberOfNodes, numberOfChildNodes] = countChildrenRec(1, dependecyMatrix);
    firstCommonParent = getFirstParent(dependecyMatrix);
    childUnderParent = zeros(size(dependecyMatrix));
    for i=1:length(firstCommonParent(:))
       if firstCommonParent(i) ~= 0 
          childUnderParent(i) =  numberOfChildNodes(firstCommonParent(i));
       end
    end
    similarityMeasure = childUnderParent / totalNumberOfNodes;
    
    save('humanOntology.mat');
end


function firstCommonParent = getFirstParent(ontologyDependecy)
% finds the first common parent of all posible pairs
    allParents = inv(eye(size(ontologyDependecy)) - ontologyDependecy) - eye(size(ontologyDependecy));
    allPairs = nchoosek(2:size(ontologyDependecy,2),2);
    firstCommonParent = zeros(size(ontologyDependecy));
    for i =1:size(allPairs,1)
        firstNodeIndex = allPairs(i,1);
        secondNodeIndex = allPairs(i,2);
        firstCommonParent(firstNodeIndex, secondNodeIndex ) = findFirstCommonParent(allParents(:,firstNodeIndex), allParents(:,secondNodeIndex));
    end
end

function firstCommonParentIndex = findFirstCommonParent(vectorA, vectorB)
    jointParents = vectorA & vectorB;
    firstCommonParentIndex = max( find(jointParents));
end
function [nodeCount, recCount] = countChildrenRec(nodeIndex, ontologyDependecy)
    % Counts the number of nodes under the current node
    
    recCount = zeros(size(ontologyDependecy,1),1);
    nodeCount = 0;
    directChilds = find(ontologyDependecy(nodeIndex,:) == 1);
    
    for childIndex = directChilds
       [childNodeCound, childRecCount] = countChildrenRec(childIndex, ontologyDependecy);
       nodeCount = nodeCount + 1 + childNodeCound;
       recCount = recCount + childRecCount;
    end
    recCount(nodeIndex) = nodeCount;
end

