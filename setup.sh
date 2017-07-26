# download GO annotations
wget -nc ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/UNIPROT/goa_uniprot_gcrp.gaf.gz

# download go ontology
wget -nc http://purl.obolibrary.org/obo/go.obo

# download and install owltools
git clone https://github.com/owlcollab/owltools.git
cd owltools
./build.sh
cd ..

# pull out annotations for these three organisms, from cellular comp aspect only (column 9)
# taxids: 9606, 208964, 224308
zcat goa_uniprot_gcrp.gaf.gz | head -n 1000 | grep '^!' > my_annotations.gaf
zcat goa_uniprot_gcrp.gaf.gz | awk -F $'\t' '$9 == "C" { print $0 }' | awk -F $'\t' '$13 == "taxon:9606" || $13 == "taxon:208964" || $13 == "taxon:224308" { print $0 }' >> my_annotations.gaf

# http://www.ebi.ac.uk/QuickGO/GMultiTerm#tab=edit-terms&a=64%2401Nt01Pf03wK0AZQ0Ha8
# membrane, cell, cytoplasm, organelle, cell periphery, cellular component
echo "GO:0016020\nGO:0005623\nGO:0005737\nGO:0043226\nGO:0071944\nGO:0005575" > idfile_slim.txt

# generate goslim mapping
~/bin/owltools/OWLTools-Runner/bin/owltools go.obo --gaf my_annotations.gaf --map2slim --idfile idfile_slim.txt --write-gaf annotations.mapped.gaf


#membrane (GO:0016020), cell (GO:0005623), cytoplasm (GO:0005737), organelle (GO:0043226), cell periphery (GO:0071944), and cellular component (GO:0005575)
