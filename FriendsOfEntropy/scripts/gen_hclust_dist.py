import sys
import csv
from ete3 import Tree

'''
    given a tree in Newick format
    and a partitioning of its leaves (via hierarchical clustering)
    find and record the root node of each cluster (most recent common ancestor)

    then for each leaf,
        report the distance to all cluster roots


'''


def gen_hclust_dist(hcdm_tree, leaf_cluster):

    hcdm = Tree(hcdm_tree)
    cluster_root = {}
    with open(leaf_cluster) as tabfile:
        reader = csv.reader(tabfile, delimiter="\t")
        for row in reader:
            cluster_root[row[0]] = hcdm.get_common_ancestor(
                row[1].split(',')
            )
    result = []
    tree_root = hcdm.get_tree_root()
    for leaf in tree_root.get_leaves():
        row = []
        row.append(leaf.name)
        for c in cluster_root:
            row.append(leaf.get_distance(cluster_root[c]))
        result.append(row)

    with open("/dev/stdout", 'w', newline='') as tabfile:
        writer = csv.writer(tabfile, delimiter="\t")
        for line in result:
            writer.writerow(line)


if __name__ == "__main__":
    gen_hclust_dist(sys.argv[1], sys.argv[2])
