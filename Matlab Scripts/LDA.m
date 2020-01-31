function [w] = LDA()


TOTCLASS = 2;
%{
%sample for class 1:
X1 = [4, 2;
      2, 4;
      2, 3;
      3, 6;
      4, 4];
%sample for class 2:
X2 = [9, 10;
      6, 8;
      9, 5;
      8, 7;
      10, 8];
  %}



%I=imread('C:\Users\Hardi\Desktop\Project-(LA_SS_CO)\Inputs\image.png');
%M=im2bw(I)




M =[ 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;   
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1];
k1=0;
k2=0;
[m,n]=size(M);
X1=zeros(1024,2);
X2=zeros(1024,2);
for i=1:m
    for j=1:n
        if(M(i,j)==0)
          k1=k1+1;
          X1(k1,1)=i;
          X1(k1,2)=j;
        end
        
         if(M(i,j)==1)
          k2=k2+1;
          X2(k2,1)=i;
          X2(k2,2)=j;
          
        end
    end
end

[~, ~] = size(X1);
[~, ~] = size(X2);
%disp('Mean of classes:');

u1 = Mean(X1,k1, TOTCLASS);
u2 = Mean(X2,k2, TOTCLASS);

% disp("u1..");
% disp(u1);
% disp("u2..");
% disp(u2);

% disp('Covarience of classes:');

s1 = Covariance(X1,k1,u1);
s2 = Covariance(X2,k2,u2);

% disp("s1..");
% disp(s1);
% disp("s2..");
% disp(s2);   

sw = Addition(s1,s2);

% disp("Within Class - sw..");
% disp(sw);   

sb1 = Substaction(u1, u2);
sb2 = Transpose(sb1);
sb = Multiplication(sb1,sb2);

% disp("Between Class - sb..");
% disp(sb);

swi = Inverse(sw);

% disp("Inverse of sw..");
% disp(swi);

swisb = Multiplication(swi, sb);

% disp("swisb..");
% disp(swisb);

[V, ~] = eigen(swisb);
% disp("D......")
% disp(D)
% disp("V......")
% disp(V)

w = V(:,1);
[r,~] = size(w);

squar=0;
for i=1:r
  squar = squar + (w(i)*w(i));
  %disp(squar);
end
squarroot = sqrt(squar);

% disp(squar);
% disp(squarroot);

for i=1:r
  w(i) = w(i)/squarroot;
end

%meanDiff = Substaction(u1,u2);
%w1 = Multiplication(swi,temp);
%w1=[0.9088;0.4173];

% disp("Most impoert eigenVector")
% disp(w)



%{


%disp("other")
%disp(w1)
%w2=[0.9088;0.4173]
%wsmall = [-0.5755;0.8178]

title("LDA projection with highest eigen value");
%{
scatter(X1(:,1),X1(:,2),100,'filled')
hold on
scatter(X2(:,1),X2(:,2),100,'filled')
hold on

title("LDA");
xlabel("X-axis")
ylabel("y-axis")
%}

%legend("X1","X2") ;
%plot(w,'r')
%hold on

%plot(w,'b')

%hold on
%plot(w2,'g')
%hold on
%plot(wsmall,'y')


[r,c]=size(w);

k=1;
for i=1:row1
  
  Xn(k)=0;
  
  %for j=1:r
    Xn(k) =Multiplication(X1(i,:), w);
  %end
  hold on
  %scatter(Xn(k),Xn(k),'g')
  k=k+1;
end

for i=1:row2
  Xn(k)=0;
  %for j=1:r
    Xn(k) = Multiplication(X2(i,:), w);
  %end
  %scatter(Xn(k),Xn(k),'k')
  k=k+1;
end

%plot(Xn,Xn);
scatter(Xn(1:row1),Xn(1:row1)*[0],100,'g');

scatter(Xn(row1+1:row1+row2),Xn(row1+1:row1+row2)*[0],100,'k');
%legend("X1","X2","LDA","X1-projection","X2-projection")
legend("X1-projection","X2-projection")


%}