%%% Nonparametric Power-law Data Clustering


function c, clusters = pyp_means(values, counts, lambda, theta)

    %% Initialization
    len = length(values)

    clusters = struct('means', [], 'assignments', [], 'c', 0)

    m1 = dot(values, counts)/len
    clusters.means = [clusters.means; m1] %array of cluster means
    clusters.assignments = [clusters.assignments; 1:len] %array of cluster assignments for each cluster
    
    keyset = 1:len
    valueset = zeros(257,1)
    clusters.map = containers.Map(keyset, valueset) % map for x (index in values) to cluster
    
    %% Loop until convergence
    %%% NEED TO ADD WHILE LOOP
    
    D_r = [];
    for i = 1:len
        x_i = values(i);
        d_ik = [];
        clusters.c = length(clusters.means)
        
        for k = 1:c
            d_ik = [d_ik; (x_i - clusters.means(k))^2];
           
           [min_d, min_idx] = min(d_ik) 
            
           if min_d - theta > lambda - log(c) * theta
               D_r = [D_r; i];
           
           else
               clusters = assign_cluster(i, min_idx, clusters)
     
           end
        end
        
        % re-cluster the unclustered data set D_r
       clusters = re_cluster(D_r, clusters, values, counts, lambda, theta)

       % center agglomeration
       clusters = center_agglomeration(clusters, lambda, theta)

       % update c, means
       clusters.means = calc_cluster_means(clusters, values, counts)
        
    end

    
end




function z = assign_cluster(i, min_idx, clusters)
    c = length(clusters)
   
    len = length(min_idx)
    if len > 1
        k_assigned = min_idx(unidrnd(len))
    end
   
    k_past = clusters.map(i) %find out where it was assigned before
    clusters.map(i) = k_assigned %now update map assignment
    
    % find x_idx in old assignment list and add to new cluster assignment
    
    old_idx = find(clusters.assignments(k_past) == i)
    
    
    
    clusters.assignments(k_assigned) = [clusters.assignments(k_assigned; i]
   
end


function means = calc_cluster_means(cluster, values, counts)

    c = cluster.c
    for k = 1:c
       
        assignments = clusters.assignments(k);
        len = length(assignments)
        sum = 0;
        
        for i = 1:len
            idx = assignments(i)
            sum = sum + values(idx) * counts(udx)
        end
        
        mean = sum/len
        
        clusters.means(k) = mean
    end
end




function clusters = re_cluster(D_r, clusters, values, counts, lambda, theta)

    for i = 1:length(D_r)
       x_idx = D_r(i) 
       x_i = values(x_idx)
       
       d_ik = [];
       d_r = [];
       
       for k = 1:clusters.c
           d_ik = [d_ik; (x - clusters.means(k))^2]
           d_r = [d_r; min(d_ik)]     
       end
       
       d_r = [d_r, D_r]
       [~, sorter] = sort(d_r(:,1), 'descend')
       d_r = d_r(sorter, :)
       
       new_x_idx = d_r(1,2) %x/value index of largest d_k
       
       
       if d_r(1) - theta > lambda - log(c)* theta
           clusters.means = [clusters.means; values(new_x_idx)]
           clusters.c = length(clusters.means)
           assign_cluster(new_x_index, clusters.c, clusters)
           
       else
           [~, min_idx] = min(d_ik)
       
      
       
       
       
       end
        
    end
end

function clusters = center_agglomeration(clusters, lambda, theta)

    % create inter_cluster_d_ij
    % sort (i,j) by d_ij in ascending order
    % check_agglom for each (i,j) pair
    
    c = clusters.c;
    agglom_term = lambda - theta * log(((c+1)^(c+1))/c^c;
    
        
    d = zeros(i,j) %inter-cluster pair-wise squared distance matrix
    
    for i = 1 : c-1
        for j = i+1 : c
            d(i,j) = (clusters.means(i) - clusters.means(j))^2        
        end
    end
    
    
    
    
    
    
    for i = 1:c-1
        
        n1 = length(clusters.assignments(i));

        
        for j = i+1 : c
            n2 = length(clusters.assignments(j));
    
            if d(i,j) < (n1 + n2)/(n1*n2) * agglom_term
                clusters = combine_clusters(clusters, i, j)
                break
            end
    
    
    % if satisfied == 1, combine the two clusters



end



function satisfied = check_agglom(clusters, i, j, lambda, theta)
    
    sq_diff = (clusters.means(i) - clusters.means(j))^2;;
    
    n1 = length(clusters.assignments(i));
    n2 = length(clusters.assignments(j));

    c = clusters.c;
    
    if sq_diff < (n1 + n2)/(n1*n2) * (lambda - theta * log(((c+1)^(c+1))/c^c))
        satisfied = 1;
    
    else
        satisfied = 0;

    end
end


function clusters = combine_clusters(clusters, i, j)
    % combine_clusters will take two clusters and combine them such that
    % all the points in the two clusters are now in a single cluster
    
    % the cluster struct is updated by recomputing the mean, assignments,
    % and c
    
    
    % clusters:  the struct with assignments, means, and c (number of
    % clusters)
    
    % i,j are indices of clusters to combine

    assignments = [clusters.assignments(i), clusters.assignments(j)] %aggregating the point assignments into a single list
    
    sum = 0 %sum for mean re-computation
    
    for a = 1:length(assignments)
        sum = sum + values(a) * counts(a)
    end
    
    mean = sum/a; %newly recomputed mean for single cluster

    % remove the two old clusters
    idx_to_remove = [i,j]
    clusters.assignments(idx_to_remove) = []
    clusters.means(idx_to_remove) = []
    
    % create new, single cluster and update struct
    clusters.means = [clusters.means; mean]
    clusters.assignments = [clusters.assignments; assignments]
    clusters.c = length(clusters.means)
    
    
    % UPDATE clusters.map

end







