#! ~/bin/julia

# gen_hclust.jl

#=
    written circa Julia version 1.5
    If starting from nothing....

using Pkg;
Pkg.add("Clustering")
Pkg.add("StatsPlots")

*** can also enter the builtin package manager from the REPL with ']' 
*** then for example just write `add ArgParse`

using ArgParse
=#

using DelimitedFiles
using Clustering
using StatsPlots
#= include("hclust2newick.jl") =#


# read in the sparse delimited representation of a distance matrix
sparse = readdlm(ARGS[1])

# find max index for observations  (in this case anyway)
obs = maximum(sparse[1:size(sparse,1), 2]);

# init a distance matrix
dist = zeros(obs, obs);

# populate the upper and lower triangles with Jaccard distances
for i in 1:size(sparse,1)
    dist[sparse[i,1],sparse[i,2]] = dist[sparse[i,2],sparse[i,1]] = sparse[i,7]
end

# save a copy of the symmetric matrix
open("hct-jaccard-dist-mat-sym.tsv", "w") do io
    writedlm(io, dist)
end


#=
    hclust struct info gleened

 propertynames(hc)
 (:merges, :heights, :order, :linkage, :height, :labels, :merge, :method)


linkage  one of

	:single (the default): use the minimum distance between any of the cluster members
	:average: use the mean distance between any of the cluster members
	:complete: use the maximum distance between any of the members
	:ward

uplo:
	upper :U or lower :L   if unspecified expects symeteric

	---------------
branchorder one of:
	:r (the default as R does): based on the node heights & original elements order
	:barjoseph (or :optimal):

=#

# generate the hieracharical cluster
hc = hclust(dist, linkage=:complete, uplo=:L, branchorder=:optimal)



# lookey lou (from repl any way)
# plot(hc,xticks=false)
# oooo. grab a screen shot

# looks plausible. no clue how to export in useful format
# answer: have to make one!

#=

nwktree = hclust2newick(hc)

open("hct-jaccard.tree", "w") do io
    write(io, nwktree)
end

=#


# partition the onservations into a set of clusters(features)  
# appropriate to the number of cultivars (10:1 per folklore)

hca = cutree(hc; k=Integer(ceil(size(hc.order)[1]/10)))

# save a copy of the cluster asignments
open("iss_cultivar_cluster_assignment", "w") do io
    writedlm(io, hca)
end
