function [V, D] = eigen(A)
  a = 1;
  b = (-1)*(A(1,1)+A(2,2));
  c = (A(1,1)*A(2,2) - A(1,2)*A(2,1));

  D = zeros(2,2);
  V = zeros(2,2);
  
  d = (b*b) - (4*a*c);
 
  d = sqrt(d);

  if (d>0)
    
    root1 = ((-1*b) + (d)) / (2*a);
    root2 = ((-1*b) - (d)) / (2*a);
  else
   
    root1 = (-1*b) / (2*a);
    root2 = root1;
  end


  D(1,1) = root1;
  D(1,2) = 0;
  D(2,1) = 0;
  D(2,2) = root2;
  
  V(:,1) = eigenVector(A, D(1,1));
  V(:,2) = eigenVector(A, D(2,2));

end