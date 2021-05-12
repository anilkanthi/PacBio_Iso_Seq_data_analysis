#!/bin/bash -l
#SBATCH --partition=fn_medium
#SBATCH -J IsoSeq
#SBATCH --mem=90G
#SBATCH --time=48:00:00
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --array=1-4

module load anaconda3/cpu/5.3.1 minimap2/2.15 gcc/6.1.0 ucscutils/374 r/3.6.1 gffread/0.11.8

export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/annotation/
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/bacteria
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/cupcake
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/cupcake2
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/phasing
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/post_isoseq_cluster
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/SequelQC
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/sequence/
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/simulate
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/singlecell
export PYTHONPATH=$PYTHONPATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/cDNA_Cupcake/targeted



export PATH=$PATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/SQANTI2
export PATH=$HOME/anacondaPy37/bin:$PATH
export PATH=$PATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/SQANTI2/gtfToGenePred
export PATH=$PATH:/gpfs/data/skoklab/home/kantha01/iso_seq/softwares/SQANTI2/utilities/

#conda create -n anaCogent3 python=3.7 anaconda
source activate anaCogent3

PACBIO_DATA=/gpfs/data/skoklab/home/kantha01/iso_seq/pacbio_data/nyu_debaugny_iso-seq

# FL_BAM to FASTQ conversion
# Rename the BAM files and .pbi files with same filenames
nohup bam2fastq -o bc1004_3p.flnc bc1004_3p.flnc.bam &

# ALIGNMENT
# Make changes and run minimap2_alignment.sh

# Create SAM folder and Move SAM files to SAM folder

# Sort SAM files
samtools sort bc1002.clustered.hq.fasta.sam -o bc1002.clustered.hq.fasta_SORTED.sam

# SAM to BAM conversion
samtools view -S -b bc1001.clustered.hq.fasta_SORTED.sam > bc1001.clustered.hq.fasta.bam
samtools sort bc1001.clustered.hq.fasta.bam -o bc1001.clustered.hq.fasta_SORTED.bam
samtools index -b bc1001.clustered.hq.fasta_SORTED.bam

# Collapse Isoform
# Make changes and run collapse_isoforms.sh

# GFF to GTF conversion
gffread bc1001.tofu.collapsed.gff -T -o bc1001.tofu.collapsed.gtf

# Generate FL Counts file
get_abundance_post_collapse.py \
    bc1001.tofu.collapsed \
    $PACBIO_DATA/bc1001.clustered.cluster_report.csv
    
#SQANTI2


