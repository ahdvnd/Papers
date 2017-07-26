clear
clc

% New Codes

L1=.34; L2=.16; L3=.25; L4=.25; alow=24113; ahigh=78405; hmin=12.48; hlow=14.24; hhigh=15.43;
g1=log(hmin/hlow); g2=log(alow/ahigh); g3=log(hlow/hhigh);
syms s1 s2 s3 a1 a2 a3
a1 = s1;
a2 = 1-s2;
a3 = s3;



[S1, S2, S3]=vpasolve([(s2-s1)*L1*exp(g1*a1)==L2*s1;
    (s3-s2)*L2*exp(g2*a2)==L3*(s2-s1);
    (1-s3)*L3*exp(g3*a3)==L4*(s3-s2)], [s1 s2 s3])


gini=1-(S1*L1+(S1+S2)*L2+(S2+S3)*L3+(S3+1)*L4)



da1 = diff(a1);
da2 = diff(a2);
da3 = diff(a3);
a1S1 = subs(a1, s1, S1);
a2S2 = subs(a2, s2, S2);
a3S3 = subs(a3, s3, S3);
da1S1 = subs(da1, s1, S1);
da2S2 = subs(da2, s2, S2);
da3S3 = subs(da3, s3, S3);

syms dL1 dL2 dL3 dL4
dL2=-dL1;
dL4=-dL3;
A = [L1*exp(g1*a1S1)*(-1+g1*(S2-S1)*da1S1)-L2, L1*exp(g1*a1S1), 0; L3, L2*exp(g2*a2S2)*(-1+(S3-S2)*g2*da2S2)-L3, L2*exp(g2*a2S2); 0, L4, L3*exp(g3*a3S3)*(-1+(1-S3)*g3*da3S3)-L4];
% B = [dS1; dS2; dS3];
C = [S1*dL2-(S2-S1)*exp(g1*a1S1)*dL1; (S2-S1)*dL3-(S3-S2)*exp(g2*a2S2)*dL2; (S3-S2)*dL4-(1-S3)*exp(g3*a3S3)*dL3];
B = inv(A)*C


dGini = - ((dL1+dL2)*S1+(L1+L2)*B(1)+(dL2+dL3)*S2+(L2+L3)*B(2)+(dL3+dL4)*S3+(L3+L4)*B(3)+dL4)

