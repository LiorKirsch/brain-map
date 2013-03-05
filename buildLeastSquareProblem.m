function [A,b] = buildLeastSquareProblem(correlationMatrix, adjacencyMatrixSource, adjacencyMatrixDestination)
% adjacencyMatrixSource should be a square m_m matrix
% adjacencyMatrixDestination should be a square n_n matrix
% correlationMatrix should be a square m_n matrix
%
% we are looking for an MxN weights matrix W,
% we represent this matrix as a column vector ( W(:) - by columns )
% this function builds the matrix A and vector b for which we solve provide the least
% square soluction.
%                          |W_11|
%                          | .. |
%                          |W_m1|
%                          |W_12|
%                          | .. |
%                          |W_m2|
%                          |  . |
%                          |  . |
%                          |W_mn|
%                         
% min_w || I*w - b||_2 + lambda * || G w||_2
% G is a matrix that hold that forces the columns of w to be similar for
% elements which are connected.
% for example if element 3 and elemnt 5 are connected then there will be a
% rows such that:
%                W_31 = 1, W_51 = -1 
%                W_32 = 1, W_52 = -1 
%                ...  = 1, ...  = -1 
%                W_3n = 1, W_5n = -1 
%
% F is a matrix that hold that forces the columns of w to be similar for
% elements which are connected.
% for example if element 3 and elemnt 5 are connected then there will be a
% rows such that:
%                W_13 = 1, W_15 = -1 
%                W_23 = 1, W_25 = -1 
%                ...  = 1, ...  = -1 
%                W_m3 = 1, W_m5 = -1 
%

% C is the correlation matrix between areas of source and destination. we flat it to a row vector of size mn| 
%        | I_ (MNxMN) |        | C - correlation vector |
%    A = | G_ (? xMN) | , b =  | 0 (size ?)             |
%        | F_ (? xMN) |        | 0 (size ?)             |

    m = size(correlationMatrix,1);
    n = size(correlationMatrix,2);
    
    assert( m==size(adjacencyMatrixSource,1));
    assert( n==size(adjacencyMatrixDestination,1));

% since the adjancancy matrix is not directed I can remove everything
% bellow the diagonal (duplicate) and the diag itself.

    adjacencyMatrixSource = triu(adjacencyMatrixSource,1);
    adjacencyMatrixDestination = triu(adjacencyMatrixDestination,1);

    
    [rowNodes, columnNodes] = find(adjacencyMatrixSource);
    G = zeros( length(rowNodes) * n, m*n);
    runningIndex = 1;
    for i=1:length(rowNodes)
        rowNode = rowNodes(i);
        columnNode = columnNodes(i);
        
        tmpMatrix = zeros(n, m*n);
        
        one_index = (rowNode -1) * (1:n) + m;
        minus_one_index = (columnNode -1) * (1:n) + m;
        tmpMatrix(one_index) = 1;
        tmpMatrix(minus_one_index) = -1;
        
        G(runningIndex:runningIndex + n - 1,:) = tmpMatrix;
        runningIndex = runningIndex + n;
    end

    [rowNodesDestination, columnNodesDestination] = find(adjacencyMatrixDestination);% +
    F = zeros( length(rowNodesDestination) * m, m*n); % +
    runningIndex = 1;
    for i=1:length(rowNodesDestination)
        rowNode = rowNodesDestination(i);
        columnNode = columnNodesDestination(i);
        
        tmpMatrix = zeros(m, m*n); % +
        
        one_index = (rowNode -1) * n  + 1:m; % +
        minus_one_index = (columnNode -1) * n + 1:m ; % +
        tmpMatrix(one_index) = 1;
        tmpMatrix(minus_one_index) = -1;
        
        F(runningIndex:runningIndex + m - 1,:) = tmpMatrix;% +
        runningIndex = runningIndex + m; % +
    end
    
    A = [ones(m*n); G ; F];
    b = [correlationMatrix(:) ; zeros(length(rowNodes) + length(rowNodesDestination),1)];
end
