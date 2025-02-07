# SLURM and Snakemake workshop

A three-part, hands-on workshop.

## Prerequisites

- Unix-like command line. Linux-based and macOS are good by default. For Windows, install the [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
- [`conda`](https://docs.conda.io/projects/conda/en/stable/), to manage packages. The [Miniconda](https://docs.anaconda.com/miniconda/install/) installer + [`mamba`](https://anaconda.org/conda-forge/mamba) (`conda` but faster) should work well.

## [Introduction to SLURM](/slurm/)

Learn how to work within a computing cluster using SLURM.

## [Simple workflow with a script, Make and Snakemake](/simple/)

Build a workflow that generates and writes content to two files,
then merges them into a final target file, demonstrated in three different ways.

## [Bioinformatics workflow with Snakemake](/bioinfo/)

Construct a Snakemake workflow to process raw FASTQ reads into sorted BAM mappings.
