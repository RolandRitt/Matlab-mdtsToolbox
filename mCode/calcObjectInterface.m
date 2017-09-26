classdef (Abstract) calcObjectInterface < handle
    %
    % Description : Define the interface of calculation objects
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{25-Sep-2017}{Original}
    %
    % --------------------------------------------------
    % (c) 2017, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
    end
    
    methods (Abstract)
        
        result = apply(obj, inputData)
        % All inputs from the calc method of the MDTS object will be passed
        % to this function. The calc object has to check the inputs,
        % whether they are m or just 1 data column(s).
        
    end
    
end

