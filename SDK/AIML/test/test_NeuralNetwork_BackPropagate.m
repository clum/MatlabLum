classdef test_NeuralNetwork_BackPropagate < matlab.unittest.TestCase
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %04/23/23: Created
    %11/23/23: Updated to new unit test style
    
    methods(Test, TestTags = {'comparison'})
        
        %Example01 - Simple, single example and compare against GradientNumerical
        function example1(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            nodesPerLayer = [3 4 2];
            errorFunctionID = ErrorFunctionID.SquaredError;
            
            nn = NeuralNetwork(nodesPerLayer);
            nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
            
            U = [1;2;3];
            D = [0.2;0.5];
            [dEc_dW,dEc_db] = nn.BackPropagate(U,D,errorFunctionID);
            [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U,D,errorFunctionID);
            
            tol = 10e-8;
            for k=1:nn.NumLayers-1
                tc.verifyTrue(AreMatricesSame(dEc_dW{k},dEc_dW_check{k},tol))
                tc.verifyTrue(AreMatricesSame(dEc_db{k},dEc_db_check{k},tol))
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
        
        %Example04 - Similar to Example01 but with ReLU as activation
        %function
        function example4(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            nodesPerLayer = [3 4 2];
            errorFunctionID = ErrorFunctionID.SquaredError;
            
            nn = NeuralNetwork(nodesPerLayer);
            nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
            nn.SetActivationFunctionAtLayer(2,ActivationFunctionID.ReLU)
            nn.SetActivationFunctionAtLayer(3,ActivationFunctionID.ReLU)
            
            U = [1;2;3];
            D = [0.2;0.5];
            [dEc_dW,dEc_db] = nn.BackPropagate(U,D,errorFunctionID);
            [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U,D,errorFunctionID);
            
            tol = 10e-7;
            for k=1:nn.NumLayers-1
                tc.verifyTrue(AreMatricesSame(dEc_dW{k},dEc_dW_check{k},tol))
                tc.verifyTrue(AreMatricesSame(dEc_db{k},dEc_db_check{k},tol))
            end
        end
        
        %Example05 - Similar to Example02 but with ReLU as activation
        %function
        function example5(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            nodesPerLayer = [28*28 50 10];
            errorFunctionID = ErrorFunctionID.SquaredError;
            
            nn = NeuralNetwork(nodesPerLayer);
            nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
            nn.SetActivationFunctionAtLayer(2,ActivationFunctionID.ReLU);
            nn.SetActivationFunctionAtLayer(3,ActivationFunctionID.ReLU);
            
            U = rand(nodesPerLayer(1),1);
            D = rand(nodesPerLayer(end),1);
            [dEc_dW,dEc_db] = nn.BackPropagate(U,D,errorFunctionID);
            [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U,D,errorFunctionID);
            
            tol = 10e-5;
            for k=1:nn.NumLayers-1
                tc.verifyTrue(AreMatricesSame(dEc_dW{k},dEc_dW_check{k},tol))
                tc.verifyTrue(AreMatricesSame(dEc_db{k},dEc_db_check{k},tol))
            end
        end
        
        %Example06 - Similar to Example03 but with ReLU as activation
        %function
        function example6(tc)
            ChangeWorkingDirectoryToThisLocation();
            
            %Perform test
            numConfigs = 15;
            numExamples = 5;
            for m=1:numConfigs
                
                nodesPerLayer = [3+m 4+2*m 2+3*m];
                errorFunctionID = ErrorFunctionID.SquaredError;
                
                nn = NeuralNetwork(nodesPerLayer);
                nn.SetActivationFunctionAtAllLayers(ActivationFunctionID.Sigmoid);
                nn.SetActivationFunctionAtLayer(2,ActivationFunctionID.ReLU);
                nn.SetActivationFunctionAtLayer(3,ActivationFunctionID.ReLU);
                
                for n=1:numExamples
                    U = rand(nodesPerLayer(1),1);
                    D = rand(nodesPerLayer(end),1);
                    [dEc_dW,dEc_db] = nn.BackPropagate(U,D,errorFunctionID);
                    [dEc_dW_check,dEc_db_check] = nn.GradientNumerical(U,D,errorFunctionID);
                    
                    tol = 10e-5;
                    for k=1:nn.NumLayers-1
                        tc.verifyTrue(AreMatricesSame(dEc_dW{k},dEc_dW_check{k},tol))
                        tc.verifyTrue(AreMatricesSame(dEc_db{k},dEc_db_check{k},tol))
                    end
                end
            end
        end
        
    end
end