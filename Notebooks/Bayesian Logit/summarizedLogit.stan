data {
  
  int<lower=0> N; // Number of observations (an integer)
  int<lower=0> p; // Number of parameters
  int decision[N];
  int<lower=0>  round_num[N];
  int<lower=0>  fluid_dummy[N];
}

parameters {
  // Define parameters to estimate
  real beta[p];
}

model {

  decision ~ bernoulli_logit(beta[1] + beta[2]*fluid_dummy + beta[3]*round_num +   beta[4]*round_num*fluid_dummy)
  
}