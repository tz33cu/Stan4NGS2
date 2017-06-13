data {             
  int<lower=0> I;                        // # respondents
  int<lower=0> K;                        // # subpopulations
  vector[K] mu_beta;                     // prior mean of beta
  vector<lower=0>[K] sigma_beta;         // prior variance of beta
  int  y[I,K];                           // # known by respondent i in subpopulation k
  }

parameters {
  vector[I] alpha;                       // log degree
  vector[K] beta;                        // log prevalence of group in population
  vector<lower = 0 , upper = 1>[K] inv_omega;  // ineverse overdispersion; implies the uniform prior 
  real mu_alpha;                         // prior mean for alpha
  real<lower=0> sigma_alpha;             // prior scale for alpha
  }

model {
// priors
  alpha ~ normal(mu_alpha, sigma_alpha);  
  beta ~ normal(mu_beta, sigma_beta);     // informative prior on beta: location and scale are identified             

// hyperpriors
  mu_alpha ~ normal(0,25);                // weakly informative (no prior in paper)
  sigma_alpha ~ normal(0,5);              // weakly informative (no prior in paper)


  for (k in 1:K) {
    real omega_k_m1;
    omega_k_m1 <- inv(inv(inv_omega[k]) - 1) ;
    for (i in 1:I) {
      real xi_i_k;
      xi_i_k <- omega_k_m1 * exp(alpha[i] + beta[k])  ;
      y[i,k] ~ neg_binomial(xi_i_k, omega_k_m1);             
      }
    }
  }
