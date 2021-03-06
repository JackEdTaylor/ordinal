\name{clmm}
\alias{clmm}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Cumulative Link Mixed Models
}
\description{
  Fits Cumulative Link Mixed Models with one or more random effects via
  the Laplace approximation or quadrature methods
}
\usage{
clmm(formula, data, weights, start, subset, na.action, contrasts, Hess =
TRUE, model = TRUE, link = c("logit", "probit", "cloglog", "loglog",
"cauchit"), doFit = TRUE, control = list(), nAGQ = 1L,
threshold = c("flexible", "symmetric", "symmetric2", "equidistant"), ...)

%% also document getNLA(rho, par) here and include examples
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula}{
    a two-sided linear formula object describing the fixed-effects part
    of the model, with the response on the left of a ~ operator and the
    terms, separated by + operators, on the right. The vertical bar
    character "|" separates an expression for a model matrix and a
    grouping factor.
  }
  \item{data}{
    an optional data frame in which to interpret the variables occurring
    in the formula.
  }
  \item{weights}{
    optional case weights in fitting. Defaults to 1.
  }
  \item{start}{
    optional initial values for the parameters in the format
    \code{c(alpha, beta, tau)}, where \code{alpha} are the threshold
    parameters, \code{beta} are the fixed regression parameters and
    \code{tau} are variance parameters for the random effects on the log
    scale.
  }
  \item{subset}{
    expression saying which subset of the rows of the data should  be
    used in the fit. All observations are included by default.
  }
  \item{na.action}{
    a function to filter missing data.
  }
  \item{contrasts}{
    a list of contrasts to be used for some or all of
    the factors appearing as variables in the model formula.
  }
  \item{Hess}{
    logical for whether the Hessian (the inverse of the observed
    information matrix)
    should be computed.
    Use \code{Hess = TRUE} if you intend to call \code{summary} or
    \code{vcov} on the fit and \code{Hess = FALSE} in all other instances
    to save computing time.
  }
  \item{model}{
    logical for whether the model frames should be part of the returned
    object.
  }
  \item{link}{
    link function, i.e. the type of location-scale distribution
    assumed for the latent distribution. The default \code{"logit"} link
    gives the proportional odds mixed model.
  }
  \item{doFit}{
    logical for whether the model should be fit or the model
    environment should be returned.
  }
  \item{control}{
    a call to \code{\link{clmm.control}}
  }
  \item{nAGQ}{
    integer; the number of quadrature points to use in the adaptive
    Gauss-Hermite quadrature approximation to the likelihood
    function. The default (\code{1}) gives the Laplace
    approximation. Higher values generally provide higher precision at
    the expense of longer computation times, and
    values between 5 and 10 generally provide accurate maximum
    likelihood estimates. Negative values give the non-adaptive
    Gauss-Hermite quadrature approximation, which is generally faster
    but less
    accurate than the adaptive version. See the references for further
    details. Quadrature methods are only available with a single random
    effects term; the Laplace approximation is always available.
  }
  \item{threshold}{
    specifies a potential structure for the thresholds
    (cut-points). \code{"flexible"} provides the standard unstructured
    thresholds, \code{"symmetric"} restricts the distance between the
    thresholds to be symmetric around the central one or two thresholds
    for odd or equal numbers or thresholds respectively,
    \code{"symmetric2"} restricts the latent
    mean in the reference group to zero; this means that the central
    threshold (even no. response levels) is zero or that the two central
    thresholds are equal apart from their sign (uneven no. response
    levels), and
    \code{"equidistant"} restricts the distance between consecutive
    thresholds to be of the same size.
  }
  \item{\dots}{
    additional arguments are passed on to \code{\link{clm.control}}.
  }
}
\details{
  This is a new (as of August 2011) improved implementation of CLMMs. The
  old implementation is available in \code{\link{clmm2}}. Some features
  are not yet available in \code{clmm}; for instance
  scale effects, nominal effects and flexible link functions are
  currently only  available in \code{clmm2}. \code{clmm} is expected to
  take over \code{clmm2} at some point.

  There are standard print, summary and anova methods implemented for
  \code{"clmm"} objects.
}
\value{ a list containing
  \item{alpha}{threshold parameters.}
  \item{beta}{fixed effect regression parameters.}
  \item{stDev}{standard deviation of the random effect terms.}
  \item{tau}{\code{log(stDev)} - the scale at which the log-likelihood
    function is optimized.}
  \item{coefficients}{the estimated model parameters = \code{c(alpha,
      beta, tau)}.}
  \item{control}{List of control parameters as generated by \code{\link{clm.control}}.
  }
  \item{Hessian}{Hessian of the model coefficients.}
  \item{edf}{the estimated degrees of freedom used by the model =
    \code{length(coefficients)}.}
  \item{nobs}{\code{sum(weights)}.}
  \item{n}{length(y).}
  \item{fitted.values}{fitted values evaluated with the random effects
    at their conditional modes.}
  \item{df.residual}{residual degrees of freedom; \code{length(y) -
      sum(weights)}}
  \item{tJac}{Jacobian of the threshold function corresponding to the
    mapping from standard flexible thresholds to those used in the
    model.}
  \item{terms}{the terms object for the fixed effects.}
  \item{contrasts}{contrasts applied to the fixed model terms.}
  \item{na.action}{the function used to filter missing data.}
  \item{call}{the matched call.}
  \item{logLik}{value of the log-likelihood function for the model at
    the optimum.}
  \item{Niter}{number of Newton iterations in the inner loop update of
    the conditional modes of the random effects.}
  \item{optRes}{list of results from the optimizer.}
  \item{ranef}{list of the conditional modes of the random effects.}
  \item{condVar}{list of the conditional variance of the random effects
    at their conditional modes.}

}
%% \references{ bla
%% %% ~put references to the literature/web site here ~
%% }
\author{
  Rune Haubo B Christensen
}
\examples{

## Cumulative link model with one random term:	
fmm1 <- clmm(rating ~ temp + contact + (1|judge), data = wine)	
summary(fmm1)	
	
\dontrun{ 	
## May take a couple of seconds to run this.	

## Cumulative link mixed model with two random terms:
mm1 <- clmm(SURENESS ~ PROD + (1|RESP) + (1|RESP:PROD), data = soup,
            link = "probit", threshold = "equidistant")
mm1
summary(mm1)

## test random effect:
mm2 <- clmm(SURENESS ~ PROD + (1|RESP), data = soup,
            link = "probit", threshold = "equidistant")
anova(mm1, mm2)
}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{models}

