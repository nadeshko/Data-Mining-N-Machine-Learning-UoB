clear

W = load('WDM');
[U,S,V] = svd(W);

sV1 = V(:,1);
sV2 = V(:,2);
sV3 = V(:,3);
[m1,am1] = mink(sV1,3)
[m2,am2] = mink(sV2,3)
[m3,am3] = mink(sV3,3)

