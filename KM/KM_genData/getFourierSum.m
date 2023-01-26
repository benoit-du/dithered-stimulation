function out = getFourierSum(a0,a,b,x)

% assert(length(a) == length(b),'a and b should be the same length')
n = length(a);

inds = 1:n;

cosSum = sum(a(:)'.*cos(inds.*x(:)),2);
sinSum = sum(b(:)'.*sin(inds.*x(:)),2);

out = a0/2 + cosSum + sinSum;
    
end