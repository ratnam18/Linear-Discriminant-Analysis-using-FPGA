function [C] = Substaction(A,B)
  [row1 , col1] = size(A);
  C = zeros(row1 , col1);
  for i=1 : row1
    %C(i,i)=0;
    for j=1 : col1
      C(i,j) = A(i,j) - B(i,j);
    end
  end
end
