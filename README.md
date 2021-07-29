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

# First attempt

[Singularity_1](Singularity_1) is a minimal Singularity container:

```
Bootstrap: docker
From: r-base

%post
    Rscript -e 'install.packages("glue")'
```



