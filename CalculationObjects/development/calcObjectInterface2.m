classdef (Abstract) calcObjectInterface2 < handle
    %
    % Description : Define the interface of calculation objects
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
    
    properties (Abstract)
        
        calcName
        inputTag
        outputTag
        calcType
        
    end
    
    methods (Abstract)
        
        calcString = getString(obj)

    end
    
end