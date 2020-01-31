function [u] = Mean(X,k, TOTCLASS)
u = [0.0;0.0];
[row,col] = size(X);
row = k;
for i=1:row
        
  for j=1:TOTCLASS
      u(j,1) = X(i,j)+u(j,1);  
  end
end

u = 1/row*(u);
