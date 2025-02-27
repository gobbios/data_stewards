<div class="figure" style="text-align: center">
<img src="images/qr-code.png" width="30%" />
</div>



To render the presentations you need [`quarto`](https://quarto.org).


```
quarto render 00_setup.qmd
quarto render 01_main.qmd
quarto render 02_practical.qmd
```

<br />  

<br />  

<br />  


I assume you have some basic R knowledge.

You need a fairly recent R version (say 4.2 or so) and I highly recommend RStudio.

Also, you need the following R packages installed:
  
  - `usethis`

  - `gitcreds`

To check whether your system is ready, do this:

```
source("https://raw.githubusercontent.com/gobbios/data_stewards/refs/heads/main/R/settings_check.R")
settings_check(r_packages = c("usethis", "gitcreds"), min_r = 4.2)
```

These commands download an R script, which contains a simple function.
This function is run and should provide some informative messages relevant to your system setup.

Now at the latest you will know whether you have RStudio and git available.
The existence of `quarto` and `LaTeX` is also checked here but not required for the workshop.

