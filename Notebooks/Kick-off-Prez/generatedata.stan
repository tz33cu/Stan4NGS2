data { 
  int<lower=1> J;                     // Number of groups 
  int<lower=1> Q;                     // Number of group-level predictors 
  int<lower=1> N;                     // Number of individuals 
  int<lower=1> P;                     // Number of individual-level predictors 
  int<lower=1, upper=J> gg[N];        // Grouping 
} 

parameters { 
} 

model { 
} 

generated quantities { 
  matrix<lower=0, upper=2>[N, P] X;   // Individual predictors 
  matrix<lower=0, upper=5>[J, Q] U;   // Group predictors 
  real<lower=0> sigma;                // Observation error 
  matrix[Q, P] gamma;                 // Group-level coefficients 
  matrix[P, J] Z;                     // Z will be used later to build Beta 
  vector<lower=0>[P] tau;             // Prior scale 
  cholesky_factor_corr[P] Omega_chol; // Cholesky decomposition of Omega 
  matrix[J, P] Beta;                  // Individual-level coefficients 
  vector[N] Y;                        // Responses 
  
  sigma = 10;  
  for (p in 1:P) { 
    tau[p] = fabs(cauchy_rng(0,2.5)); 
    for (j in 1:J) 
      Z[p,j] = normal_rng(0, 1); 
    for (n in 1:N) 
      X[n,p] = uniform_rng(0,2); 
    for (q in 1:Q) 
      gamma[q,p] = normal_rng(0, 5); 
  } 
  
  for (j in 1:J) { 
    for (q in 2:Q) 
      U[j,q] = uniform_rng(0,5); 
  } 
  
  X[:,1] = rep_vector(1,N); // Intercept 
  U[:,1] = rep_vector(1,J); // Intercept 
  Omega_chol = lkj_corr_cholesky_rng(P, 2); 
  Beta = U * gamma + (diag_pre_multiply(tau, Omega_chol) * Z)'; 
  
  for (n in 1:N) 
  Y[n] = normal_rng(dot_product(Beta[gg[n]] , X[n]),sigma); 
} 
