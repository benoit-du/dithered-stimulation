function out = uniRand(a,b,n,m)

%%% 14-07-21    option for matrix output

range = b - a;

if nargin>2
    out = rand(n,m)*range + a;
else
    out = rand(1,1)*range + a;
end

end
