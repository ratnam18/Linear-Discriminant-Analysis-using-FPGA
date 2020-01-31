function [Y] = Transpose(X)
  [row, col] = size(X);
 
  k = row * col;
  Y = zeros(col, row);
  for i=1:col
    v=1;
    for j=i:col:k
      Y(i,v) = X(v,i);
      v=v+1;
      
    end
  end
end
