function IDX = spectralClutering(similarityMatrix, k, normalized)

    D = diag(sum(similarityMatrix,1));
    
    laplacian = D - similarityMatrix;
    if exist('normalized', 'var')
        if strcmp(normalized, 'randomWalk')
            laplacian = eye(size(similarityMatrix)) - inv(D) * similarityMatrix;
        end
    end
    
    
    [eigenvectors, eigenvalues] = eig(laplacian) ;
    bottomKeigenVectors = eigenvectors(:,1:k);
    
    IDX = kmeans(bottomKeigenVectors,k);
end