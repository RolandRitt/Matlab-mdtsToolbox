classdef LDO < handle & calcObjectInterface
    properties (Access=private)
        lc
        lc_conv %center row flipped for convolution
        T
        B
        
        ls
        mid
    end
    properties (GetAccess=public)
        L
    end
    
    methods
        function obj = LDO(L)
            %constructor
            [m,n] = size(L);
            
            if (m==n)
                if ~isOdd(n)
                    error('LDO is only implemented odd support length');
                end
                
                obj.L = L;
                obj.ls=n;
                mid = (n+1)/2; %middle row index
                obj.mid = mid;
                obj.lc = L(mid, :); %ectract middl row
                obj.lc_conv = fliplr(obj.lc); %ectract middl row
                obj.T = L(1:mid-1, :);
                obj.B = L(mid+1:end,:);
                
            else
                error('LDO is only implemented for squared Operators');
            end
        end
        
        
        
        
        
        function yL = apply(obj, y)
            
            [m,n] = size(y);
            if n>1
                error('Input data have to be a single column vector');
            end
            
            if obj.ls>m
                error(['Input vector is to small for the LDO. Size must be at least: ', ...
                    num2str(obj.ls)]);
            end
            
%             if any(isnan(y))
%                 y(isnan(y))=0;
%                 warning('Nans replaced with zero');
%             end
            
            yL = conv(y, obj.lc_conv, 'same'); %convolution with central row of LDO Matrix
            yL(1:obj.mid-1) = obj.T*y(1:obj.ls);
            yL(end-obj.mid+2:end) = obj.B*y(end-obj.ls+1:end);
            
        end
    end
    
end