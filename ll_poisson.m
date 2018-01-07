function ll = ll_poisson(beta, Y, X, sum_ll)

lambda = exp(X * beta);

ll = Y .* log(lambda) - log(factorial(Y)) - lambda;

ll = -ll; 

if sum_ll == true
    ll = sum(ll);
end

end
