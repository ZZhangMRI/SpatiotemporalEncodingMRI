function res = fft2k2r(x,M,N)
%% 
% Do Fourier transform in MRI from k space to space spatial space
% usage:  res = fft2k2r(x);
%         res = fft2k2r(x,M);
%         res = fft2k2r(x,M,N);
% @Zhiyong Zhang, 2016, zhiyongxmu@gmail.com

switch nargin
    case 0
        error('No input found');
    case 1
        res = fftk2r(fftk2r(x,[],1),[],2); 
    case 2
        res = fftk2r(fftk2r(x,M,1),[],2); 
    case 3
        res = fftk2r(fftk2r(x,M,1),N,2); 
    otherwise
        error('Too much inputs');
end
