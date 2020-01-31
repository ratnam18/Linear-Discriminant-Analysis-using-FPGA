% inverse for 2*2 matrix

function [A] = Inverse(A)
  [row,col] = size(A);
  
  temp = A(1,1);
  A(1,1) = A(2,2);
  A(2,2) = temp;
  
  A(1,2) = (-1)*A(1,2);
  A(2,1) = (-1)*A(2,1);
  
  d = A(1,1)*A(2,2) - A(1,2)*A(2,1);
  A = A/d;
  
end