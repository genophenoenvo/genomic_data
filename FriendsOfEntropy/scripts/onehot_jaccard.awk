#! /usr/bin/awk -f
# onehot_jaccard.awk
#
# ex: scripts/onehot_jaccard.awk -F ' ' cultivar_gene_onehot.txt > cultivars_jdistance.txt 

#  generate sparse jaccard-distance matrix 
#  from a labeled list of 1-hot vectors
#  first item is expected to be label 

BEGIN {OFS="\t"}

{	label[NR]=$1;
	m = NF > m ? NF : m   # longest row should all be ~ 4.4k (avoids trailing empty)
	split($0, row, " ");
	for(i=2; i<=NF; i++)
		a[NR,i-1] = row[i-1]
}

END {
	m -= 1  # discount the label
	n = length(label)	# ~362
	for(i=1;i<n;i++){
		for(j=i+1;j<=n;j++){

			for(k=1;k<=m;k++){
				intersect += a[i,k] && a[j,k] 
				union += a[i,k] || a[j,k]
			}
			print i, j, label[i], label[j], intersect, union, union?intersect / union :"NAN";
			intersect = union = 0;
		}
	}
}
