addpath('../util/');
addpath('../myvlfeat/toolbox/');
vl_setup;

matlabpool open;

ROOTPATH = '/home/nfs/work/tmp/LandUse';
PATH_TO_DATASET = '/home/nfs3/work/HoGinBoF/data/LandUse/Images';

cvdata_landuse(PATH_TO_DATASET, ROOTPATH);

for cvi = 1:5

testtype = sprintf('test%02d',cvi);

params.nword     = 256;
params.localdesc = struct('calc_desc',@calc_phow, 'step',4, 'patchsizes',[16,24,32], 'pcadim',64, ...
	'floatdescriptors',0, 'normalizationtype',2, 'dirichleteps',0.001);
params.feat      = struct('nposbins',{{[1;3],[2;2],[1;1]}}, 'chunksize',10000, 'savefeat',false);
params.classifier= struct('cost',1:0.1:3);


addpath('../localdesc');
build_gmm;   clearvars -except PATH_TO_DATASET ROOTPATH testtype params

addpath('../classify');
build_fk_classification;

addpath('../evaluation');
result_macc = evaluation_acc(result);
save(fullfile(opath, sprintf('result_%dword_%d_%d_%d_%s.mat', nword, struct2hash(lparams), struct2hash(fparams), struct2hash(cparams), testtype)),'result_macc','-append');

fprintf('acc.=%2.2f%%\n',100*max([result_macc.macc]));

clearvars -except PATH_TO_DATASET ROOTPATH

end