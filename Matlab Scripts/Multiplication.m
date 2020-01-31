function [C] = Multiplication(A, B)
  [row1 , col1] = size(A);
  [row2 , col2] = size(B);
  
  C = zeros(row1,col2);
  
  for i=1 : row1
    for j=1 : col2
      C(i,j) = 0;
      for k=1 : row2
        C(i,j) = (A(i,k) * B(k,j)) + C(i,j);
      end
    end
  end
end
