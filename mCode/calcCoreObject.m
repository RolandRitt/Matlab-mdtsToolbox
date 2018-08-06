classdef calcCoreObject
    %
    % Description : Parent class which passes core data to calcObjects
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
        
        calcName
        inputTag
        outputTag
        calcType
               
    end
    
    methods
        
        function obj = calcCoreObject(calcName, inputTag, outputTag, calcType)
            
            obj.calcName = calcName;
            obj.inputTag = inputTag;
            obj.outputTag = outputTag;
            obj.calcType = calcType;
                        
        end
                
    end
    
end


