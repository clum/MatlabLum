function [C] = CatCellArrayOf2DMatrices(A,B)

%CATCELLARRAYOF2DMATRICES Concatenates cell array of 2d matrices
%
%   [C] = CATCELLARRAYOF2DMATRICES(A,B) Appends the contents of B onto A
%   and returns as C.%
%
%INPUT:     -A:     first cell array
%           -B:     second cell array
%
%OUTPUT:    -C:     concatenated cell array
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/06/23: Created

%-----------------------CHECKING DATA FORMAT-------------------------------
%A
assert(iscell(A))
[M_A,N_A] = size(A);

%B
assert(iscell(B))
[M_B,N_B] = size(B);

%-------------------------BEGIN CALCULATIONS-------------------------------
if(isempty(A))
    C = B;
elseif(isempty(B))
    C = A;
else
    %Concatenate B onto A
    assert(M_A==M_B);
    assert(N_A==N_B);

    for m=1:M_A
        for n=1:N_A
            A_mn = A{m,n};
            B_mn = B{m,n};
                        
            %Assert dimensions are compatible
            assert(AreMatricesSameDimensions(A_mn(:,:,1),B_mn(:,:,1)),'A and B do not appear to have compatible dimensions')
            
            %Concatenate along 3rd dimension
            C_mn = cat(3,A_mn,B_mn);
            
            C{m,n} = C_mn;
        end
    end
end