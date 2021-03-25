#! ~/bin/julia

# gen_hclust.jl

#=
    written circa Julia version 1.5
    If starting from nothing....

using Pkg;
Pkg.add("Clustering")
Pkg.add("StatsPlots")

*** can also enter the builtin package manager from the REPL with ']'
*** then for example just write `add DelimitedFiles`
=#

using DelimitedFiles
using Clustering
# using StatsPlots  # too expensive on a headless server

include("hclust2newick.jl")

function main(ARGS)

    # read in the sparse delimited representation of a distance matrix
    sdm_dir = ARGS[1]
    sdm_file = ARGS[2]

    sparse = readdlm(string(sdm_dir, "/", sdm_file))

    # find max index for observations  (in this case anyway)
    obs = maximum(sparse[1:size(sparse,1), 2]);

    # init a distance matrix
    dist = zeros(obs+1, obs+1); # experiment: +1 for zeroa in outgroup?

    # populate the upper and lower triangles with Jaccard distances
    for i in 1:size(sparse,1)
        dist[sparse[i,1],sparse[i,2]] = dist[sparse[i,2],sparse[i,1]] = sparse[i,7]
    end

    # save a copy of the symmetric matrix
    open(sdm_dir * "/hct-jaccard-dist-mat-sym.tsv", "w") do io
        writedlm(io, dist)
    end


    #=
        hclust struct info gleened

     propertynames(hc)
     (:merges, :heights, :order, :linkage, :height, :labels, :merge, :method)


    linkage === method one of

        :single (the default): use the minimum distance between any of the cluster members
        :average: use the mean distance between any of the cluster members
        :complete: use the maximum distance between any of the members
        :ward

    uplo:
        upper :U or lower :L   if unspecified expects symmetric

        ---------------
    branchorder (order?) one of:
        :r (the default as R does): based on the node heights & original elements order
        :barjoseph (or :optimal):

	merge === merges

	height ===  heights

    =#

    # generate the hierarchical cluster
    hc = hclust(dist, linkage=:complete, uplo=:L, branchorder=:optimal)

    # lookey lou (from repl any way)
    # plot(hc, xticks=false)

    #=
        oooo. grab a screen shot

        looks plausible. no clue how to export in useful format
        answer: have to make one!
        write scripts/hclust2newick.jl
    =#

    open(sdm_dir * "/hcdm.tree", "w") do io
        write_newick(io, hc)
    end

    # partition the observations into a set of clusters(features)
    # appropriate to the number of  cultivars (observations) (10:1 per folklore)
    # make the h-clust assignments

    hca = cutree(hc; k=Integer(ceil(size(hc.order)[1]/10)))

    # make the implicit index explicit
    idx_hca = [ia for ia in zip([1:1:length(hca);], hca)]

    # save a copy of the cluster assignments
    open(sdm_dir * "/iss_cultivar_cluster_assignment", "w") do io
        writedlm(io, idx_hca)
    end






end

main(ARGS)
