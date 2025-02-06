# Simple workflow with a script, Make and Snakemake

We'll create and write some content to two files and concatenate them in a final target file,
using the following platforms:

- A [Bash](https://www.gnu.org/software/bash/) shell script
- [GNU Make](https://www.gnu.org/software/make/)
- [Snakemake v8.25.5](https://snakemake.readthedocs.io/en/v8.25.5/)

## [Bash](/simple/bash/)

A shell script executes commands linearly, one after the other.

```shell
bash workflow.sh
```

What if we only want to execute part of the workflow?

What if we want to continue the execution from a certain step?
Remove `part_2.txt`. Rerun `bash workflow.sh`. What happens?

## [GNU Make](/simple/make/)

Make is usually used for building software, but it can be used for
any kind of workflow. A `Makefile` contains the instructions on how
to obtain a given file from other files, or from scratch. For example:

```Makefile
target.txt: one.txt two.txt
    cat one.txt two.txt >target.txt
```

Then, running `make` builds the required targets.
By default, the first target is chosen, which is usually named `all`
and has as dependency all the workflow outputs.

```shell
make [target.txt]
```

This makes executing just part of the workflow trivial. If we need only
`one.txt`, we can just execute `make one.txt`.

Again, what if we want to continue the execution from a certain step?
Remove `part_2.txt`. Rerun `make`. What happens?

## [Snakemake](/simple/snakemake/)

Snakemake can do what Make does, and more. Instead of a `Makefile`,
we'll use a `Snakefile`, which has Python-like syntax (we can actually
run Python code inside a Snakefile). Parallelizing the workflow is
easy and automatic thanks to the `--cores` or `-c` command line option. Snakemake
will calculate what rules need executing
(internally, it builds a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph) of jobs)
and will execute them as.

The previous Make workflow could be written in Snakemake as:

```Python
rule make_target:
    input: "one.txt", "two.txt"
    output: "target.txt"
    shell: "cat {input} >{output}"
```

Additionally, Snakemake has many command line options to facilitate
workflow management, debugging and visualization.

```shell
# verbose dry run
snakemake -n --verbose --printshellcmds
# visualize workflow (requires Graphviz)
snakemake --forceall --dag | dot -Tpdf >dag.pdf  
snakemake --forceall --rulegraph | dot -Tpdf >rules.pdf
```

Then, running `snakemake` builds the required targets.

```shell
snakemake -c/--cores 1
```

This also makes executing just part of the workflow trivial. If we need only
`one.txt`, we can just execute `snakemake -c 1 one.txt`.

Again, what if we want to continue the execution from a certain step?
Remove `part_2.txt`. Rerun `snakemake -c 1`. What happens?
