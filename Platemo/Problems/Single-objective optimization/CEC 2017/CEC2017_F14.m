classdef CEC2017_F14 < PROBLEM
% <2016> <single> <real> <constrained>
% CEC'2017 constrained optimization benchmark problem

%------------------------------- Reference --------------------------------
% G. Wu, R. Mallipeddi, and P. N. Suganthan. Problem definitions and
% evaluation criteria for the CEC 2017 competition on constrained real-
% parameter optimization. National University of Defense Technology, China,
% 2016.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties
        O;  % Optimal decision vector
    end
    methods
        %% Default settings of the problem
        function Setting(obj)
            CallStack = dbstack('-completenames');
            load(fullfile(fileparts(CallStack(1).file),'CEC2017.mat'),'Data');
            obj.O = Data{12}.o;
            obj.M = 1;
            if isempty(obj.D); obj.D = 10; end
            obj.D = min(obj.D,length(obj.O));
            obj.lower    = zeros(1,obj.D) - 100;
            obj.upper    = zeros(1,obj.D) + 100;
            obj.encoding = ones(1,obj.D);
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            Y = PopDec - repmat(obj.O(1:size(PopDec,2)),size(PopDec,1),1);
            PopObj = -20*exp(-0.2*sqrt(mean(Y.^2,2))) + 20 - exp(mean(cos(2*pi*Y),2)) + exp(1);
        end
        %% Calculate constraint violations
        function PopCon = CalCon(obj,PopDec)
            Y = PopDec - repmat(obj.O(1:size(PopDec,2)),size(PopDec,1),1);
            PopCon(:,1) = sum(Y(:,2:end).^2,2) + 1 - abs(Y(:,1));
            PopCon(:,2) = abs(sum(Y.^2,2)-4) - 1e-4;
        end
    end
end