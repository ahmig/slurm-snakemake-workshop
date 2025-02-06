# Bioinformatics workflow with Snakemake

## Data download

We'll use FASTQ files hosted by the ENA.
Files can be downloaded manually, but we'll use [`fastq-dl`](https://github.com/rpetit3/fastq-dl)
for convenience.

First, create an environment (named `pgo-workshop-bioinfo`) with `snakemake` and `fastq-dl`
using `mamba` (recoomended) or `conda`.

```shell
mamba/conda create -n pgo-workshop-bioinfo -c conda-forge -c bioconda fastq-dl==3.0.0 snakemake==8.25.5
mamba/conda activate pgo-workshop-bioinfo
pip install legacy-cgi  # necessary is using Python >=3.13; see GitHub issue rpetit3/fastq-dl#34
```

Then, download the following run accessions. They contain SARS-CoV-2 reads that were
use in our [VIPERA study](https://doi.org/10.1093/ve/veae018). All of them are paired-end Illumina reads.

```shell
fastq-dl --accession ERR5709045 --cpus 1 --outdir data
fastq-dl --accession ERR5709318 --cpus 1 --outdir data
fastq-dl --accession ERR5709385 --cpus 1 --outdir data
fastq-dl --accession ERR5708657 --cpus 1 --outdir data
```

## Reads data analysis

The analysis will include the following steps:

- Quality control with [`fastp==0.23.4`](https://github.com/OpenGene/fastp), then summarize with [`multiqc==1.25.1`](https://github.com/MultiQC/MultiQC).
- Fetch a reference sequence in FASTA format (RefSeq [NC_045512.2](https://www.ncbi.nlm.nih.gov/nuccore/1798174254)).
- Index the reference sequence (optional) and map the filtered reads with [`minimap2==2.28`](https://github.com/lh3/minimap2), then sort with [`samtools==1.20`](https://github.com/samtools/samtools).

These can be run using the following commands:

```shell
# Quality control and report
fastp -i <FASTQ R1> -I <FASTQ R2> -o <filtered FASTQ R1> -O <filtered FASTQ R2> -h <HTML report> -j <JSON report>
multiqc --outdir <output folder> <JSON files>
# Fetch reference
curl 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&db=nuccore&report=<format>&id=<accession number>' -o <file name> -s
# Index reference (optional)
minimap2 -x <preset> -d <MMI output> <FASTA file>
# Map filtered reads
minimap2 -t <threads> -ax <preset> <MMI output / FASTA file> <filtered FASTQ R1> <filtered FASTQ R2> | samtools sort -o {output.bam}
```

The outcome of the workflow should be a sorted BAM for each run accession,
and a [MultiQC](https://github.com/MultiQC/MultiQC) report of the four FASTQs.

To run the analyses with Snakemake, we will execute the following commands:

```shell
# dry run (testing)
snakemake -n --verbose --printshellcmds
# run
snakemake -c 2 --use-conda
```
