function [A] = A_k2k(Q,k_source,k_response)
% input:    source : source position of the object
%           response : response position of the aquisition
%           Q : quadratic phase modulation factor, Q = 0 : regular Fourier encoding
%           deltak : K space sampling spacing
%           Nacq : Number of K space sampling

% Output:   A : Transform matrix from reconstruction image space to 

% Example:  A = A_im2im(linspace(-128,128,96+1), linspace(-128/3,128/3,96), 3*96/(2*256^2), 3/256, 96);
% Author: minjiachenrose@gmail.com    3/22/2019


M =length(k_response);
N =length(k_source);
A = zeros(M,N);
deltak=abs(k_source(2)-k_source(1));

for m = 1 : M
    for n =1: N
        if Q==0
            A(m,n)=abs((m==n))*2*N*256;
        else        
            A(m,n) = sum(FTQuadratic(Q,linspace(k_source(n)-k_response(m)-deltak/2,k_source(n)-k_response(m)+deltak/2,256)));
        end
    end
end

end

