
%Old Codes

clear
clc
%for m=1:49
%L1=0.01*m; L2=0.5-L1; L3=.24; L4=.25; alow=24113; ahigh=78405; hmin=12.48; hlow=14.24; hhigh=15.43;
%g1=log(hmin/hlow); g2=log(alow/hhigh); g3=log(hlow/hhigh);
%syms s1 s2 s3 a1 a2 a3
%a1=s1;
%a2=s2;
%a3=s3;

%[S1, S2, S3]=vpasolve([L2*s1*exp(g1*a1)==(s2-s1)*L1;
%    L3*(s2-s1)*exp(g2*a2)==(s3-s2)*L2;
%    L4*(s3-s2)*exp(g3*a3)==(1-s3)*L3], [s1 s2 s3]);
%m
%gini=1-0.25*(2*S1+2*S2+2*S3+1)
%end



% New Codes




L1=.34; L2=.16; L3=.24; L4=.25; alow=24113; ahigh=78405; hmin=12.48; hlow=14.24; hhigh=15.43;
g1=log(hmin/hlow); g2=log(alow/hhigh); g3=log(hlow/hhigh);
syms s1 s2 s3 a1 a2 a3
a1 = s1;
a2 = s2;
a3 = s3;



[S1, S2, S3]=vpasolve([L2*s1*exp(g1*a1)==(s2-s1)*L1;
    L3*(s2-s1)*exp(g2*a2)==(s3-s2)*L2;
    L4*(s3-s2)*exp(g3*a3)==(1-s3)*L3], [s1 s2 s3])

gini=1-0.25*(2*S1+2*S2+2*S3+1);

da1 = diff(a1);
da2 = diff(a2);
da3 = diff(a3);
a1S1 = subs(a1, s1, S1);
a2S2 = subs(a2, s2, S2);
a3S3 = subs(a3, s3, S3);
da1S1 = subs(da1, s1, S1);
da2S2 = subs(da2, s2, S2);
da3S3 = subs(da3, s3, S3);

syms dL1 dL2 dL3 dL4 dS1 dS2 dS3
dL2=-dL1;
dL4=-dL3;
A = [L2*exp(g1*a1S1)*(1+g1*S1*da1S1)+L1, -L1, 0; -L3*exp(g2*a2S2), L3*exp(g2*a2S2)*(1+(S2-S1)*g2*da2S2)+L2, -L2; 0, -L4*exp(g3*a3S3), L4*exp(g3*a3S3)*(1+(S3-S2)*g3*da3S3)+L3];
B = [dS1; dS2; dS3];
C = [(S2-S1)*dL1-S1*exp(g1*a1S1)*dL2; (S3-S2)*dL2-(S2-S1)*exp(g2*a2S2)*dL3; (1-S3)*dL3-(S3-S2)*exp(g3*a3S3)*dL4];
B = inv(A)*C
dGini = -0.5*sum(B)



