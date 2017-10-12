classdef mdtsObject < mdtsCoreObject
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
            
            addRequired(p, 'timeIn', @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [size(dataIn, 1), 1]}));            
            addRequired(p, 'dataIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'tagsIn', @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(dataIn, 2)]}));
            
            addParameter(p, 'units', defaultUnits, @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(dataIn, 2)]}));
            addParameter(p, 'ts', defaultts);
            addParameter(p, 'name', defaultName);
            addParameter(p, 'who', defaultWho);
            addParameter(p, 'when', defaultWhen);
            addParameter(p, 'description', defaultDescription);
            addParameter(p, 'comment', defaultComment);
            
            parse(p, timeIn, dataIn, tagsIn, varargin{:});
            
            obj@mdtsCoreObject(p.Results.timeIn, p.Results.dataIn, p.Results.tagsIn, p.Results.units, p.Results.ts, p.Results.name, p.Results.who, p.Results.when, p.Results.description, p.Results.comment);
            
        end
        
        function expandDataSet(obj, addData, addTags)
            
            timeSize = numel(obj.time);
            addTagSize = numel(addTags);
            
            if~isnumeric(addData)
                
                errID = 'expandDataSet:DataNotNumeric';
                errMsg = 'The given data matrix is not numeric!';
                error(errID, errMsg);
                
            elseif~(size(addData, 1) == timeSize)
                
                errID = 'expandDataSet:InvalideDataSize1';
                errMsg = 'The given data matrix has a different number of time stamps than the original data!';
                error(errID, errMsg);
                
            elseif~(size(addData, 2) == addTagSize)
                
                errID = 'expandDataSet:InvalideDataSize2';
                errMsg = 'The given data matrix has a different number of time stamps than the original data!';
                error(errID, errMsg);
                
            elseif~(iscell(addTags))
                
                errID = 'expandDataSet:InvalidTags';
                errMsg = 'The given tags are no cell array!';
                error(errID, errMsg);
                              
            end
            
            expandDataSet@mdtsCoreObject(obj, addData, addTags); 
            
        end
        
        function obj = calc(obj, calcObj, tagNameInput, tagNameOutput)
            
            p = inputParser();
            addRequired(p, 'calcObj', @(x) isa(x, 'calcObjectInterface'));
            addRequired(p, 'tagNameInput', @(x) iscell(x) && ischar(x{1}));
            addRequired(p, 'tagNameOutput', @(x) iscell(x) && ischar(x{1}));
            parse(p, calcObj, tagNameInput, tagNameOutput);
            
            tagI = getTagIndices(obj, p.Results.tagNameInput);
            
            dataOut = calcObj.apply(obj.data(:, tagI));
            
            expandDataSet(obj, dataOut, p.Results.tagNameOutput);
            
        end
        
        function obj = convCalc(obj, varargin)
            
            if(numel(varargin) == 1)
                
                calcObjects = varargin{1};
                
                for i = 1 : numel(calcObjects)
                    
                    calcObject = calcObjects(i);
                    
                    inputTag = calcObject.inputTag;
                    outputTag = calcObject.outputTag;
                    convMatrix = calcObject.convM;
                    
                    tagI = getTagIndices(obj, inputTag);
                    inputVector = obj.data(:, tagI);
                    
                    outputVector = convCalcFct(inputVector, convMatrix);
                    
                    expandDataSet(obj, outputVector, outputTag);
                    
                end
                
            elseif(numel(varargin) == 3)
                
                inputTag = varargin{1};
                outputTag = varargin{2};
                
                if(ischar(outputTag))
                    
                    outputTag = {outputTag};
                    
                end
                
                convMatrix = varargin{3};
                
                tagI = getTagIndices(obj, inputTag);
                inputVector = obj.data(:, tagI);
                
                outputVector = convCalcFct(inputVector, convMatrix);
                
                expandDataSet(obj, outputVector, outputTag);
                
            else
                
                errID = 'mdtsObject:InvalidNumberOfInputArguments';
                errMsg = ['Invalid number of input arguments! Input must be ',...
                'either a convolution calculation object or inputTag, outputTag, convolutionMatrix!'];
                error(errID, errMsg);
                
            end
            
        end
        
        function obj = localDerivative(obj, tagNameInput, ls, noBfs)
            
            p = inputParser();
            addRequired(p, 'tagNameInput', @(x) iscell(x) && ischar(x{1}));
            addRequired(p, 'ls', @(x) isnumeric(x) && isequal(size(x),[1 1]));
            addRequired(p, 'noBfs', @(x) isnumeric(x) && isequal(size(x),[1 1]));
            parse(p, tagNameInput, ls, noBfs);
            
            L = dopD(obj.time(1 : p.Results.ls), p.Results.noBfs);
            LDOobj = LDO(L);
            
            tagNameOutput = {['LD_', p.Results.tagNameInput{1}]};
            obj = obj.calc(LDOobj, p.Results.tagNameInput, tagNameOutput);
            
        end
        
        function figH = plotMulti(obj, varargin)
            
            % Plot channels
            
            p = inputParser();
            p.KeepUnmatched=true;
            addRequired(p, 'obj', @(x) isa(x, 'mdtsObject')); %check if input is a MDTSObject
            addParameter(p, 'Size', [8.8,11.7], @(x)isnumeric(x)&&isvector(x)); %higth and width
            addParameter(p, 'FontSize', 10, @isnumeric);
            addParameter(p, 'bUseDatetime', true, @islogical);
            parse(p, obj, varargin{:});
            tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            UnmatchedArgs = reshape(tmp',[],1)';
            
            bDatetime = p.Results.bUseDatetime;
            
            tagIndices = obj.getTagIndices(obj.tags);
            
            figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);
            fM = FigureManager;
            
            if bDatetime
                
                [out, ph] = plotMulti(obj.timeDateTime, obj.data(:, tagIndices), 'Time', obj.tags, UnmatchedArgs{:});
            else
                
                [out, ph] = plotMulti(obj.time, obj.data(:, tagIndices), 'Time', obj.tags, UnmatchedArgs{:});
            
            end
                       
            shouldAddold = fM.shouldAdd;
            fM.shouldAdd = false; % otherwise it is tooo slow!!!  
            title(out(1), obj.name);
            
            % Plot events
                        
            nEvents = length(keys(obj.tsEvents));
            colors = distinguishable_colors(nEvents, {'w', get(ph(1), 'Color')});
            
            if bDatetime
                
                if nEvents
                    
                    indEv = 1;
                    
                    for key = keys(obj.tsEvents)
                        
                        xev = datetime(obj.tsEvents(key{1}), 'ConvertFrom', 'datenum');
                        ph2 = plotvline(xev, 'Axes', out, 'Color', colors(indEv,:));
                        indEv = indEv + 1;
                        ph = [ph, ph2];
                        
                    end
                end
            else
                if nEvents
                    
                    indEv = 1;
                    
                    for key = keys(obj.tsEvents)
                        
                        xev = obj.tsEvents(key{1});
                        ph2 = plotvline(xev, 'Axes', out, 'Color', colors(indEv,:));
                        indEv = indEv + 1;
                        ph = [ph, ph2];
                        
                    end
                end
            end
            
            fM.shouldAdd = shouldAddold;
            
        end
        
        function obj = addEvent(obj, name, x, bInd)
            % function to add events at defined x positions
            %
            %   Syntax:
            %       addEvent(obj, name, x)
            %
            %   Input Parameters :
            %       name := the name of the Events at positions x
            %
            %       x := x position where the event occurs, either the
            %       timestamp (datenum) or datetimeobj
            %
            %       bInd := (optional) if true x is the index on which the event occurs
            %
            
            if nargin > 3 && bInd
                
                x = obj.time(x);
                
            end
            
            if isdatetime(x)
                
                x = datenum(x);
                
            end
            
            addEvent@mdtsCoreObject(obj, name, x); 
            
        end
            
    end
    
end

