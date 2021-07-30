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

# Attempt 1: Singularity does not run scripts

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

This is a common theme: Singularity cannot run scripts.

# Attempt 2: Singularity can run script text

[Singularity_2](Singularity_2) is a minimal Singularity container,
with a `runscript` section added:

```
Bootstrap: docker
From: r-base

%apprun R
exec R "$@"

%apprun Rscript
exec Rscript "$@"

%runscript
exec Rscript "$@"
# exec R "$@"

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
cat script.R | singularity exec singularity_2.sif R --vanilla --silent --no-echo
```

Running this locally goes fine, also on GitHub Actions!

# Attempt 3: clean up

[Singularity_3](Singularity_3) is a minimal Singularity container,
with a `runscript` section added:

```
Bootstrap: docker
From: r-base

%runscript
exec R --vanilla --silent --no-echo "$@"

%post
    Rscript -e 'install.packages("glue")'
```

[build_singularity_3.sh](build_singularity_3.sh) is a simple shell script 
to build a container from [Singularity_3](Singularity_3):

```
#!/bin/bash
sudo -E singularity build singularity_3.sif Singularity_3
```

[run_singularity_3.sh](run_singularity_3.sh) is a simple shell script
to run the container built from [Singularity_3](Singularity_3):

```
#!/bin/bash
cat script.R | ./singularity_3.sif
```

Running this locally goes fine, also on GitHub Actions!

# Attempt 4: fakeroot experiment

In this case, we'll re-use [Singularity_3](Singularity_3),
yet build it differently.

[build_singularity_4.sh](build_singularity_4.sh) is a simple shell script 
to build a container from [Singularity_3](Singularity_3):

```
#!/bin/bash
singularity build --fakeroot singularity_4.sif Singularity_3
```

[run_singularity_4.sh](run_singularity_4.sh) is a simple shell script
to run the container built from [Singularity_4](Singularity_4):

```
#!/bin/bash
cat script.R | ./singularity_4.sif
```

Running this locally goes fine, also on GitHub Actions!



# Attempt 5: run script directly revised


