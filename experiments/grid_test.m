%% Evaluate algorithm performance on a grid
% In this experiment, we evaluate the performance of the matching
% algorithms on two corrupted grids.
%
% We use
%   [A,B,L] = align_grid_test_data(k,q,p,d) 
% to construct two k-by-k grid graph corrupted by noise in the form of
% edges sampled with probability q/d(u,v)^2 where d(u,v) is the number of
% links between u and v.  These two graphs are A and B.
% To construct L, we first fix the true alignment between A and B as the
% identity between the underlying grids.  Next, if d>0, we randomly add
% edges from all vertices within distance d of the exact match, 
% samping them with probability proporational to their distance.  
% (In all of these tests, d=1.)  Finally, we add random matches to L with
% probability p.

%%
addpath('../misc/gaimc'); % get bfs function
addpath('../');


%% Set the parameters for the experiment

nrep = 1;

k = 15;
q = 2;
d = 1;
% use expected degree to indicate noise in L
%pns = [linspace(0.5,8,13) 10 12.5 15 20];
pns = [linspace(0.5,10,5)];

%% Run the experiment

ncorr_bp = zeros(nrep,length(pns));
ncorr_spbp = zeros(nrep,length(pns));


%matlabpool(2);

for pi = 1:length(pns)
    p = pns(pi)./k^2;
    for ri = 1:nrep
        [A,B,L] = align_grid_test_data(k,q,p,d);
        L = spones(L); % ignore weights for this test
        [S,w,li,lj] = netalign_setup(A,B,L);
        
        % compute solutions with belief propagation
        xbp = netalignbp(S,w,1,2,li,lj,0.999,[],1000,false);
        [ma mb mi weight overlap] = mwmround(xbp,S,w,li,lj);
        ncorr_bp(ri,pi) = sum(ma==mb);
        % compute solutions with shortest path belief propagation
        [ma mb mi] = netalignSP_bp(A,B,L);
        ncorr_spbp(ri,pi) = sum(ma==mb);

        disp([pi pns(pi) ri  ...
            ncorr_bp(ri,pi) ...
            ncorr_spbp(ri,pi)])
    end
    
   % save(sprintf('results-k-%i-nrep-%i-partial.mat',k,nrep), 'pi','pns','ncorr','*_bp','*_spbp')
end
save(sprintf('results-k-%i-nrep-%i.mat',k,nrep), 'pi','pns','ncorr','*_bp','*_spbp')
return

