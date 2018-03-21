% testGeneral
% testing of program
% for my own work
% INPUTS
% UGVSpeed = the time to travel one unit for the UGV (has to be greater than equal to 1)
% method = 1 is GLNS, 0 is concorde
% OUTPUTS

% house keeping
% clear all;
% close all;
% clc;


function [time,gtspWeightMatrix2, gtspTime] = testGeneral(numPointsInit, numBatteryLevels, filename, timeTO, timeL, rechargeRate, UGVSpeed, G1, x1, y1, method)

time = 0;
% variables
% numPointsInit = 7;
% numBatteryLevels = 2;
area = [300,0,110,0]; % value used for graphMakingNew [xmax, xmin,ymax,ymin]
rotation = 51; % value used for rotating in graphMakingNew, in degrees
nodeArray = [];

for i = 1:numPointsInit*numBatteryLevels
    nodeArray(end+1) = i;
end
nodeArray = nodeArray';
[G1, x1, y1, x0, y0] = graphMakingNew(numPointsInit, area, rotation);
[G1] = createEdgesFull(G1, numPointsInit);
[T, x3d, y3d, z3d] = tableMaking(x1, y1, numBatteryLevels);

% outputs
% figure(1)
% plot(G1)
% figure(2)
% plot(G1, 'XData', x1, 'YData', y1)

% creates 3D plots
h = scatter3(x3d, y3d, z3d);
% numPoints = numel(h.XData);
% creates new graph with existing points
[G2, x2, y2] = graphMakingWPoints(h.XData, h.YData);
[v_Cluster] = makingV_cluster(numPointsInit, numBatteryLevels);
v_Cluster = num2cell(v_Cluster);                                                           % formating

[v_Adj, v_Type, S1, T1, weights] = makingSTWv_AdjGeneral(area, x1, y1, numPointsInit, numBatteryLevels, v_Cluster, timeTO, timeL, rechargeRate, UGVSpeed);
[xOut, yOut] = graphingCluster(x1, y1, numPointsInit, numBatteryLevels, S1, T1, 0, nodeArray, method);            % graph in cluster format

% GTSP solver
% [x_reshape, G_final, fval, exitflag, output] = call_gtsp_recursive_func(v_Cluster, v_Adj);
tic;
[finalMatrix, G_init, edgeWeightsFinal, finalTour, gtspWeightMatrix, gtspWeightMatrix2] = gtspSolver(v_Cluster, v_Adj, numPointsInit, numBatteryLevels, xOut, yOut, method);
gtspTime = toc;

f = fullfile('/home/klyu/lab/heterogenous_teams/Heterogeneous-Teams/', filename);
save(f);
close all;
end

