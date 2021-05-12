cd /gpfs/data/skoklab/home/kantha01/iso_seq/workshop/SQANTI3/chr15

srun -t 0-4 -c 4 --mem-per-cpu=16G --pty bash
module load anaconda3/cpu/5.3.1 minimap2/2.15 gcc/6.1.0 ucscutils/374 r/3.6.1 gffread/0.11.8
source activate SQANTI3.env

#GTF Convert files
module load gffread/0.11.8
gffread bc1001.tofu.collapsed.gff -T -o bc1001.tofu.collapsed.gtf

export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/annotation/
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/sequence/
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/
chmod +x /gpfs/data/skoklab/home/kantha01/iso_seq/softwares/SQANTI3/utilities/gtfToGenePred

python sqanti3_qc.py --gtf 1004/bc1004.tofu.collapsed.gtf database/gencode.v34.annotation.gtf database/hg38.fa -o bc1004 -d SQANTI3_bc1004_out/ --fl_count 1004/tofu.collapsed.abundance.txt

python sqanti3_RulesFilter.py SQANTI3_bc1001_out/bc1001_classification.txt SQANTI3_bc1001_out/bc1001_corrected.fasta SQANTI3_bc1001_out/bc1001_corrected.gtf

nohup python sqanti3_qc.py --gtf 1001/bc1001.tofu.collapsed.gtf database/gencode.v34.annotation.gtf database/hg38.fa -o bc1001 -d All_SQANTI3_bc1001_out/ --fl_count 1001/tofu.collapsed.abundance.txt --cage_peak database/hg38.cage_peak_phase1and2combined_coord.bed --polyA_motif_list database/human.polyA.list.txt --isoAnnotLite --gff3 tappAS_annotation.gff3 > ALL_SQANTI3_bc1001.out &

#To get Isoform coordinates
cat bc1001_tappAS_annot_from_SQANTI3.gff3 | grep "PB.4209.1" | awk '{print $4"\t"$5}'

#vlookup to match 2 columns and return third column
#VLOOKUP(A30,$K$2:$L$4556,2,FALSE)




