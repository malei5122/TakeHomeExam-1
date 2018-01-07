function result = regress(X, Y)
    
    N = size(Y, 1);
    X = [ones(N, 1) X];
    k = size(X, 2);

    % Estimate beta
    b = inv(X' * X) * X' * Y;
    % Residuals
    e = Y - X*b;
    % Estimate the variance-covariance matrix
    s2 = e'*e / (N-k);
    cv = s2 * inv(X'*X);

    % Standard errors
    s = diag(cv).^0.5;

    % t-statistics
    t_stat = b ./ s;

    % Corresponding p-values
    p_value = 2 * (1 - normcdf(abs(t_stat)));
   
    coeffients = b';
    %return the results
    t_statistics = t_stat';
    sterr=s';
    p_values=p_value';
    result=table(coeffients, sterr, t_statistics, p_values);

end

