#!/usr/bin/env bash

# Print commands when executing & exit on any error
set -ex

# Download reference
curl 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&db=nuccore&report=fasta&id=NC_045512.2' -o output/reference.fasta -s

# Index reference
minimap2 -x sr -d output/reference.mmi output/reference.fasta

# Process each run
for accession in ERR5709045 ERR5709318 ERR5709385 ERR5708657; do
    # Create folders
    mkdir -p output/qc output/mapping
    # Download data
    fastq-dl --accession $accession --cpus 1 --outdir data
    # Quality control
    fastp \
        -i data/${accession}_1.fastq.gz -I data/${accession}_2.fastq.gz \
        -o output/qc/${accession}/${accession}_1.fastq.gz -O output/qc/${accession}/${accession}_2.fastq.gz \
        -h output/qc/${accession}/fastp.html -j output/qc/${accession}/fastp.json
    # Map reads
    minimap2 \
        -t 2 -ax sr \
        output/reference.mmi \
        output/qc/${accession}/${accession}_1.fastq.gz output/qc/${accession}/${accession}_2.fastq.gz | \
        samtools sort -o output/mapping/${accession}.sorted.bam
done

# MultiQC report
mkdir -p output/qc/multiqc
multiqc --outdir output/qc/multiqc output/qc/*/fastp.json
