classdef SymbRepObject
    %
    % Description : Represents a full segmentation set for one channel of
    % an mdtsObject
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{09-Jan-2018}{Original}
    %
    % --------------------------------------------------
    % (c) 2018, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        
        durations
        symbols
        
    end
    
    properties(Dependent)
        
        symbRepVec
        
    end
    
    methods
        
        function obj = SymbRepObject(durations, symbols)
            
            obj.durations = durations;
            obj.symbols = symbols;
            
        end
        
        function symbRepVec = get.symbRepVec(obj)
            
            symbRepVec = repelem(obj.symbols, obj.durations);
            
        end
    end
    
end

