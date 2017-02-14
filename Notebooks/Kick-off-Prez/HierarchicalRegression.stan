data { 
  int<lower=1> J; // Number of groups 
  int<lower=1> Q; // Number of group-level predictors 
  int<lower=1> N; // Number of individuals 
  int<lower=1> P; // Number of individual-level predictors 
  int<lower=1, upper=J> gg[N]; // Grouping 
  matrix[N, P] X; // Individual predictors 
  matrix[J, Q] U; // Group predictors 
  vector[N] Y;    // Responses 
} 
 
parameters { 
  real<lower=0> sigma;    // Observation error 
  matrix[Q, P] gamma;     // Group-level coefficients 
  matrix[P, J] Z;         // Z will be used later to build Beta 
  vector<lower=0>[P] tau; // Prior scale 
  cholesky_factor_corr[P] Omega_chol; // Cholesky decomposition of Omega 
} 
 
transformed parameters { 
  matrix[J, P] Beta;  // Individual-level coefficients 
  Beta = U * gamma + (diag_pre_multiply(tau, Omega_chol) * Z)'; 
} 
 
model { 
  tau ~ cauchy(0,2.5); 
  to_vector(Z) ~ normal(0, 1); 
  Omega_chol ~ lkj_corr_cholesky(2); 
  to_vector(gamma) ~ normal(0, 5); 
  Y ~ normal(rows_dot_product(Beta[gg] , X),sigma); 
} 
