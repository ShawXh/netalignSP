function N = compressIndicesInverse(G)
numVertices = size(G,1);
numEdges = nnz(G);
N = zeros(numVertices, numVertices);
numNeighbors = ones(numVertices,1);
Ge = zeros(numEdges, 3);
[Ge(:,1) Ge(:,2),Ge(:,3)] = find(G);
for i = 1:numEdges
    tail = numNeighbors(Ge(i,2));
    N(Ge(i,2),tail) = Ge(i,3);
    numNeighbors(Ge(i,2))= numNeighbors(Ge(i,2))+1;   
end
end