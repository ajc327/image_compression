function [vlc vlc2 bits huffval] = lbtenc2lev(X, qstep,rise1,qf,N, M, opthuff, dcbits)
    
% lbtenc Encode an image to a (simplified) JPEG bit stream
%
%  [vlc reptable bits huffval] = lbtenc(X, qstep, N, M, opthuff, dcbits) Encodes the
%  image in X to generate the variable length bit stream in vlc.
%
%  X is the input greyscale image
%  qstep is the quantisation step to use in encoding
%  N is the width of the DCT block (defaults to 8)
%  M is the width of each block to be coded (defaults to N). Must be an
%  integer multiple of N - if it is larger, individual blocks are
%  regrouped.
 % qf is the quality factor if default jpeg quantisation table is used and
 % is the scaling factor if the custom table is used
%  if opthuff is true (defaults to false), the Huffman table is optimised
%  based on the data in X
%  dcbits determines how many bits are used to encode the DC coefficients
%  of the DCT (defaults to 8)
%
%  vlc is the variable length output code, where vlc(:,1) are the codes, and
%  vlc(:,2) the number of corresponding valid bits, so that sum(vlc(:,2))
%  gives the total number of bits in the image
%  bits and huffval are optional outputs which return the Huffman encoding
%  used in compression

% This is global to avoid too much copying when updated by huffenc
global huffhist  % Histogram of usage of Huffman codewords.

% Presume some default values if they have not been provided
error(nargchk(2, 8, nargin, 'struct'));
if ((nargout~=2) && (nargout~=4)) error('Must have two or four output arguments'); end
if (nargin<8)
  dcbits = 8;
  if (nargin<7)
    opthuff = false;
    if (nargin<6)
      if (nargin<5)
        N = 2;
        M = 4;
      else
        M = N;
      end
    else 
      if (mod(M, N)~=0) error('M must be an integer multiple of N'); end
    end
  end
end
 if ((opthuff==true) && (nargout==1)) error('Must output bits and huffval if optimising huffman tables'); end
 
% DCT on input image X.
N=2;
fprintf(1, 'Forward %i x %i DCT\n', N, N);
C8=dct_ii(N);
    

    
    %find the optimal step according to the lbt size and default s=sqrt(2)

    
     
Y=colxfm(colxfm(X,C8)',C8)'; 

Y_lowpass = Y(1:size(Y,1)/N,1:size(Y,2)/N); 


%now apply the lbt to the top left subimage 
    M=4;
    [pf,pr] = pot_ii(M,sqrt(2)); 
    I = size(Y_lowpass,1);
    t =[(1+M/2):(I-M/2)];
    Yp = Y_lowpass; 
    
    %apply the pre filter and the dct
    Yp(t,:) = colxfm(Yp(t,:),pf); 
    Yp(:,t) = colxfm(Yp(:,t)', pf)';
    

% Quantise to integers.
fprintf(1, 'Quantising to step size of %i\n', qstep); 
[Yq,reptable]=quant1_table(Yp,qstep,qstep*rise1,qf,4);
Yq_reg= regroup(Yq,N);

% Generate zig-zag scan of AC coefs.
scan = diagscan(M);

% On the first pass use default huffman tables.
disp('Generating huffcode and ehuf using default tables')
[dbits, dhuffval] = huffdflt(1);  % Default tables.
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows')
sy=size(Yq);
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M),
  vlc1 = [];
  for c=0:M:(sy(2)-M),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    yq(1) = yq(1) + 2^(dcbits-1);
    if ((yq(1)<0) | (yq(1)>(2^dcbits-1)))
      error('DC coefficients too large for desired number of bits');
    end
    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
    ra1 = runampl(yq(scan));
    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc = [vlc; vlc1];
end


%here vlc for the dct is computed 
Y(1:size(Y,1)/N,1:size(Y,2)/N) = 0;
Yq=quant1(Y,qstep,qstep*rise1);

% Generate zig-zag scan of AC coefs.
scan = diagscan(N);

% On the first pass use default huffman tables.
disp('Generating huffcode and ehuf using default tables')
[dbits, dhuffval] = huffdflt(1);  % Default tables.
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows')
sy=size(Yq);
t = 1:N;
huffhist = zeros(16*16,1);
vlc2 = [];
for r=0:N:(sy(1)-N),
  vlc1 = [];
  for c=0:N:(sy(2)-N),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    %if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    yq(1) = yq(1) + 2^(dcbits-1);
    if ((yq(1)<0) | (yq(1)>(2^dcbits-1)))
      error('DC coefficients too large for desired number of bits');
    end
    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
    ra1 = runampl(yq(scan));
    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc2 = [vlc2; vlc1];
end




% Return here if the default tables are sufficient, otherwise repeat the
% encoding process using the custom designed huffman tables.
if (opthuff==false) 
  if (nargout>1)
    bits = dbits;
    huffval = dhuffval;
  end
  mysum= sum(vlc(:,2))+sum(vlc2(:,2));
  fprintf(1,'Bits for coded image = %d\n', mysum);
  return;
end

% Design custom huffman tables.
disp('Generating huffcode and ehuf using custom tables')
[dbits, dhuffval] = huffdes(huffhist);
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows (second pass)')
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M),
  vlc1 = [];
  for c=0:M:(sy(2)-M),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    yq(1) = yq(1) + 2^(dcbits-1);
    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
    ra1 = runampl(yq(scan));
    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc = [vlc; vlc1];
end
fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)))
fprintf(1,'Bits for huffman table = %d\n', (16+max(size(dhuffval)))*8)

if (nargout>1)
  bits = dbits;
  huffval = dhuffval';
end

return