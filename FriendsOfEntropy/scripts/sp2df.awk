#! /usr/bin/awk -f
# sp2df.awk 

# sparse to dataframe 
# ex:
# sp2df.awk -F'\t' line_gene_calls.tab > gene_cultivar_call.dataframe


BEGIN{ FS=OFS="\t"} 

/^[^#]/ {	
	sparse[$1,$2]=$3;
	# setting to the row number allows intended (if any) ordering to be preserved 
	dim1[$1]=NR; # cultivar (smaller than dim2 in this case)
	dim2[$2]=NR	 # gene 	
}


# if it comes up ... can look into switching dims 
END{
	#print "Output Dimensions: " length(dim2) " X " length(dim1) #> '/dev/stderr'
	header = "";
	n=asorti(dim1,dim1s);
	for(c = 1; c <= n; c++){header = header "\t" dim1s[c]}
	print header;
	for(r in dim2){
		out = r;
		for(c = 1; c <= n; c++){
			val = 0
			if((dim1s[c], r) in sparse) 
				val = sparse[dim1s[c],r]
			out = out "\t" val
		}
		print out
	}
}

