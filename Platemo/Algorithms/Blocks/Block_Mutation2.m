classdef Block_Mutation2 < BLOCK
    
%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
%  
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties
        nSets;      % <hyperparameter> Number of weight sets
        D;          % <hyperparameter> Number of decision variables
        Weight;     % <parameter> Weight sets
        Fit;        % <parameter> Expectation of using each weight set
    end
    methods
        %% Default settings of the block
        function obj = Block_Trick(nSets,D)
            obj.nSets = nSets;	% Hyperparameter
            obj.D     = D;      % Hyperparameter
            obj.lower = repmat([0 zeros(1,obj.D) 1e-20],1,nSets);   % Lower bounds of parameters
            obj.upper = repmat([1 ones(1,obj.D) 1],1,nSets);        % Upper bounds of parameters
            % Randomly set the parameters
            obj.parameter = unifrnd(obj.lower,obj.upper);
            obj.ParameterAssign();
        end
        %% Assign parameters to variables
        function ParameterAssign(obj)
            obj.Weight = reshape(obj.parameter,[],obj.nSets)';
            obj.Fit    = cumsum(obj.Weight(:,end));
            obj.Fit    = obj.Fit./max(obj.Fit);
        end
        %% Main procedure of the block
        function Main(obj,Problem,Precursors,Ratio)
            ParentDec  = obj.Gather(Problem,Precursors,Ratio,2,1);
            [r,a]      = ParaSampling(size(ParentDec),obj.Weight(:,1:end-1),obj.Fit);
            obj.output = r.*ParentDec + a;
        end
        
        function Modify(obj,index,para)
            obj.Weight(index,:) = [0,para,1];
            obj.Fit       = cumsum(obj.Weight(:,end));
            obj.Fit       = obj.Fit./max(obj.Fit);
            obj.parameter = reshape(obj.Weight',1,[]);
        end
    end
end

function [r,a] = ParaSampling(xy,weight,fit)
% Parameter sampling

    r    = zeros(xy);
    a    = zeros(xy);
    type = arrayfun(@(S)find(rand<=fit,1),zeros(1,xy(1)));
    for i = 1 : length(fit)
        index = type == i;
        r(index,:) = repmat(weight(i,1),sum(index),xy(2));
        a(index,:) = repmat(weight(i,2:end),sum(index),1);
    end
end