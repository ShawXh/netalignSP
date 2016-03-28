function [distA,distB,Le,Ae,Be,Pij,Pji,Qij,Qji] = netalign_setup(A,B,L,lambda)

distA = floyd(A);
distB = floyd(B);

distA = 1./((distA).^lambda);
distB = 1./((distB).^lambda);


Le = zeros(nnz(L),3);
Ae = zeros(nnz(distA),3);
Be = zeros(nnz(distB),3);
[Le(:,1) Le(:,2) Le(:,3)] = find(distA);
[Ae(:,1) Ae(:,2) Ae(:,3)] = find(distA);
[Be(:,1) Be(:,2) Be(:,3)] = find(distB);

[Pij Pji] = map_vertice_to_edge(A);
[Qij Qji] = map_vertice_to_edge(B);