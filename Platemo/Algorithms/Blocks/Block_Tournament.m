classdef Block_Tournament < BLOCK
% Tournament selection
% nParents --- 100 --- Number of parents generated
% upper    ---   2 --- Max number of k for k-tournament

%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties(SetAccess = private)
        nParents;       % <hyperparameter> Number of generated parents 
        nTournament;    % <parameter> Number of candidate solutions for selecting a parent
    end
    methods
        %% Default settings of the block
        function obj = Block_Tournament(nParents,upper)
            obj.nParents = nParents;    % Hyperparameter
            obj.lower    = 1;           % Lower bounds of parameters
            obj.upper    = upper;      	% Upper bounds of parameters
            % Randomly set the parameters
            obj.parameter = unifrnd(obj.lower,obj.upper);
            obj.ParameterAssign();
        end
        %% Assign parameters to variables
        function ParameterAssign(obj)
            obj.nTournament = round(obj.parameter(1));
        end
        %% Main procedure of the block
        function Main(obj,Problem,Precursors,Ratio)
            Population = obj.Gather(Problem,Precursors,Ratio,1,1);
            if Problem.M == 1   % For single-objective optimization
                [~,rank] = sort(FitnessSingle(Population)');
                [~,rank] = sort(rank);
            else                % For multi- and many-objective optimization
                rank = NDSort(Population.objs,Population.cons,inf);
            end
            Parents    = randi(length(Population),obj.nTournament,obj.nParents);
            [~,best]   = min(rank(Parents),[],1);
            index      = Parents(best+(0:obj.nParents-1)*obj.nTournament);
            obj.output = Population(index);
        end
    end
end