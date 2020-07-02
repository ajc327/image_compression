%%
load SF2_competition_image_2020 
X=double(X);
[vlc, qstep, rise1, qf] = group1enc(X);
%file_name = append(image_name(1:5),'cmp.mat');
file_name='compecmp.mat';
save(file_name,'vlc','qstep','rise1','qf');
clear all;
load compecmp;
Z1 = lbtdec(vlc, qstep, rise1, qf);
load SF2_competition_image_2020;
X=double(X);
error= std(X(:)-Z1(:)); 
bits = sum(vlc(:,2));
header_bits = 8*8*3;
fprintf(1, 'The rms is %i,the bit required by vlc is %i, the number of bits required by the variables is %i', error, bits, header_bits);
draw(Z1);
save('compedec','Z1');

%%
load bridge 
X=double(X);
[vlc, qstep, rise1, qf] = group1enc(X);
%file_name = append(image_name(1:5),'cmp.mat');
file_name='bridgcmp.mat';
save(file_name,'vlc','qstep','rise1','qf');
clear all;
load bridgcmp;
Z2 = lbtdec(vlc, qstep, rise1, qf);
load bridge;
X=double(X);
error= std(X(:)-Z2(:)); 
bits = sum(vlc(:,2));
header_bits = 8*8*3;
fprintf(1, 'The rms is %i, the bit required by vlc is %i, the number of bits required by the variables is %i', error, bits, header_bits);
draw(Z2);
save('bridgdec','Z2');

%%

load flamingo 
X=double(X);
[vlc, qstep, rise1, qf] = group1enc(X);
%file_name = append(image_name(1:5),'cmp.mat');
file_name='flamicmp.mat';
save(file_name,'vlc','qstep','rise1','qf');
clear all;
load flamicmp;
Z3 = lbtdec(vlc, qstep, rise1, qf);
load flamingo;
X=double(X);
error= std(X(:)-Z3(:)); 
bits = sum(vlc(:,2));
header_bits = 8*8*3;
fprintf(1, 'The rms is %i, the bit required by vlc is %i, the number of bits required by the variables is %i', error, bits, header_bits);
draw(Z3);
save('flamidec','Z3');

%%
load flamidec; 
load compedec;
load bridgdec;

save('Group1','Z1','Z2','Z3');