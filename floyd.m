function dist = floyd(G)

numV = size(G,1); 
G = 1./G;
G(1:numV+1:numV*numV)= 0;
for i = 1:numV
    i2k = repmat(G(:,i),1,numV);
    k2j = repmat(G(i,:),numV,1);
    G = min(G,i2k+k2j);
end
dist = G;
end