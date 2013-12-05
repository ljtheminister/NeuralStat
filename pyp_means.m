function c, clusters = pyp_means(values, counts, lambda, theta)

    %% Initialization
    len = length(values)

    c = 1;
    clusters = struct('means', [], 'assignments', [], 'c', 0)

    m1 = dot(values, counts)/len
    clusters.means = [clusters.means; m1]
    clusters.assignments = [clusters.assignments; 1:len]
    
    %% Loop until convergence
    
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
           clusters = re_cluster(D_r, clusters, values, counts, lambda, theta)
           
           % update c, means
           cluster.means = calc_cluster_means(cluster.means, values, counts)
           
           
        end   
    end

    
end




function z = assign_cluster(i, min_idx, clusters)

    c = length(clusters)
   
end


function means = calc_cluster_means(cluster_means, values, counts)



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

function clusters = center_agglomeration(clusters)

    % create inter_cluster_d_ij
    % sort (i,j) by d_ij in ascending order
    % check_agglom for each (i,j) pair
    
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


    assignments = [clusters.assignments(i), clusters.assignments(j)]
    
    sum = 0
    
    for a = 1:length(assignments)
        
        sum = sum + values(a) * counts(a)
        
    end
    
    mean = sum/a;


    idx_to_remove = [i,j]
    clusters.assignments(idx_to_remove) = []
    clusters.means(idx_to_remove) = []
    clusters.means = [clusters.means; mean]
    clusters.assignments = [clusters.assignments; assignments]
    clusters.c = length(clusters.means)



end







