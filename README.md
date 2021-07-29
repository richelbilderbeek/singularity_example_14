# singularity_example_14

Singularity example 14: installing R packages.

The goal of this example is to create a Singularity image with
an R package installed and using it on an R script.

The R package we'll use is [glue](https://CRAN.R-project.org/package=glue), 
as it is a simple R package without dependencies.

This is the R script, called [script.R](script.R):

```
glue::glue("Hello {target}", target = "world")
```

# Attempt 1

[Singularity_1](Singularity_1) is a minimal Singularity container:

```
Bootstrap: docker
From: r-base

%post
    Rscript -e 'install.packages("glue")'
```

[build_singularity_1.sh](build_singularity_1.sh) is a simple shell script 
to build a container from [Singularity_1](Singularity_1):

```
#!/bin/bash
sudo -E singularity build singularity_1.sif Singularity_1
```

[run_singularity_1.sh](run_singularity_1.sh) is a simple shell script
to run the container built from [Singularity_1](Singularity_1):

```
#!/bin/bash
sudo -E singularity build singularity_1.sif Singularity_1
```

Running this locally goes fine.

The error GHA gives, however, is:

```
Run ./run_singularity_1.sh
Fatal error: cannot open file 'script.R': No such file or directory
Error: Process completed with exit code 2.
```

# Attempt 2

[Singularity_2](Singularity_2) is a minimal Singularity container,
with a `runscript` section added:

```
Bootstrap: docker
From: r-base

%runscript
exec Rscript "$@"

%post
    Rscript -e 'install.packages("glue")'
```

[build_singularity_2.sh](build_singularity_2.sh) is a simple shell script 
to build a container from [Singularity_2](Singularity_2):

```
#!/bin/bash
sudo -E singularity build singularity_2.sif Singularity_2
```

[run_singularity_2.sh](run_singularity_2.sh) is a simple shell script
to run the container built from [Singularity_2](Singularity_2):

```
#!/bin/bash
singularity exec singularity_2.sif Rscript script.R
```

Running this locally goes fine.

The error GHA gives, however, is:

```
Run ./run_singularity_1.sh
Fatal error: cannot open file 'script.R': No such file or directory
Error: Process completed with exit code 2.
```



