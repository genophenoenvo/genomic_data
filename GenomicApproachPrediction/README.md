### GenomicApproachPrediction


Continuation of processing of data found under:  
   https://data.monarchinitiative.org/genophenoenvo/tassel5/


The request is to associate gene-ontology terms with genes that made it through
the pipeline. 


I think  
https://data.monarchinitiative.org/genophenoenvo/tassel5/season4/vep_v2.tsv 

(re copied to this repo) 
 
contain the genes in question.

    grep -v "^#" vep_v2.tsv | cut -f 4 | sort -u  > tassle_s4_vep_gene.list

there are:  
```
    wc -l < tassle_s4_vep_gene.list
    691
```

Uploading this list to Ensembl Gramene data mart as "Gene stable ID"  
with  `Sorghum bicolor genes (Sorghum_bicolor_NCBIv3)`  
as the selected dataset  

returning all fields in the "EXTERNAL" GO section as Attributes as a gzipped tsv.

http://ensembl.gramene.org/biomart/martview/e60cb960a1b218a72ba984a5269dbf51

(I would be surprised if the link does not expire)

reduce it down to just the two identifier fields (gene and go)  
```
    zcat mart_export.txt.gz | cut -f1,2 | grep "GO:" > VEP-gene_GO-term.tsv
```


