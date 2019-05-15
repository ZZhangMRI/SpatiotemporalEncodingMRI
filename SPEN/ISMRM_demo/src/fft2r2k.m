function res = fft2r2k(x,M,N)
%% 
% Do Fourier transform in MRI from spatial to space k space
% usage:  res = fft2r2k(x);
%         res = fft2r2k(x,M);
%         res = fft2r2k(x,M,N);
% @Zhiyong Zhang, 2016, zhiyongxmu@gmail.com

switch nargin
    case 0
        error('No input found');
    case 1
        res = fftr2k(fftr2k(x,[],1),[],2); 
    case 2
        res = fftr2k(fftr2k(x,M,1),[],2); 
    case 3
        res = fftr2k(fftr2k(x,M,1),N,2); 
    otherwise
        error('Too much inputs');
end
