classdef genericCalcObject
    %
    % Description : generic calculation Object which can define different
    % computations
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{30-Oct-2017}{Original}
    %
    % --------------------------------------------------
    % (c) 2017, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        
        %% Core data
        
        calcName
        inputTag
        outputTag
        calcType
        
        %% Parameter
        
        % Convolution
        
        convM
        
    end
    
    methods
        
        function obj = genericCalcObject(calcNameIn, inputTagIn, outputTagIn, calcTypeIn, varargin)
            
            if(ischar(inputTagIn))
                
                inputTagIn = {inputTagIn};
                
            end
            
            if(ischar(outputTagIn))
                
                outputTagIn = {outputTagIn};
                
            end
            
            p = inputParser();
            addRequired(p, 'calcNameIn', @(x) ischar(x));
            addRequired(p, 'inputTagIn', @(x) iscell(x) && ischar(x{1}));
            addRequired(p, 'outputTagIn', @(x) iscell(x) && ischar(x{1}));
            addRequired(p, 'calcTypeIn', @(x) ischar(x));
            
            addParameter(p, 'convM', [], @(x)validateattributes(x,...
                {'numeric'},{'real', 'finite', 'nonnan', '2d'}));

            parse(p, calcNameIn, inputTagIn, outputTagIn, calcTypeIn, varargin{:});
            
            % Core data
            
            obj.calcName = p.Results.calcNameIn;
            obj.inputTag = p.Results.inputTagIn;
            obj.outputTag = p.Results.outputTagIn;
            obj.calcType = p.Results.calcTypeIn;
            
            % Convolution
            
            obj.convM = p.Results.convM;
                        
        end
        
        function calcString = getString(obj)
            
            calcString = jsonencode(obj);
            
        end
    end
    
end

