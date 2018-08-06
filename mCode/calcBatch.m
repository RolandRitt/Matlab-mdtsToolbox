classdef calcBatch < handle
    %
    % Description : Hold a number of calcObjects as batch
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{16-Oct-2017}{Original}
    %
    % --------------------------------------------------
    % (c) 2017, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        
        calcObjectBatch
        
    end
    
    methods
        
        function obj = calcBatch
            
            obj.calcObjectBatch = {};
            
        end
        
        function obj = addCalculations(obj, newCalculations)
            
            if(~iscell(newCalculations))
                
                newCalculations = {newCalculations};
                
            end
            
            if(size(newCalculations, 2) > 1)
                
                newCalculations = newCalculations';
                
            end
            
            obj.calcObjectBatch = [obj.calcObjectBatch; newCalculations];
            
        end
        
        function calcString = getString(obj)
            
            calcString = '[';
            
            for i = 1 : numel(obj.calcObjectBatch)
                
                thisCalcString = jsonencode(obj.calcObjectBatch{i});
                calcString = [calcString, thisCalcString, ','];
                
            end
            
            calcString = [calcString(1 : end - 1), ']'];
            
        end
        
    end
    
end

