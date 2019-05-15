function [A] = A_im2im(source,response,Q,deltak,Nacq)
% input:    source : source position of the object
%           response : response position of the aquisition
%           Q : quadratic phase modulation factor, Q = 0 : regular Fourier encoding
%           deltak : K space sampling spacing
%           Nacq : Number of K space sampling

% Output:   A : Transform matrix from reconstruction image space to 

% Example:  A = A_im2im(linspace(-128,128,96+1), linspace(-128/3,128/3,96), 3*96/(2*256^2), 3/256, 96);
% Author: minjiachenrose@gmail.com    3/22/2019


M = length(response);
N =length(source)-1;
A = zeros(M,N);

for m = 1 : M
    for n =1: N
        A(m,n) = sum(PSF_SPEN(linspace(source(n),source(n+1),256),response(m),deltak,Nacq,Q));
    end
end


end

