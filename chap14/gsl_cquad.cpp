// [[Rcpp::depends(RcppGSL)]]
#include <RcppGSL.h>
#include <gsl/gsl_integration.h>
#include <gsl/gsl_randist.h>

struct my_f_params { double y; double mu_all; double s_mu; double s_y; };

double integrand(double x, void *p) {
  struct my_f_params * params = (struct my_f_params *)p;
  double y = params->y;
  double mu_all = params->mu_all;
  double s_mu = params->s_mu;
  double s_y = params->s_y;
  double res = gsl_ran_gaussian_pdf(x-mu_all, s_mu) * gsl_ran_gaussian_pdf(y-x, s_y);
  return(res);
}

// [[Rcpp::export]]
Rcpp::NumericVector f_marginal(Rcpp::NumericVector y, double mu_all, double s_mu, double s_y) {
  Rcpp::NumericVector output(y.size());
  gsl_integration_cquad_workspace *work = gsl_integration_cquad_workspace_alloc(1e2);
  double result(0.0);
  double abserr(0.0);
  size_t nevals(1e2);
  
  gsl_function F;
  F.function = &integrand;
  struct my_f_params params = {y[0], mu_all, s_mu, s_y};
  
  for (int i=0; i < y.size(); ++i) {
    params.y = y[i];
    F.params = &params;
    int res = gsl_integration_cquad(&F, mu_all-6*s_mu, mu_all+6*s_mu, 1e-8, 1e-6, work, &result, &abserr, &nevals);
    output[i] = result;
  }
  gsl_integration_cquad_workspace_free(work);
  return output;
}

// [[Rcpp::export]]
Rcpp::NumericMatrix f_marginal_multi(Rcpp::NumericVector y, Rcpp::NumericVector mu_all, Rcpp::NumericVector s_mu, Rcpp::NumericVector s_y) {
  Rcpp::NumericMatrix output(mu_all.size(), y.size());
  gsl_integration_cquad_workspace *work = gsl_integration_cquad_workspace_alloc(1e2);
  double result(0.0);
  double abserr(0.0);
  size_t nevals(1e2);
  
  gsl_function F;
  F.function = &integrand;
  struct my_f_params params = { y[0], mu_all[0], s_mu[0], s_y[0] };
  
  for (int i=0; i < mu_all.size(); ++i) {
    for (int j=0; j < y.size(); ++j) {
      params.y      = y[j];
      params.mu_all = mu_all[i];
      params.s_mu   = s_mu[i];
      params.s_y    = s_y[i];
      F.params = &params;
      int res = gsl_integration_cquad(&F, mu_all[i]-6*s_mu[i], mu_all[i]+6*s_mu[i], 1e-8, 1e-6, work, &result, &abserr, &nevals);
      output(i,j) = result;
    }
  }
  gsl_integration_cquad_workspace_free(work);
  return(output);
}
