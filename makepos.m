function result = makepos(K)
pd = 0;
addc = 10e-7;
while (pd ==  0)
 
addc = addc * 10
try
if (isinf(addc) == 1)
pd = 1;
else 
chol(normalizekm(K + eye(size(K,1),size(K,1)) * addc));
pd = 1;
end
catch

end

end
if (isinf(addc)==0)
result = K + eye(size(K,1),size(K,1)) * addc;
else
result = eye(size(K,1));
end
end
