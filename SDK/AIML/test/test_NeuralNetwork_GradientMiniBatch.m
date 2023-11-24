classdef test_NeuralNetwork_GradientMiniBatch < matlab.unittest.TestCase
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %05/06/23: Created
    %11/23/23: Updated to new unit test style
    
    methods(Test, TestTags = {'comparison'})
        
        %Example01 - Simple, single example
        function example1(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            nodesPerLayer = [3 4 5 2];
            errorFunctionID = ErrorFunctionID.SquaredError;
            
            nn = NeuralNetwork(nodesPerLayer);
            nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
            
            U_1 = [1;2;3];
            D_1 = [0.2;0.5];
            
            U_2 = [1;2;3];
            D_2 = [0.2;0.5];
            
            U_3 = [1;2;3];
            D_3 = [0.2;0.5];
            
            U_data = [
                U_1'
                U_2'
                U_3'
                ];
            
            D_data = [
                D_1';
                D_2';
                D_3'
                ];
            
            [dE_dW,dE_db] = nn.GradientMiniBatch(U_data,D_data,errorFunctionID);
            
            %Because all the inputs and outputs are the same, the averaged value
            %should be the same as BackPropagate and GradientNumerical
            [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U_1,D_1,errorFunctionID);
            
            tol = 10e-8;
            for k=1:nn.NumLayers-1
                tc.verifyTrue(AreMatricesSame(dE_dW{k},dEc_dW_check{k},tol))
                tc.verifyTrue(AreMatricesSame(dE_db{k},dEc_db_check{k},tol))
            end
        end
        
        %Example02 - Larger network (similar to what is used in training
        %image recognition)
        function example2(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            nodesPerLayer = [28*28 50 10];
            errorFunctionID = ErrorFunctionID.SquaredError;
            
            nn = NeuralNetwork(nodesPerLayer);
            nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
            
            U = rand(nodesPerLayer(1),1);
            D = rand(nodesPerLayer(end),1);
            [dEc_dW,dEc_db] = nn.BackPropagate(U,D,errorFunctionID);
            [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U,D,errorFunctionID);
            
            tol = 10e-8;
            for k=1:nn.NumLayers-1
                tc.verifyTrue(AreMatricesSame(dEc_dW{k},dEc_dW_check{k},tol))
                tc.verifyTrue(AreMatricesSame(dEc_db{k},dEc_db_check{k},tol))
            end
        end
        
        %Example03 - Similar to Example01 but use a varying size of network
        %and varying u and d.
        function example3(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            numConfigs = 15;
            numExamples = 5;
            for m=1:numConfigs
                
                nodesPerLayer = [3+m 4+2*m 2+3*m];
                errorFunctionID = ErrorFunctionID.SquaredError;
                
                nn = NeuralNetwork(nodesPerLayer);
                nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
                
                for n=1:numExamples
                    U = rand(nodesPerLayer(1),1);
                    D = rand(nodesPerLayer(end),1);
                    [dEc_dW,dEc_db] = nn.BackPropagate(U,D,errorFunctionID);
                    [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U,D,errorFunctionID);
                    
                    tol = 10e-8;
                    for k=1:nn.NumLayers-1
                        tc.verifyTrue(AreMatricesSame(dEc_dW{k},dEc_dW_check{k},tol))
                        tc.verifyTrue(AreMatricesSame(dEc_db{k},dEc_db_check{k},tol))
                    end
                end
            end
        end
        
    end
end