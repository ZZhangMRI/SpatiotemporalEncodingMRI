function  res = NUFFT(k,w,shift,imSize)
%res = NUFFT(k,w,shift,imSize)
%	non uniform 2D fourier transform 
% 	This is a class which wrappes Jeffery Fesslers
%	NUFFT
%
%	Inputs:
%		k 	- 	2D non uniform k-space coordinates (complex values)
%				from -0.5 to 0.5. real part is kx imaginary is ky
%		w 	-	Density weighting vector
%		shift 	- 	shifts the center of the image [dx,dy]
%		imSize 	- 	size of the image [sx,sy]
%
%	Return:
%		NUFFT object
%
%	Use:
%		FT = NUFFT(k,w,shift,imSize);
%		y = FT*x;
%		xx = FT'*y;
% *** if x is a 3D array, y will be also a 3D array but the Fourier transform
%     will be calculated separately for each 2D image
%
% (c) Michael Lustig 2006


    om = [real(k(:)), imag(k(:))]*2*pi;
    Nd = imSize;
    Jd = [6,6];
    Kd = floor([Nd*1.5]);
    n_shift = Nd/2 + shift;
    res.st = nufft_init(om, Nd, Jd, Kd, n_shift,'kaiser');

    res.adjoint = 0;
    res.imSize = imSize;
    res.dataSize = size(k);
    res.w = sqrt(w);
    
    res = class(res,'NUFFT');

