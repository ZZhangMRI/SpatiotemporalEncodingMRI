function PSF=PSF_SPEN(y_source,y_samp,deltak,Nk,Q)
%%  This is the Point spread function of SPEN

if nargin<5
    Q=Nk;
end
y_source=y_source(:);
y_samp=y_samp(:);

M=length(y_samp);
N=length(y_source);

PSF=zeros(M,N);

for m=1:M
    for n=1:N
        if (abs(mod(y_source(n)-y_samp(m),1/deltak))<eps)
            PSF(m,n)=exp(1i*2*pi*Q*(y_source(n)^2-0*y_samp(m)^2))*exp(1i*2*pi*deltak/2*(y_source(n)-y_samp(m)));
        else
            PSF(m,n)=exp(1i*2*pi*Q*(y_source(n)^2-0*y_samp(m)^2))*exp(1i*2*pi*deltak/2*(y_source(n)-y_samp(m)))...
                *(sin(2*pi*Nk/2*deltak*(y_source(n)-y_samp(m)))/(sin(2*pi*1/2*deltak*(y_source(n)-y_samp(m)))))/Nk;
        end
    end
end
