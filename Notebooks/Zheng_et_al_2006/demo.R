### simulate data from the prior ###

I <- 200;
K <- 32;

mu_alpha <- 5;  
mu_beta <- -5;
sigma_alpha <- 1;
sigma_beta <- 1;

alpha <- rnorm(I, mu_alpha, sigma_alpha);
beta <- rnorm(K, mu_beta, sigma_beta);

omega_inv <- runif(K, 0.1, 0.95);
omega <- 1 / omega_inv;

y <- array(dim = c(I, K))
for (i in 1:I) {
  for (k in 1:K) {
    xi_i_k <- exp(alpha[i] + beta[k]) / (omega[k] - 1);
    y[i,k] <- rnbinom(1,
                      size = xi_i_k,
                      prob = 1 / omega[k]);
  }
}

### eliminate the zero variance responses ###

var0 <- apply(y, 1, var)
var0 <- which(var0 == 0)
if (length(var0) > 0) {
  y <- y[-var0,]
  alpha <- alpha[- var0]
  I <- nrow(y)
  }

### informative prior hyper-parameter specification ###

mu_beta <- c(beta[1:12], rep(mean(beta[1:12]), K - 12))
sigma_beta <- c(rep(.01, 12), rep(10, K - 12))

data <- list(I = nrow(y), K = ncol(y), mu_beta = mu_beta, sigma_beta = sigma_beta, y = y)

### run the Stan model ###

fit <- stan(file = 'NB_norecall.stan', data = data, warmup = 1000, iter = 2000, 
            chains = 2)
#######################################################################
sims <- extract(fit, permuted = FALSE, inc_warmup = TRUE)
check <- monitor(sims, warmup = floor(dim(sims)[1]/2),
                 probs = c(0.025, 0.25, 0.5, 0.75, 0.975),
                 digits_summary = 1, print = F)


### extract the results and compute summaries of the posterior ###
out <- extract(fit)
alpha_post <- out $ alpha
alpha_hat <- apply(alpha_post, 2, mean)
alpha_lower <- apply(alpha_post, 2, quantile, p = .025)
alpha_upper <- apply(alpha_post, 2, quantile, p = .975)
beta_post <- out $ beta
beta_hat <- apply(beta_post, 2, mean)
beta_lower <- apply(beta_post, 2, quantile, p = .025)
beta_upper <- apply(beta_post, 2, quantile, p = .975)
omega_post <- 1 / out $ inv_omega
omega_hat <- apply(omega_post, 2, mean)
omega_lower <- apply(omega_post, 2, quantile, p = .025)
omega_upper <- apply(omega_post, 2, quantile, p = .975)

### generate the posterior check plots ###

plot(alpha, alpha_hat,ylim=c(min(alpha_lower),max(alpha_upper)), xlab = expression(alpha),
     ylab = expression(hat(alpha)))
for (i in 1:I) lines(c(alpha[i], alpha[i]), c(alpha_lower[i], alpha_upper[i]), col="grey")
points(alpha, alpha_hat, pch=16)
abline(0, 1, col = "red")
plot(beta, beta_hat,ylim=c(min(beta_lower),max(beta_upper)), xlab = expression(beta),
     ylab = expression(hat(beta)))
for (k in 1:K) lines(c(beta[k], beta[k]), c(beta_lower[k], beta_upper[k]), col="grey")
points(beta, beta_hat, pch=16)
abline(0, 1, col = "red")
plot(omega, omega_hat,ylim=c(min(omega_lower),max(omega_upper)), xlab = expression(omega),
     ylab = expression(hat(omega)))
for (k in 1:K) lines(c(omega[k], omega[k]), c(omega_lower[k], omega_upper[k]), col="grey")
points(omega, omega_hat, pch=16)
abline(0, 1, col = "red")

