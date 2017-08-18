data {
  
  int<lower=0> N; // Number of observations (an integer)
  int<lower=0> p; // Number of parameters
  // Variables
  int decision[N];
  int<lower=0>  round_num[N];
  int<lower=0>  fluid_dummy[N];
}

parameters {
  // Define parameters to estimate
  real beta[p];
}

transformed parameters  {
  // Probability trasformation from linear predictor
  real<lower=0> odds[N];
  real<lower=0, upper=1> prob[N];
  
  for (i in 1:N) {
    odds[i] = exp(beta[1] + beta[2]*fluid_dummy[i] + beta[3]*round_num[i] +   beta[4]*round_num[i]*fluid_dummy[i]);
    prob[i] = odds[i] / (odds[i] + 1);
  }
}

model {
  // Prior part of Bayesian inference (flat if unspecified)
  
  // Likelihood part of Bayesian inference
  decision ~ bernoulli(prob);
}