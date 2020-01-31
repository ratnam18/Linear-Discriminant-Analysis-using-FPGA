function [s1] = Covariance(X,k, u)
  %TOTCLASS=2;
  [row,col] = size(X);
  row = k;
  s1 = [0,0;0,0];
  v = zeros(2,1);
  t = zeros(1,2);
  for i=1:row
    for j=1:col
      v(j) = X(i, j) - u(j);
    end
    t = Transpose(v);
    m = Multiplication(v, t);
    s1 = Addition(m, s1);
  end
  s1 = s1/(row-1);
  
end
