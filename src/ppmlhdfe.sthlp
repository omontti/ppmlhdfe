{smcl}
{* *! version 2.0.1 03mar2019}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[R] xtpoisson" "help xtpoisson"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "reghdfe" "help reghdfe"}{...}
{vieweralsosee "ppml" "help ppml"}{...}
{vieweralsosee "poi2hdfe" "help poi2hdfe"}{...}
{vieweralsosee "ppml_panel_sg" "help ppml_panel_sg"}{...}
{vieweralsosee "xtpqml" "help xtpqml"}{...}
{viewerjumpto "Syntax" "ppmlhdfe##syntax"}{...}
{viewerjumpto "Description" "ppmlhdfe##description"}{...}
{viewerjumpto "absorb() Syntax" "ppmlhdfe##absvar"}{...}
{viewerjumpto "Advanced options" "ppmlhdfe##secret"}{...}
{viewerjumpto "Postestimation Syntax" "ppmlhdfe##postestimation"}{...}
{viewerjumpto "Citation" "ppmlhdfe##citation"}{...}
{viewerjumpto "Authors" "ppmlhdfe##contact"}{...}
{viewerjumpto "Acknowledgements" "ppmlhdfe##acknowledgements"}{...}
{viewerjumpto "Support and updates" "ppmlhdfe##support"}{...}
{viewerjumpto "Stored results" "ppmlhdfe##results"}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:ppmlhdfe} {hline 2}}Poisson pseudo-likelihood regression with multiple levels of fixed effects{p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 15 2} {cmd:ppmlhdfe}
{depvar} [{indepvars}]
{ifin} {it:{weight}} {cmd:,} [{opth a:bsorb(ppmlhdfe##absvar:absvars)}] [{help ppmlhdfe##options:options}] {p_end}

{marker opt_summary}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth a:bsorb(ppmlhdfe##absvar:absvars)}}categorical variables to be absorbed (fixed effects); individual slopes are also allowed{p_end}
{synopt: {cmdab:a:bsorb(}{it:...}{cmd:,} {cmdab:save:fe)}}save all fixed effect estimates with {it:__hdfe} as prefix{p_end}
{synopt :{opth exp:osure(varname)}}include ln({it:varname}) in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt : {opth d(newvar)}}save sum of fixed effects as {it:newvar}; mandatory if running {it:predict} afterwards (except for {it:predict,xb}){p_end}
{synopt : {opt d}}as above, but variable will be saved as {it:_ppmlhdfe_d}{p_end}

{synopt :{opth sep:aration(string)}}algorithm used to drop 
{browse "http://scorreia.com/research/singletons.pdf":separated} observations and their associated regressors.
Valid options are {it:fe}, {it:ir}, {it:simplex}, and {it:mu} (or any combination of those).
Although {it:ir} (iterated rectifier) is the only one that can systematically correct separation arising from both regressors and fixed effects, by default the first three methods are applied ({it: fe simplex ir}).
See the {browse "http://scorreia.com/research/singletons.pdf":ppmlhdfe paper} as well as {browse "https://github.com/sergiocorreia/ppmlhdfe/blob/master/guides/separation_primer.md":this guide} for more information.{p_end}

{syntab:SE/Robust}
{synopt:{opt vce}{cmd:(}{help ppmlhdfe##opt_vce:vcetype}{cmd:)}}{it:vcetype}
may be {opt r:obust} (default) or {opt cl:uster} {help fvvarlist} (allowing two- and multi-way clustering){p_end}

{syntab:Reporting}
{synopt:{opt ef:orm}}report exponentiated coefficients (incidence-rate ratios){p_end}
{synopt :{opt ir:r}}synonym for {opt ef:orm}{p_end}
{synopt :{it:{help estimation_options:display_options}}}control many options of the regression table,
such as confidence levels, number formats, etc.{p_end}

{syntab:Optimization}
{synopt:{opth tol:erance(#)}}criterion for convergence (default: 1e-8){p_end}
{synopt:{opth guess(string)}}set rule for setting initial values; valid options are {it:simple} (default, almost always faster) and {it:ols}{p_end}

{syntab:Diagnostic and undocumented}
{synopt :{opt v:erbose(#)}}amount of debugging information to show; use {it:v(1)} or higher to view additional information;
secret option: {it:v(-1)} disables all messages{p_end}
{synopt :[{cmdab:no:}]{opt lo:g}}hide iteration log{p_end}
{synopt :{opt keepsin:gletons}}do not drop singleton groups{p_end}
{synopt :{opt version:}}reports the version number and date of ppmlhdfe, and the list of required packages. standalone option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{help tsvarlist:time-series operators} and {help fvvarlist:factor variables} are allowed;
the dependent variable cannot be of the form {it:i.turn}, but {it:42.turn} works{p_end}
{p 4 6 2}{cmd:fweight}s and {cmd:pweight}s are allowed; see {help weight}.{p_end}



{marker description}{...}
{title:Description}

{pstd}{cmd:ppmlhdfe} implements Poisson pseudo-maximum likelihood regressions (PPML) with multi-way fixed effects,
as described by {browse "http://scorreia.com/research/ppmlhdfe.pdf":Correia, Guimarães, Zylkin (2019a)}.
The estimator employed is robust to statistical separation and convergence issues, due to the procedures developed in {browse "http://scorreia.com/research/separation.pdf":Correia, Guimarães, Zylkin (2019b)}.

{pstd}This package has four key advantages:

{pmore} 1. Allows any number and combination of fixed effects and individual slopes.{p_end}

{pmore} 2. Correctly detects and drops separated observations ({browse "http://scorreia.com/research/separation.pdf":Correia, Guimarães, Zylkin 2019b}).
This issue would be otherwise particularly pernicious in regressions with many fixed effects, and can lead to lack of convergence,
or even worse, incorrect estimates.{p_end}

{pmore} 3. Allows two- and multi-way clustering, and can be used in combination with {browse "https://ideas.repec.org/c/boc/bocode/s458121.html":boottest} to derive wild bootstrap inference.{p_end}

{pmore} 4. Includes several algorithmic shortcuts and accelerations aimed at allowing its use with very large datasets.{p_end}



{title:Background}

{pstd}PPML models are particularly useful in models with positive count (and {browse "https://doi.org/10.1515/jem-2015-0022":non-count}) outcome variables, where
otherwise applying least-squares regressions on outcome variables of the form {it:log(y)} would lead to {browse "https://www.mitpressjournals.org/doi/abs/10.1162/rest.88.4.641":inconsistent estimates} in the presence of heteroskedasticity.

{pstd}These models are thus important in trade economics (where common outcomes include {it:log(exports)}), labor economics ({it:log wage}),
finance ({it:log credit}, {it:log sales}, etc.), innovation ({it:log patents}), etc.
Further, they alleviate the issue of dealings with zero-outcomes variables (as log(0) is minus infinity), and allow applied economists to jointly estimate effects at the intensive and extensive margins.



{marker absvar}{...}
{title:Syntax for absorbed variables}

{synoptset 22}{...}
{synopthdr:absvar}
{synoptline}
{synopt:{it:varname}}categorical variable to be absorbed (fixed effect){p_end}
{synopt:{cmd:i.}{it:varname}}same as above; the {cmd:i.} prefix is always tacit{p_end}
{synopt:{cmd:i.}{it:var1}{cmd:#i.}{it:var2}}absorb pairwise combinations of two or more categorical variables (e.g. country-time fixed effects){p_end}
{synopt:{cmd:i.}{it:var1}{cmd:##}{cmd:c.}{it:var2}}absorb fixed effects and
{browse "https://www.stata.com/meeting/germany10/germany10_ludwig.pdf":individual slopes} (e.g. "i.country##c.time" includes country FEs and different time trend per country){p_end}
{synopt:{cmd:i.}{it:var1}{cmd:#}{cmd:c.}{it:var2}}only absorbs individual slopes
(advice: never run "i.id i.id#c.z", as it is slower and less accurate that running "i.id##c.z"){p_end}
{synopt:{it:var1}{cmd:##c.(}{it:var2 var3}{cmd:)}}multiple heterogeneous slopes are allowed together. Alternative syntax: {it:var1}{cmd:##(c.}{it:var2} {cmd:c.}{it:var3}{cmd:)}{p_end}
{synopt:{it:v1}{cmd:#}{it:v2}{cmd:#}{it:v3}{cmd:##c.(}{it:v4 v5}{cmd:)}}factor operators can be combined{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}- To save the estimates specific absvars, write {newvar}{inp:={it:absvar}}.{p_end}
{p 4 6 2}-  However, be aware that estimates for the fixed effects are generally inconsistent and not econometrically identified.{p_end}
{p 4 6 2}- Using categorical interactions (e.g. {it:x}{cmd:#}{it:z}) is faster than running {it:egen group(...)} beforehand.{p_end}
{p 4 6 2}- {browse "http://scorreia.com/research/singletons.pdf":Singleton observations} are dropped iteratively until no more singletons are found (see linked article for details).{p_end}



{marker secret}{...}
{title:Advanced options}

{pstd}You can use all of the {help reghdfe##opt_optimization:reghdfe optimization options}.
Particularly useful are {opth itol(#)} to set the tolerance used when partialling out fixed effects,
as well as the {cmd:accel()}, {cmd:transform()}, and {cmd:prune} options to modify the partialling out method.

{pstd}You can also modify the parameters used internally for the IRLS iteration and for each separation method.
For instance, {cmd:standardize_data(0)} will disable the standardization of variables (done to increase numerical accuracy),
while {cmd:use_exact_solver(1)} will run avoid using a faster version of the least squares solver on the initial IRLS iterations.

{pstd}More information is available {browse "https://github.com/sergiocorreia/ppmlhdfe/blob/master/guides/separation_primer.md":here}.


{marker caveats}{...}
{title:Caveats}

{pstd}Convergence is decided based on the deviance (and thus log-likelihood), not coefficients or residuals. Thus, we declare convergence once relative changes of the deviance fall below {opth tol:erance(#)}.

{pstd}Note that although continuing to iterate further should not improve the overall fit of the model, it could improve the quality of e.g. fixed effect estimates. For an example of this, see {browse "https://github.com/sergiocorreia/ppmlhdfe/blob/master/guides/misc/relative_tolerance.do":this do-file}.


{marker postestimation}{...}
{title:Postestimation Syntax}

{pstd}The {help glm postestimation##predict:predict}, {help test}, and {help margins} postestimation commands are available after {cmd:ppmlhdfe}.

{pstd}Also the three standard {help estat} subcommands are allowed: {cmd:estat ic}, {cmd:estat summarize}, and {cmd:estat vce}.



{marker contact}{...}
{title:Authors}

{pstd}Sergio Correia{break}
Board of Governors of the Federal Reserve{break}
Email: {browse "mailto:sergio.correia@gmail.com":sergio.correia@gmail.com}
{p_end}

{pstd}Paulo Guimarães{break}
Banco de Portugal, Portugal{break}
Email: {browse "mailto:pguimaraes2001@gmail.com":pguimaraes2001@gmail.com}
{p_end}

{pstd}Thomas Zylkin{break}
Economics Department
Robins School of Business, University of Richmond{break}
Email: {browse "mailto:tzylkin@richmond.edu":tzylkin@richmond.edu}
{p_end}



{marker citation}{...}
{title:Citation}

{pstd}
Correia, S., P. Guimaraes, and T. Zylkin. 2019a.
{browse "http://scorreia.com/research/separation.pdf":Verifying the Existence of Maximum Likelihood Estimates for Generalized Linear Models}.
Working paper.

{pstd}
Correia, S., P. Guimaraes, and T. Zylkin. 2019b.
{browse "http://scorreia.com/research/ppmlhdfe.pdf":ppmlhdfe: Fast Poisson Estimation with High-Dimensional Fixed Effects}.
Working paper.


{marker acknowledgements}{...}
{title:Acknowledgements}

{pstd}[TBD]


{marker support}{...}
{title:Support and updates}

{pstd}{cmd:ppmlhdfe} requires the {cmd:reghdfe} and {cmd:ftools} packages.

{pstd}To see your current version, and to see the installed dependencies, type {cmd:ppmlhdfe, version}

{pstd}To download the latest version, to report report any issues, or for additional support, please see the {browse "https://github.com/sergiocorreia/ppmlhdfe":Github repo} of the project.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ppmlhdfe} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{syntab:Scalars}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(num_singletons)}}number of dropped singleton observations{p_end}
{synopt:{cmd:e(num_separated)}}number of dropped separated observations{p_end}
{synopt:{cmd:e(N_full)}}number of observations, including dropped singleton and separated observations{p_end}
{synopt:{cmd:e(drop_singletons)}}whether singleton observations were searched for and dropped or not{p_end}

{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(df)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_a)}}degrees of freedom lost due to the fixed effects{p_end}
{synopt:{cmd:e(df_a_initial)}}number of categories in the fixed effects; same as e(df_a) but ignoring redundant categories{p_end}
{synopt:{cmd:e(df_a_redundant)}}number of redundant fixed effect categories{p_end}

{synopt:{cmd:e(N_hdfe)}}number of absorbed fixed-effects{p_end}
{synopt:{cmd:e(N_hdfe_extended)}}number of absorbed fixed-effects plus fixed-slopes{p_end}

{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log-likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log-likelihood of fixed-effect-only regression{p_end}

{synopt:{cmd:e(N_clustervars)}}number of cluster variables; if {cmd:vce()} is set to use clustered standard errors{p_end}
{synopt:{cmd:e(N_clust}#{cmd:)}}number of clusters in the #th cluster variable{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters; minimum of all the {it:e(clust#)}{p_end}

{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(ic2)}}number of iterations when partialling-out fixed effects{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 24 tabbed}{...}
{syntab:Macros}
{synopt:{cmd:e(cmd)}}{cmd:ppmlhdfe}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(separation)}}list methods used to detect and drop separated observations: {cmd:fe}, {cmd:simplex}, {cmd:ir}, and {cmd:mu}{p_end}
{synopt:{cmd:e(dofmethod)}}dofmethod employed in the regression{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(indepvars)}}names of independent variables{p_end}
{synopt:{cmd:e(absvars)}}name of the absorbed variables or interactions{p_end}
{synopt:{cmd:e(extended_absvars)}}expanded absorbed variables or interactions{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(clustvar}#{cmd:)}}name of the #th cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}{cmd:ppmlhdfe_p}; program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(estat_cmd)}}{cmd:reghdfe_estat}; program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(footnote)}}{cmd:reghdfe_footnote}; program used to display the degrees-of-freedom table{p_end}

{synoptset 24 tabbed}{...}
{syntab:Matrices}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(dof_table)}}number of categories, redundant categories, and degrees-of-freedom absorbed by each set of fixed effects{p_end}

{synoptset 24 tabbed}{...}
{syntab:Functions}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}

