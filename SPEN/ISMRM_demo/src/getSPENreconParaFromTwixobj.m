function SPENpara=getSPENreconParaFromTwixobj(twix_obj,seqtype)
% get the requred SPEN parameters from a structure
% Input:  
%          obj: structure from mapVBVD 
% Output: 
%          SPENpara: 
%          two field#1: SPENpara.recon -->a struct output of required SPEN reconstruction parameters
%          two field#2: SPENpara.infor -->a struct output of important SPEN parameters
%
%%
if iscell(twix_obj)
    twix_obj=twix_obj{end};
end
if (nargin==2) && strcmp(seqtype,'SPEN_diff')
    SPENpara.infor.Ta=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{15};     %[us]
    SPENpara.infor.Tchirp=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{16}; %[us]
    SPENpara.infor.Texc=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{17};   %[us]
    SPENpara.infor.ChirpBW=twix_obj.hdr.MeasYaps.sWipMemBlock.adFree{3}; %[kHz]
    SPENpara.infor.ExcBW=twix_obj.hdr.MeasYaps.sWipMemBlock.adFree{4};
    SPENpara.infor.PEfov=twix_obj.hdr.MeasYaps.sWipMemBlock.adFree{7};

    SPENpara.recon.Q=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{1};
    SPENpara.recon.NPE=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{8};
%     SPENpara.recon.Nseg=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{13};
    SPENpara.recon.Nseg=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{9};
    SPENpara.recon.NPEperseg = SPENpara.recon.NPE/SPENpara.recon.Nseg;
    
else
    SPENpara.infor.Ta=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{15};     %[us]
    SPENpara.infor.Tchirp=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{16}; %[us]
    SPENpara.infor.Texc=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{17};   %[us]
    SPENpara.infor.ChirpBW=twix_obj.hdr.MeasYaps.sWipMemBlock.adFree{3}; %[kHz]
    SPENpara.infor.ExcBW=twix_obj.hdr.MeasYaps.sWipMemBlock.adFree{4};
    SPENpara.infor.PEfov=twix_obj.hdr.MeasYaps.sWipMemBlock.adFree{7};

    SPENpara.recon.Q=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{1};
    SPENpara.recon.NPE=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{8};
    SPENpara.recon.Nseg=twix_obj.hdr.MeasYaps.sWipMemBlock.alFree{12};
    SPENpara.recon.NPEperseg = SPENpara.recon.NPE/SPENpara.recon.Nseg;
end
%%
slicePos=twix_obj.image.slicePos;
asSlice=twix_obj.hdr.MeasYaps.sSliceArray.asSlice{1};
RotMat = transpose(Quat2RotMat(slicePos(4:end,1))) ;
ImgCenterShifted=slicePos(1:3,1);
RotatedLocs=RotMat.'*ImgCenterShifted;
ShiftPE=RotatedLocs(1,1);
lpe=asSlice.dPhaseFOV;
SPENpara.recon.PEshiftnorm=-ShiftPE/lpe;
SPENpara.infor.PEoffset=-ShiftPE;

function [RotMat] = Quat2RotMat(QVec)

  RotMat = zeros(3) ;
  
  a = QVec(1) ;
  b = QVec(2) ;
  c = QVec(3) ;
  d = QVec(4) ;

  RotMat(1,1) = a^2 + b^2 - c^2 - d^2 ;
  RotMat(1,2) = 2*b*c + 2*a*d ;
  RotMat(1,3) = 2*b*d - 2*c*a ;
  RotMat(2,1) = 2*b*c - 2*a*d ;
  RotMat(2,2) = a^2 - b^2 + c^2 - d^2 ;
  RotMat(2,3) = 2*c*d + 2*a*b ;
  RotMat(3,1) = 2*b*d + 2*a*c ;
  RotMat(3,2) = 2*c*d - 2*a*b ;
  RotMat(3,3) = a^2 - b^2 - c^2 + d^2 ;

return ;

