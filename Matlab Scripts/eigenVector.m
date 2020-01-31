function [w] = eigenVector(A, lemda)
%  A=[6.0118         0;
%          0         0];
%  
%   lemda=6.0118;
  w = zeros(1,2);
  A(1,1) = A(1,1) - lemda;
  A(2,2) = A(2,2) - lemda;

  if A(1,1)==0
      A(2,:)=A(2,:)/A(2,2);
     w(1) = A(2,2);
     w(2) = (-1)*A(2,1); 
  else
    A(1,:) = A(1,:) / A(1,1);
     w(1) = (-1)*A(1,2);
     w(2) = A(1,1);
  end
  
 
  
end
