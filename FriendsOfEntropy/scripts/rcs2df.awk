#! /usr/bin/awk -f
# rcs2df.awk

# For dressing data up as dataframes.

# in: row lable-list, column-header-list, sparse-row-col-val.tsv 
# out: dataframe
# may use row and col lists to filter what ends up in the dataframe from sparse


NF==1 { # row labels
	rowl[FNR]=$1 
	rr=FNR  
}
NF==2 { # column headers
	colh[FNR]=$1
	cc=FNR
}
NF==3 {
	sparse[$1,$2]=$3
}

END{
	header = "GENE\t|"
	for(h=1; h<=hh; h++) { 
		header = header "\t" colh[h] 
	} 
	print "printing header";
	print header;

	for(r=1; r<=rr; r++) {
		row = rowl[r];
		for(c=1; c<=cc; c++){
			row = row "\t" sparse[colh[c],rowl[r]]
		} 
		print row
	}
}
# selected_genes.txt selected_cultivar.txt line_gene_calls.tab > gene_line_call.df

