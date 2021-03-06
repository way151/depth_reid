% Demo for DVCov and Eigen-depth feature extraction of one frame in BIWI RGBD-ID dataset

clc;clear;
addpath './utils';

root_path = '../../dataset/biwi-rgbdid/';
train_path = strcat(root_path,'Training/');
test_path = strcat(root_path,'Testing/');
save_train_path = strcat(root_path,'trainpoint/');
save_test_path = strcat(root_path,'testpoint/');



listings = dir(train_path);


for id = 1:50
    subdir = listings(id+2).name; 
    listsubdir = dir(fullfile(train_path,subdir)); 
    nofsubdir = size(listsubdir,1);
    for id2 = 3:5:nofsubdir
     
        depth_file = fullfile(train_path,subdir,listsubdir(id2+1).name);
        mask_file = fullfile(train_path,subdir,listsubdir(id2+2).name);
        skeleton_file = fullfile(train_path,subdir,listsubdir(id2+3).name);

        depth=imread(depth_file);
        mask=imread(mask_file);
        skeleton=dlmread(skeleton_file);

        pointcloud=compute_person_pointcloud(depth,mask);
%         pointcloud_torso=segment_torso(pointcloud,skeleton);
        normals = estimateNormals(pointcloud);        

%         normals = estimateNormals( pointcloud_torso );
%         [cov_within, cov_between, ed_within, ed_between]=dvcov_and_eigen_depth_extraction(pointcloud_torso, normals);
        pcn = [pointcloud normals];

        [dirN, base, sth] = fileparts(depth_file);
        baseFName = base;
        if ~exist(fullfile(save_train_path,subdir))
            mkdir(fullfile(save_train_path,subdir));
        end
        savefile = fullfile(save_train_path,subdir,sprintf('%s.mat',baseFName));
        save(savefile,'pcn');
    end
    
end

% x1 = pcn(:,4);
% y1 = pcn(:,5);
% z1 = pcn(:,6);
% scatter3(x1,y1,z1,1);
% hold on;
% xlabel('x');
% ylabel('y');
% zlabel('z');