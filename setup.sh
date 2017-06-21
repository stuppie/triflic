# download GO annotations
wget -nc ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/UNIPROT/goa_uniprot_gcrp.gaf.gz

# download go ontology
wget -nc http://purl.obolibrary.org/obo/go.obo

# download and install owltools
git clone https://github.com/owlcollab/owltools.git
cd owltools
./build.sh
cd ..

# pull out annotations for these three organisms
# taxids: 9606, 208964, 224308
zcat goa_uniprot_gcrp.gaf.gz | head -n 1000 | grep '^!' > my_annotations.gaf
zcat goa_uniprot_gcrp.gaf.gz | awk -F $'\t' '$13 == "taxon:9606" || $13 == "taxon:208964" || $13 == "taxon:224308" { print $0 }' >> my_annotations.gaf

# generate goslim mapping
~/bin/owltools/OWLTools-Runner/bin/owltools go.obo --gaf my_annotations.gaf --map2slim --subset goslim_generic --write-gaf annotations.mapped.gaf
