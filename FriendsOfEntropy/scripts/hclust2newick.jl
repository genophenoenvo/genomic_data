
function hclust2newick(hc_struct::Hclust{Float64}, flat::Bool=true)

#=
  transliterated from  https://rdrr.io/bioc/ctc/src/R/hc2Newick.R

  propertynames(hc_struct)


  merges  :: Array{Int64,2}
  heights :: Array{Float64,1}
  order   :: Array{Int64,1}
  linkage :: Symbol

  merge   :: Array{Int64,2}   (not plural guess R compatibility v.s. Julia convention)
  height  :: Array{Float64,1} (not plural  also identical with heights)
  method  :: Symbol
  labels  :: UnitRange{Int64}

=#

  dist = 0
  if  isnothing(hc_struct.labels)
    labels = 1:length(hc_struct.order)
  else
    labels = hc_struct.labels
  end

  function putparenthesis(i)
    ## recursive function
    ## i: index of row in hc_struct.merge
    j = hc_struct.merge[i, 1]
    k = hc_struct.merge[i, 2]

    if j < 0
      left = labels[-j]
      if k > 0
        dist = hc_struct.height[i] - hc_struct.height[k]
      else
        dist = hc_struct.height[i]
      end
    else
      left = putparenthesis(j)
    end

    if k < 0
      right = labels[-k]
      if j > 0
        dist = hc_struct.height[i] - hc_struct.height[j]
      else
        dist = hc_struct.height[i]
      end
    else
      right = putparenthesis(k)
    end
    if flat
      return join(["(", left, ":", dist/2, ",", right, ":", dist/2, ")"], "")  # R paste()
    else
      return (left=left, right=right, dist=dist)  # R list() ... mutability wories
      # named tuple? let?  StructArrays?
    end
  end

  n = putparenthesis(first(size(hc_struct.merge)))  # R nrows
  if flat
    n = join([n, ";"], "")  # R paste()
  end

  return n

end;


#= write_newick(io:IO, hc_struct::Hclust{Float64}, flat::Bool=true) =#

function write_newick(io::IO, hc_struct::Hclust{Float64}, flat=true)
	#open('newick.tree', w) do io
    	write(io, hclust2newick(hc_struct, flat))
	#end
end
