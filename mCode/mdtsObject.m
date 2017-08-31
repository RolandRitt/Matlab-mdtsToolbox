classdef mdtsObject < CoreObject
    %
    % Description : Based on the core object, checks validity of input data
    % and passes it to the core object
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{31-Aug-2017}{Original}
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
    
    methods
        
        function obj = mdtsObject(timeIn, dataIn, tagsIn, varargin)
            
            p = inputParser;
            defaultUnits = cell(1, numel(tagsIn));
            defaultUnits(:) = {'-'};
            defaultts = [];
            defaultName = 'Time Series';
            defaultWho = 'Author';
            defaultWhen = 'Now';
            defaultDescription = 'No description available';
            defaultComment = 'No comment available';
            
            addRequired(p, 'timeIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'dataIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'tagsIn', @(x)validateattributes(x, {'cell'}, {'nonempty'}));
            
            addParameter(p, 'units', defaultUnits);
            addParameter(p, 'ts', defaultts);
            addParameter(p, 'name', defaultName);
            addParameter(p, 'who', defaultWho);
            addParameter(p, 'when', defaultWhen);
            addParameter(p, 'description', defaultDescription);
            addParameter(p, 'comment', defaultComment);
            
            parse(p, timeIn, dataIn, tagsIn, varargin{:});
            
            obj@CoreObject(p.Results.timeIn, p.Results.dataIn, p.Results.tagsIn, p.Results.units, p.Results.ts, p.Results.name, p.Results.who, p.Results.when, p.Results.description, p.Results.comment);
            
        end
            
    end
    
end

