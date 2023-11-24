classdef NeuralNetwork < handle
    %NEURALNETWORK Representation of a neural network
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %02/25/23: Created
    %03/03/23: Changed to reference class (inherit from handle)
    %05/10/23: Adding ReLU
    %05/25/23: Removed activation function at layer 1
    
    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
    end
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
        %row vector denoting the number of nodes per layer
        nodesPerLayer;
        
        %row cell array denoting the activation function at each layer.
        %Note that the first element of this array is actually the
        %activation function at layer 2.
        activationFunctions;
        
        %cell array of weight matrices.  Note that the first element of
        %this array is actually the weights incoming to layer 2.
        weights;
        
        %row cell array of biases.  Note that the first element of this
        %array is actually the biases of layer 2.
        biases;
        
        %cell array of layer outputs
        layerOutputs;
    end
    
    %----------------------------------------------------------------------
    %Public Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
        %see nodesPerLayer
        NodesPerLayer
        
        %Number of layers in network
        NumLayers;
        
        %Number inputs to network
        NumInputs;
        
        %Number outputs of network
        NumOutputs;
        
    end
    
    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = NeuralNetwork(varargin)
            %NEURALNETWORK Constructor for the object
            %
            %   [OBJ] = NEURALNETWORK(nodesPerLayer) creates an object
            %
            %INPUT:     -nodesPerLayer:     row vector object
            %
            %OUTPUT:    -OBJ:               NeuralNetwork object
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %02/28/23: Changed initialization of weights and biases to rand
            %05/25/23: Moved initializing weights/biases to another method
            %05/27/23: Removed activation function at layer 1
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    nodesPerLayer = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            %nodesPerLayer
            assert(isvector(nodesPerLayer))
            assert(min(nodesPerLayer) >= 1)
            if(~isrow(nodesPerLayer))
                nodesPerLayer = nodesPerLayer';
            end
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Initialize random number generator so weights and biases are
            %deterministically set
            seed = 1;
            rng(seed);
            
            obj.nodesPerLayer   = nodesPerLayer;
            
            %Set activation functions
            activationFunctions = {};
            for k=1:length(nodesPerLayer)-1
                activationFunctions{1,k} = ActivationFunctionID.Sigmoid;
            end
            
            obj.activationFunctions = activationFunctions;
            
            %Initialize weights/biases
            methodID = WeightInitializationMethodID.Uniform;
            methodParams.LowerBound = -1;
            methodParams.UpperBound = 1;
            
            obj.InitializeWeightsAndBiases(methodID,methodParams);
            
            %Set layerOutputs (initially set these to NaN)
            layerOutputs = {};
            for L=1:length(nodesPerLayer)
                layerOutputs{L} = NaN*ones(nodesPerLayer(L),1);
            end
            
            obj.layerOutputs = layerOutputs;
        end
        
        %Get/Set
        function value = get.NodesPerLayer(obj)
            value = obj.nodesPerLayer;
        end
        
        function value = get.NumLayers(obj)
            value = length(obj.nodesPerLayer);
        end
        
        function value = get.NumInputs(obj)
            value = obj.nodesPerLayer(1);
        end
        
        function value = get.NumOutputs(obj)
            value = obj.nodesPerLayer(end);
        end
        
        %Class API
        function [] = display(obj)
            %DISPLAY  Define how object is displayed in the command window
            %
            %   DISPLAY() defines how the object is displayed in the
            %   command window.
            %
            %INPUT:     -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %05/27/23: Updated
            disp(['nodesPerLayer:       ',num2str(obj.nodesPerLayer)])
            
            disp(['activationFunctions: '])
            for L=1:obj.NumLayers
                disp(['  Layer ',num2str(L),' = '])
                if(L==1)
                    disp('     N/A')
                    disp(' ')
                else
                    disp(obj.GetActivationFunctionAtLayer(L))
                end
            end
            
            %Number of weights and biases in each layer
            disp('Number of weights and biases in network')
            totalParameters = 0;
            for L=2:obj.NumLayers
                W_L = obj.GetWeightsIncomingToLayer(L);
                b_L = obj.GetBiasesAtLayer(L);
                
                disp(['  Layer ',num2str(L),' has ',num2str(numel(W_L)),' incoming weights and ',num2str(numel(b_L)),' biases'])
                
                totalParameters = totalParameters + numel(W_L) + numel(b_L);
            end
            
            disp(['  Total number weights and biases = ',num2str(totalParameters)])
            disp(' ')
        end
        
        function [clonedObj] = Clone(obj)
            %CLONE Returns a cloned object
            %
            %   [CLONEDOBJ] = CLONE() creates a cloned object.
            %
            %INPUT:     -L:     layer of interest
            %
            %OUTPUT:    -N:     number of nodes in layer
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/08/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Save to disk, reload, then delete file
            tempFile = 'NeuralNetworkTempClone.mat';
            
            try
                save(tempFile,'obj');
                temp = load(tempFile);
                delete(tempFile);
                clonedObj = temp.obj;
                
            catch ME
                delete(tempFile);
                error(ME.message)
                
            end
            
            %Verify that these are unique objects
            assert(clonedObj~=obj,'clonedObj does not appear to be a unique clone');
            assert(isequal(clonedObj,obj),'Contents of clonedObj appear to be different than obj');
        end
        
        function [N] = GetNumNodesInLayer(obj,L)
            %GETNUMNODESINLAYER Get number of nodes in layer
            %
            %   [N] = GETNUMNODESINLAYER(L) gets the number of nodes in
            %   layer L.
            %
            %INPUT:     -L:     layer of interest
            %
            %OUTPUT:    -N:     number of nodes in layer
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            
            %--------------------BEGIN CALCULATIONS------------------------
            N = obj.nodesPerLayer(L);
        end
        
        function [SIGMA_ID] = GetActivationFunctionAtLayer(obj,L)
            %GETACTIVATIONFUNCTIONATLAYER Get ID of activation fcn
            %
            %   [SIGMA_ID] = GETACTIVATIONFUNCTIONATLAYER(L) gets the
            %   activation function ID at the layer L.
            %
            %INPUT:     -L:         layer of interest
            %
            %OUTPUT:    -SIGMA_ID:  ID of the activation function
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %05/27/23: Removed activation function at first layer
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            assert(L>1,'There is no activation function at layer 1')
            
            %--------------------BEGIN CALCULATIONS------------------------
            SIGMA_ID = obj.activationFunctions{L-1};
        end
        
        function [] = SetActivationFunctionAtLayer(obj,L,SIGMA_ID)
            %SETACTIVATIONFUNCTIONATLAYER Set ID of activation fcn
            %
            %   [] = SETACTIVATIONFUNCTIONATLAYER(L,SIGMA_ID) sets the
            %   activation function ID at the layer L.
            %
            %INPUT:     -L:         layer of interest
            %           -SIGMA_ID:  activation fcn ID (ActivationFunctionID)
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %03/03/23: Changed to inherit from handle
            %05/27/23: Removed activation function at first layer
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L));
            assert(L>1,'There is no activation function at layer 1')
            
            %SIGMA_ID
            assert(isa(SIGMA_ID,'ActivationFunctionID'));
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.activationFunctions{L-1} = SIGMA_ID;
        end
        
        function [] = SetActivationFunctionAtAllLayers(obj,SIGMA_ID)
            %SETACTIVATIONFUNCTIONATALLLAYERS Set ID of activation fcn
            %
            %   [] = SETACTIVATIONFUNCTIONATALLLAYERS(SIGMA_ID) sets the
            %   activation function ID at all layers of the network
            %
            %INPUT:     -SIGMA_ID:  activation fcn ID (ActivationFunctionID)
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %04/16/23: Created
            %05/27/23: Removed activation function at first layer
            
            %------------------CHECKING DATA FORMAT------------------------
            %SIGMA_ID
            assert(isa(SIGMA_ID,'ActivationFunctionID'));
            
            %--------------------BEGIN CALCULATIONS------------------------
            for L=2:obj.NumLayers
                obj.SetActivationFunctionAtLayer(L,SIGMA_ID);
            end
        end
        
        function [W_L] = GetWeightsIncomingToLayer(obj,L)
            %GETWEIGHTSINCOMINGTOLAYER Get weights matrix at a layer
            %
            %   [W_L] = GETWEIGHTSINCOMINGTOLAYER(L) gets the matrix of
            %   weights incoming to layer L.  In other words, these are the
            %   weights connecting layer L-1 to L.
            %
            %INPUT:     -L:     layer of interest
            %
            %OUTPUT:    -W_L:   weights incoming to layer L
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            assert(L>1,'There are no weights incoming to layer 1')
            
            %--------------------BEGIN CALCULATIONS------------------------
            W_L = obj.weights{L-1};
        end
        
        function [] = SetWeightsIncomingToLayer(obj,L,W_L)
            %SETWEIGHTSINCOMINGTOLAYER Set weights matrix at a layer
            %
            %   [] = SETWEIGHTSINCOMINGTOLAYER(L,W_L) sets the matrix of
            %   weights incoming to layer L.  In other words, these are the
            %   weights connecting layer L-1 to L.
            %
            %INPUT:     -L:     layer of interest
            %           -W_L:   weights incoming to layer L
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %03/03/23: Changed to inherit from handle
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            assert(L>1,'There are no weights incoming to layer 1')
            
            %W_L
            [M,N] = obj.sizeOfWeightsIncomingToLayer(L);
            [M2,N2] = size(W_L);
            assert(M==M2 && N==N2,'W_L dimensions are not consistent with this layer')
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.weights{L-1} = W_L;
        end
        
        function [] = InitializeWeightsAndBiases(varargin)
            %INITIALIZEWEIGHTSANDBIASES Initializes weights and biases
            %
            %   INITIALIZEWEIGHTSANDBIASES(METHOD_ID) initializes the
            %   weights and biases of the network using the specified
            %   METHOD_ID.
            %
            %   INITIALIZEWEIGHTSANDBIASES(METHOD_ID,METHOD_PARAMS) does
            %   as above but uses the METHOD_PARAMS struct for a given
            %   METHOD_ID.  Appropriate fields for the struct are as
            %   follows:
            %
            %       METHOD_ID = WeightInitializationMethodID.Uniform
            %           METHOD_PARAMS.LowerBound = lower limit
            %           METHOD_PARAMS.UpperBound = upper limit
            %
            %INPUT:     -METHOD_ID:     ID (WeightInitializationMethodID)
            %           -METHOD_PARAMS: structure of parameters
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %05/25/23: Created
            %06/11/23: Continued working
            
            %----------------------OBTAIN USER PREFERENCES-----------------------------
            switch nargin
                case 3
                    %User supplies all inputs
                    obj             = varargin{1};
                    METHOD_ID       = varargin{2};
                    METHOD_PARAMS   = varargin{3};
                    
                case 2
                    %Assume no parameters
                    obj             = varargin{1};
                    METHOD_ID       = varargin{2};
                    METHOD_PARAMS   = [];
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            %obj
            
            %METHOD_ID
            assert(isa(METHOD_ID,'WeightInitializationMethodID'));
            
            %METHOD_PARAMS
            
            %--------------------BEGIN CALCULATIONS------------------------
            switch METHOD_ID
                case WeightInitializationMethodID.Uniform
                    %What are the upper and lower bounds
                    if(isempty(METHOD_PARAMS))
                        %User default values of [-1,1]
                        LowerBound = -1;
                        UpperBound = 1;
                        
                    else
                        LowerBound = METHOD_PARAMS.LowerBound;
                        UpperBound = METHOD_PARAMS.UpperBound;
                        
                    end
                    
                    assert(UpperBound>=LowerBound);
                    
                    %Set weights (note the first element of weights is the
                    %weights incoming to layer 2)
                    weights = {};
                    for L=1:length(obj.nodesPerLayer)-1
                        %Randomize between [LowerBound,UpperBound]
                        weights{L} = rand2(LowerBound,UpperBound,obj.nodesPerLayer(L+1),obj.nodesPerLayer(L));
                    end
                    
                    obj.weights = weights;
                    
                    %Set biases (note the first element of biases is the
                    %biases in layer 2)
                    biases = {};
                    for L=1:length(obj.nodesPerLayer)-1
                        %Randomize between [LowerBound,UpperBound]
                        biases{L} = rand2(LowerBound,UpperBound,obj.nodesPerLayer(L+1),1);
                    end
                    
                    obj.biases = biases;
                    
                case WeightInitializationMethodID.Glorot
                    assert(isempty(METHOD_PARAMS),'There are no method parameters for this method')
                    
                    %Set weights (note the first element of weights is the
                    %weights incoming to layer 2)
                    %
                    %Set biases (note the first element of biases is the
                    %biases in layer 2)
                    weights = {};
                    for L=1:length(obj.nodesPerLayer)-1
                        n = obj.GetNumNodesInLayer(L);
                        
                        LowerBound = -1/sqrt(n);
                        UpperBound = -LowerBound;
                        
                        %Randomize between [LowerBound,UpperBound]
                        weights{L} = rand2(LowerBound,UpperBound,obj.nodesPerLayer(L+1),obj.nodesPerLayer(L));
                        biases{L} = rand2(LowerBound,UpperBound,obj.nodesPerLayer(L+1),1);
                    end
                    
                    obj.weights = weights;
                    obj.biases = biases;
                    
                otherwise
                    error('Unsupported METHOD_ID')
            end
            
        end
        
        function [FIGH] = HistogramWeightsAndBiases(varargin)
            %HISTOGRAMWEIGHTSANDBIASES Creates a histogram of weight/bias
            %
            %   [FIGH] = HISTOGRAMWEIGHTSANDBIASES() Creates a histogram of
            %   the weights and biases in the network.
            %
            %   [...] = HISTOGRAMWEIGHTSANDBIASES(FIGH) does as above but
            %   uses the existing figure specified by FIGH.  This is useful
            %   for overplots.
            %
            %INPUT:     -FIGH: figure handle
            %
            %OUTPUT:    -FIGH: figure handle
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %05/27/23: Created
            %07/30/23: Updated title
            
            %----------------------OBTAIN USER PREFERENCES-----------------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    obj     = varargin{1};
                    FIGH    = varargin{2};
                    
                case 1
                    %Assume new figure
                    obj     = varargin{1};
                    FIGH    = -1;
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            %FIGH
            
            %--------------------BEGIN CALCULATIONS------------------------
            if(FIGH==-1)
                %New figure
                FIGH = figure;
            else
                %overplot
                figure(FIGH)
            end
            
            subplotIdx = 1;
            for L=2:obj.NumLayers
                W_L = obj.GetWeightsIncomingToLayer(L);
                b_L = obj.GetBiasesAtLayer(L);
                
                %Flatten weights
                [M,N] = size(W_L);
                W_L_flat = reshape(W_L,M*N,1);
                
                numBins = 20;
                subplot(obj.NumLayers-1,2,subplotIdx)
                hold on
                histogram(W_L_flat,numBins);
                legend(['W in layer',num2str(L)])
                grid on
                
                if(L==2)
                    title('NeuralNetwork.HistogramWeightsAndBiases')
                end
                
                subplot(obj.NumLayers-1,2,subplotIdx+1)
                hold on
                histogram(b_L,numBins)
                legend(['b in layer ',num2str(L)])
                grid on
                
                subplotIdx = subplotIdx + 2;
            end
        end
        
        function [b_L] = GetBiasesAtLayer(obj,L)
            %GETBIASESATLAYER Get biases at a layer
            %
            %   [b_L] = GETBIASESATLAYER(L) gets the vector of biases at
            %   layer L.
            %
            %INPUT:     -L:     layer of interest
            %
            %OUTPUT:    -b_L:   biases at layer L
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            assert(L>1,'There are no biases at layer 1')
            
            %--------------------BEGIN CALCULATIONS------------------------
            b_L = obj.biases{L-1};
        end
        
        function [] = SetBiasesAtLayer(obj,L,b_L)
            %SETBIASESATLAYER Set the biases at a layer
            %
            %   [] = SETBIASESATLAYER(L,b_L) sets the biases at layer L.
            %
            %INPUT:     -L:     layer of interest
            %           -b_L:   biases at layer L
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %03/03/23: Changed to inherit from handle
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            assert(L>1,'There are no biases at layer 1')
            
            %b_L
            assert(iscolumn(b_L))
            assert(length(b_L)==obj.GetNumNodesInLayer(L),'b_L dimensions are not consistent with this layer')
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.biases{L-1} = b_L;
        end
        
        function [y_L] = GetOutputsAtLayer(obj,L)
            %GETOUTPUTSATLAYER Gets the outputs at layer
            %
            %   [y_L] = GETOUTPUTSATLAYER(L) gets the outputs at layer L.
            %
            %   Note that before calling this method, you should call
            %   ForwardPropagate to set/store the outputs of all the
            %   layers.
            %
            %INPUT:     -L:     layer of interest
            %
            %OUTPUT:    -y_L:   outputs at layer
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            
            %--------------------BEGIN CALCULATIONS------------------------
            y_L = obj.layerOutputs{L};
        end
        
        function [] = SetOutputsAtLayer(obj,L,y_L)
            %SETOUTPUTSATLAYER Set outputs at layer
            %
            %   [] = SETOUTPUTSATLAYER(L,y_L) sets the outputs at layer
            %   L.
            %
            %INPUT:     -L:     layer of interest
            %OUTPUT:    -y_L:   outputs at layer
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %03/03/23: Changed to inherit from handle
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L))
            
            %y_L
            assert(iscolumn(y_L))
            assert(length(y_L)==obj.GetNumNodesInLayer(L))
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.layerOutputs{L} = y_L;
        end
        
        function [y] = GetOutputsAtLastLayer(obj)
            %GETOUTPUTSATLASTLAYER Gets the outputs at last layer
            %
            %   [y] = GETOUTPUTSATLASTLAYER() gets the outputs at the last
            %   layer. This is the output of the network.
            %
            %   Note that before calling this method, you should call
            %   ForwardPropagate to set/store the outputs of all the
            %   layers.
            %
            %INPUT:     -None
            %
            %OUTPUT:    -y:     outputs at last layer
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/28/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            
            %--------------------BEGIN CALCULATIONS------------------------
            y = obj.GetOutputsAtLayer(obj.NumLayers);
        end
        
        function [z_L] = GetNodeStatesAtLayer(obj,L)
            %GETNODESTATESATLAYER Gets the node states at layer
            %
            %   [z_L] = GETNODESTATESATLAYER(L) gets the node states at
            %   layer L.
            %
            %   Note that before calling this method, you should call
            %   ForwardPropagate to set/store the outputs of all the
            %   layers.
            %
            %INPUT:     -L:     layer of interest
            %
            %OUTPUT:    -z_L:   node states at layer
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/01/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %L
            assert(obj.isValidLayerNumber(L));
            assert(L>1,'There are no states at the first layer of nodes');
            
            %--------------------BEGIN CALCULATIONS------------------------
            W_L         = obj.GetWeightsIncomingToLayer(L);
            y_L_minus_1 = obj.GetOutputsAtLayer(L-1);
            b_L         = obj.GetBiasesAtLayer(L);
            
            z_L = W_L*y_L_minus_1 + b_L;
        end
        
        function [] = SetWeightsAndBiasesBasedOnOtherNN(obj,otherNN)
            %SETWEIGHTSANDBIASESBASEDONOTHERNN Sets W and b
            %
            %   [] = SETWEIGHTSANDBIASESBASEDONOTHERNN(otherNN) sets this
            %   objects weights and biases to match the otherNN (another
            %   NeuralNetwork object).
            %
            %INPUT:     -otherNN:   other NeuralNetwork object
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/09/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %otherNN
            assert(isa(otherNN,'NeuralNetwork'));
            
            %--------------------BEGIN CALCULATIONS------------------------
            for L=2:obj.NumLayers
                assert(obj.GetNumNodesInLayer(L)==otherNN.GetNumNodesInLayer(L),'otherNN does not appear to have the same network structure as obj');
                
                W_L = otherNN.GetWeightsIncomingToLayer(L);
                b_L = otherNN.GetBiasesAtLayer(L);
                
                obj.SetWeightsIncomingToLayer(L,W_L);
                obj.SetBiasesAtLayer(L,b_L);
            end
        end
        
        function [y] = ForwardPropagate(obj,u)
            %FORWARDPROPAGATE Evaluates the network
            %
            %   [y] = FORWARDPROPAGATE(u) Evaluates the network by forward
            %   propagating the input signal u.
            %
            %   Note as a side effect, this sets the .layerOutputs.  This
            %   is useful and can be used for back propagation.
            %
            %INPUT:     -u: vector of input values (a single sample)
            %
            %OUTPUT:    -y: output at last layer
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            %02/28/23: Continued working
            %03/03/23: Changed to inherit from handle
            %03/04/23: Minor update
            %03/15/23: Minor update to documentation
            
            %------------------CHECKING DATA FORMAT------------------------
            %u
            assert(iscolumn(u))
            assert(length(u)==obj.GetNumNodesInLayer(1),'u must have the same number of elements as the number of nodes in layer 1')
            
            %--------------------BEGIN CALCULTIONS------------------------
            %Set the first layer outputs to be equal to the input
            obj.SetOutputsAtLayer(1,u);
            
            for L=2:obj.NumLayers
                y_L_minus_1 = obj.GetOutputsAtLayer(L-1);
                
                W_L = obj.GetWeightsIncomingToLayer(L);
                b_L = obj.GetBiasesAtLayer(L);
                
                z_L = W_L*y_L_minus_1 + b_L;
                
                switch obj.GetActivationFunctionAtLayer(L)
                    case ActivationFunctionID.Sigmoid
                        y_L = Sigmoid(z_L);
                        
                    case ActivationFunctionID.ReLU
                        y_L = ReLU(z_L);
                        
                    otherwise
                        error('Activation function not supported')
                end
                
                obj.SetOutputsAtLayer(L,y_L);
            end
            
            y = obj.GetOutputsAtLastLayer();
        end
        
        function [dEc_dW,dEc_db] = BackPropagate(obj,u,d,errorFunctionID)
            %BACKPROPAGATE Performs back propagation to obtain the gradient
            %
            %   [dEc_dW,dEc_db] = BACKPROPAGATE(u,y,errorFunctionID)
            %   Compute the gradient of the error function w.r.t. the
            %   weights and biases for the example/sample (u,d).  This uses
            %   a single example of u and d to compute the error.
            %
            %   The outputs dEc_dW and dEc_db are cell arrays that capture
            %   the gradients at the various layers.  Note that because
            %   there are no weights incoming to layer 1 (and there are no
            %   biases at layer 1), the first entry of these two cell
            %   arrays are actually the gradients w.r.t. the weights
            %   incoming to layer 2 (and the biases at layer 2).
            %
            %       dEc_dW{k} = gradient w.r.t. weights incoming to layer k+1
            %       dEc_db{k} = gradient w.r.t. biases at layer k+1
            %
            %INPUT:     -u:                 vector of input vals (single sample)
            %           -d:                 desired output at last layer (label)
            %           -errorFunctionID:   ErrorFunctionID object
            %
            %OUTPUT:    -dEc_dW:            cell array of gradients w.r.t. weights
            %           -dEc_db:            cell array of gradients w.r.t. biases
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/04/23: Created
            %03/15/23: Added errorFunctionID
            %05/10/23: Added support for ReLU
            
            %------------------CHECKING DATA FORMAT------------------------
            %u
            assert(iscolumn(u))
            assert(length(u)==obj.GetNumNodesInLayer(1),'u must have the same number of elements as the number of nodes in layer 1')
            
            %d
            assert(iscolumn(d))
            assert(length(d)==obj.GetNumNodesInLayer(obj.NumLayers),'d must have the same number of elements as the number of nodes in last layer')
            
            %errorFunctionID
            assert(isa(errorFunctionID,'ErrorFunctionID'))
            
            %--------------------BEGIN CALCULTIONS------------------------
            obj.ForwardPropagate(u);
            y_L = obj.GetOutputsAtLastLayer();
            
            %Initialize based on desired error function
            switch errorFunctionID
                case ErrorFunctionID.SquaredError
                    dEc_dy_L = y_L - d;
                    
                otherwise
                    error('Unsupported ErrorFunctionID')
            end
            
            %Back propagate through layers
            dEc_dW = {};
            dEc_db = {};
            for k=1:obj.NumLayers-1
                L           = obj.NumLayers + 1 - k;
                y_L         = obj.GetOutputsAtLayer(L);
                y_L_minus_1 = obj.GetOutputsAtLayer(L-1);
                W_L         = obj.GetWeightsIncomingToLayer(L);
                
                switch obj.GetActivationFunctionAtLayer(L)
                    case ActivationFunctionID.Sigmoid
                        dsigma_L_dz_L = y_L.*(1-y_L);
                        
                    case ActivationFunctionID.ReLU
                        b_L = obj.GetBiasesAtLayer(L);
                        z_L = W_L*y_L_minus_1 + b_L;
                        
                        %Faster computation of piecewise function
                        dsigma_L_dz_L = double(z_L>0);
                        
                    otherwise
                        error('Activation function not supported')
                end
                
                dEc_dz_L = dEc_dy_L.*dsigma_L_dz_L;
                
                matrixA = repmat(dEc_dz_L,1,obj.GetNumNodesInLayer(L-1));
                matrixB = repmat(y_L_minus_1',obj.GetNumNodesInLayer(L),1);
                
                dEc_dW_L = matrixA.*matrixB;
                dEc_db_L = dEc_dz_L;
                
                dEc_dW{L-1} = dEc_dW_L;
                dEc_db{L-1} = dEc_db_L;
                
                dEc_dy_L_minus_1 = W_L'*dEc_dz_L;
                
                %Setup for next iteration
                dEc_dy_L = dEc_dy_L_minus_1;
            end
        end
        
        function [dEc_dW,dEc_db] = GradientNumerical(obj,u,d,errorFunctionID)
            %GRADIENTNUMERICAL Computes gradient via numerical perturbation
            %
            %   [dEc_dW,dEc_db] = GRADIENTNUMERICAL(u,d,errorFunctionID)
            %   Compute the gradient of the error function w.r.t. the
            %   weights and biases for the example/sample (u,d).  This uses
            %   a single example of u and d to compute the error.  This
            %   calculate the gradient via numerical perturbation.
            %
            %   The outputs dEc_dW and dEc_db are cell arrays that capture
            %   the gradients at the various layers.  Note that because
            %   there are no weights incoming to layer 1 (and there are no
            %   biases at layer 1), the first entry of these two cell
            %   arrays are actually the gradients w.r.t. the weights
            %   incoming to layer 2 (and the biases at layer 2).
            %
            %       dEc_dW{k} = gradient w.r.t. weights incoming to layer k+1
            %       dEc_db{k} = gradient w.r.t. biases at layer k+1
            %
            %INPUT:     -u:                 vector of input values
            %           -d:                 desired output at last layer (label)
            %           -errorFunctionID:   ErrorFunctionID object
            %
            %OUTPUT:    -dEc_dW:            cell array of gradients w.r.t. weights
            %           -dEc_db:            cell array of gradients w.r.t. biases
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/05/23: Created
            %03/09/23: Continued working
            %03/10/23: Continued working
            
            %------------------CHECKING DATA FORMAT------------------------
            %u
            assert(iscolumn(u))
            assert(length(u)==obj.GetNumNodesInLayer(1),'u must have the same number of elements as the number of nodes in layer 1')
            
            %d
            assert(iscolumn(d))
            assert(length(d)==obj.GetNumNodesInLayer(obj.NumLayers),'d must have the same number of elements as the number of nodes in last layer')
            
            %errorFunctionID
            assert(isa(errorFunctionID,'ErrorFunctionID'))
            
            %--------------------BEGIN CALCULTIONS------------------------
            obj.ForwardPropagate(u);
            
            %get a clone of the nominal network and compute error of
            %nominal network
            nn_o    = obj.Clone();
            y_o     = nn_o.GetOutputsAtLastLayer();
            E_o     = NeuralNetwork.Error(y_o,d,errorFunctionID);
            
            %numerically compute gradient w.r.t. weights and biases
            Delta_W = 10e-8;
            Delta_b = 10e-8;
            dEc_dW = {};
            dEc_db = {};
            for L=2:obj.NumLayers
                W_L_o = nn_o.GetWeightsIncomingToLayer(L);
                b_L_o = nn_o.GetBiasesAtLayer(L);
                
                %compute Deltas due to weights
                [M,N] = size(W_L_o);
                dEc_dW_L = zeros(M,N);
                for m=1:M
                    for n=1:N
                        %Reset obj to original values
                        obj.SetWeightsAndBiasesBasedOnOtherNN(nn_o);
                        
                        %Perturb weight W_L(m,n)
                        W_L_perturb = W_L_o;
                        W_L_perturb(m,n) = W_L_o(m,n) + Delta_W;
                        
                        %set weights to perturbed values
                        obj.SetWeightsIncomingToLayer(L,W_L_perturb);
                        
                        %biases remain at nominal values
                        obj.SetBiasesAtLayer(L,b_L_o);
                        
                        %forward propagate and compute output
                        y = obj.ForwardPropagate(u);
                        
                        %Compute error
                        [E_perturb] = NeuralNetwork.Error(y,d,errorFunctionID);
                        
                        %Compute gradient via finite difference
                        Delta_E = E_perturb - E_o;
                        
                        dEc_dW_L(m,n) = Delta_E/Delta_W;
                    end
                end
                
                dEc_dW{L-1} = dEc_dW_L;
                
                %compute Deltas due to biases
                [M,N] = size(b_L_o);
                assert(N==1)
                dEc_db_L = zeros(M,1);
                for m=1:M
                    %Reset obj to original values
                    obj.SetWeightsAndBiasesBasedOnOtherNN(nn_o);
                    
                    %Perturb bias b_L(m)
                    b_L_perturb = b_L_o;
                    b_L_perturb(m,1) = b_L_o(m,1) + Delta_b;
                    
                    %weights remain at nominal values
                    obj.SetWeightsIncomingToLayer(L,W_L_o);
                    
                    %set biases to perturbed values
                    obj.SetBiasesAtLayer(L,b_L_perturb);
                    
                    %forward propagate and compute output
                    y = obj.ForwardPropagate(u);
                    
                    %Compute error
                    [E_perturb] = NeuralNetwork.Error(y,d,errorFunctionID);
                    
                    %Compute gradient via finite difference
                    Delta_E = E_perturb - E_o;
                    
                    dEc_db_L(m,1) = Delta_E/Delta_b;
                end
                
                dEc_db{L-1} = dEc_db_L;
            end
            
            %reset this obj to the original state
            obj.SetWeightsAndBiasesBasedOnOtherNN(nn_o);
            
        end
        
        function [dE_dW,dE_db] = GradientMiniBatch(obj,u_data,d_data,errorFunctionID)
            %GRADIENTMINIBATCH Computes gradient via mini-batch
            %
            %   [dE_dW,dE_db] = GRADIENTMINIBATCH(u_data,d_data,errorFunctionID)
            %   Compute the gradient of the error function w.r.t. the
            %   weights and biases for the examples/samples (u_data,d_data)
            %
            %   General notes:
            %       -u_data and d_data should be arraged so each row
            %        corresponds to an individual training example.
            %       -This function uses all the data in u_data and d_data
            %        to compute the gradient
            %       -This gradient is based on multiple data points, not a
            %       single point.  As such, the subscript c is dropped from
            %       the output variables.
            %
            %   The outputs dE_dW and dE_db are cell arrays that capture
            %   the gradients at the various layers.  Note that because
            %   there are no weights incoming to layer 1 (and there are no
            %   biases at layer 1), the first entry of these two cell
            %   arrays are actually the gradients w.r.t. the weights
            %   incoming to layer 2 (and the biases at layer 2).
            %
            %       dE_dW{k} = gradient w.r.t. weights incoming to layer k+1
            %       dE_db{k} = gradient w.r.t. biases at layer k+1
            %
            %INPUT:     -u_data:            matrix of input values
            %           -d_data:            matrix of desired outputs at
            %                               last layer (labels)
            %           -errorFunctionID:   ErrorFunctionID object
            %
            %OUTPUT:    -dE_dW:            cell array of gradients w.r.t. weights
            %           -dE_db:            cell array of gradients w.r.t. biases
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %05/06/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %obj
            assert(isa(obj,'NeuralNetwork'))
            
            %u_data
            [M_u_data,N_u_data] = size(u_data);
            
            %d_data
            [M_d_data,N_d_data] = size(d_data);
            
            assert(M_u_data==M_d_data,'u_data and d_data should have the same number of rows (AKA number training examples)')
            assert(N_u_data==obj.NumInputs,'u_data should have same number of columns as the number of inputs to NeuralNetwork')
            assert(N_d_data==obj.NumOutputs,'d_data should have same number of columns as the number of outputs from NeuralNetwork')
            
            %errorFunctionID
            assert(isa(errorFunctionID,'ErrorFunctionID'))
            
            %--------------------BEGIN CALCULTIONS------------------------
            dE_dW_c_data = {};
            dE_db_c_data = {};
            
            %Compute gradient for each sample point
            for c=1:M_u_data
                u_c = u_data(c,:)';
                d_c = d_data(c,:)';
                [dEc_dW,dEc_db] = obj.BackPropagate(u_c,d_c,errorFunctionID);
                
                dE_dW_c_data = CatCellArrayOf2DMatrices(dE_dW_c_data,dEc_dW);
                dE_db_c_data = CatCellArrayOf2DMatrices(dE_db_c_data,dEc_db);
            end
            
            %Average the individual gradients
            dE_dW = {};
            dE_db = {};
            for k=1:length(dE_dW_c_data)
                W = dE_dW_c_data{k};
                b = dE_db_c_data{k};
                
                %average along dimension 3
                W_ave = AverageMatrixAlongDim3(W);
                b_ave = AverageMatrixAlongDim3(b);
                
                dE_dW{1,end+1} = W_ave;
                dE_db{1,end+1} = b_ave;
            end
            
        end
        
        function [varargout] = TrainNeuralNetwork(varargin)
            %TRAINNEURALNETWORK Trains the network
            %
            %   [E_data,norm_gradient_data] = TRAINNEURALNETWORK(
            %   u_data,d_data,options) trains the neural network using all
            %   the data specified by u_data, d_data and options.
            %
            %   General notes:
            %       -u_data and d_data should be arraged so each row
            %        corresponds to an individual training example.
            %       -This function uses all the data in u_data and d_data
            %        to train the network.
            %       -Because the NeuralNetwork derives from the handle
            %        class, this function directly manipulates the weights
            %        of the input/reference object.
            %
            %   Notes on 'options'
            %       .errorFunctionID = error function ID
            %       .numSubSteps = number of steps to take at each
            %                      iteration.  This corresponds to the
            %                      number of steps to take in the numerical
            %                      optimization problem.
            %       .eta = step size (AKA learning rate).  Must be positive
            %       .miniBatchSize = number of samples in a mini-batch
            %       .displayProgress = true, disp progress to command window
            %
            %INPUT:     -u_data:            matrix of input values
            %           -d_data:            matrix of desired outputs at
            %                               last layer (labels)
            %           -options:           structure with options
            %
            %OUTPUT:    -E_data:            data of error at each iteration
            %           -norm_gradient_data: data of norm gradient at each
            %                                iteration
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %04/16/23: Created
            %05/06/23: Added support for mini-batch training
            
            %----------------------OBTAIN USER PREFERENCES-----------------
            switch nargin
                case 4
                    %User supplies all inputs
                    obj     = varargin{1};
                    u_data  = varargin{2};
                    d_data  = varargin{3};
                    options = varargin{4};
                    
                case 3
                    %Assume standard options
                    obj     = varargin{1};
                    u_data  = varargin{2};
                    d_data  = varargin{3};
                    
                    optionsStandard.errorFunctionID = ErrorFunctionID.SquaredError;
                    optionsStandard.numSubSteps     = 1;
                    optionsStandard.eta             = 1;
                    optionsStandard.miniBatchSize   = 1;
                    optionsStandard.displayProgress = false;
                    
                    options = optionsStandard;
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            %obj
            assert(isa(obj,'NeuralNetwork'))
            
            %u_data
            [M_u_data,N_u_data] = size(u_data);
            
            %d_data
            [M_d_data,N_d_data] = size(d_data);
            
            assert(M_u_data==M_d_data,'u_data and d_data should have the same number of rows (AKA number training examples)')
            assert(N_u_data==obj.NumInputs,'u_data should have same number of columns as the number of inputs to NeuralNetwork')
            assert(N_d_data==obj.NumOutputs,'d_data should have same number of columns as the number of outputs from NeuralNetwork')
            
            %options
            assert(isa(options.errorFunctionID,'ErrorFunctionID'))
            assert(options.numSubSteps>=1)
            assert(options.eta>0)
            assert(options.miniBatchSize>=1)
            assert(isinteger2(options.miniBatchSize))
            
            %--------------------BEGIN CALCULTIONS-------------------------
            numIterations = floor(M_u_data/options.miniBatchSize);
            
            E_data              = [];
            norm_gradient_data  = [];
            
            deltaFraction = 0.05;        %gradularity in displaying progress
            currentFractionThreshold = 1*deltaFraction;
            miniBatchStartIdx = 1;
            for k=1:numIterations
                %Get current mini-batch
                miniBatchEndIdx = miniBatchStartIdx + options.miniBatchSize - 1;
                u_miniBatch = u_data(miniBatchStartIdx:miniBatchEndIdx,:);
                d_miniBatch = d_data(miniBatchStartIdx:miniBatchEndIdx,:);
                miniBatchStartIdx = miniBatchEndIdx + 1;
                
                for m=1:options.numSubSteps
                    %Compute gradient
                    if(options.miniBatchSize==1)
                        %just use stochastic gradient descent as this is
                        %faster
                        [dE_dW,dE_db] = obj.BackPropagate(u_miniBatch(1,:)',d_miniBatch(1,:)',options.errorFunctionID);                    %
                    else
                        [dE_dW,dE_db] = obj.GradientMiniBatch(u_miniBatch,d_miniBatch,options.errorFunctionID);
                    end
                    
                    %Take optmization gradient descent step (AKA update weights and biases)
                    for n=1:obj.NumLayers-1
                        L = n+1;
                        
                        W_L = obj.GetWeightsIncomingToLayer(L);
                        b_L = obj.GetBiasesAtLayer(L);
                        
                        dE_dW_L = dE_dW{n};   %output from BackPropagate is off by 1
                        dE_db_L = dE_db{n};   %output from BackPropagate is off by 1
                        
                        W_L_prime = W_L - options.eta*dE_dW_L;
                        b_L_prime = b_L - options.eta*dE_db_L;
                        
                        obj.SetWeightsIncomingToLayer(L,W_L_prime);
                        obj.SetBiasesAtLayer(L,b_L_prime);
                    end
                end
                
                %Compute various performance metrics at the end of this
                %iteration
                [norm_dE_dW,norm_dE_db] = NeuralNetwork.GradientNorm(dE_dW,dE_db);
                
                %compute the average error over this mini-batch
                E = [];
                for c=1:options.miniBatchSize
                    u_c = u_miniBatch(c,:)';
                    d_c = d_miniBatch(c,:)';
                    y_c = obj.ForwardPropagate(u_c);
                    E(end+1) = NeuralNetwork.Error(y_c,d_c,options.errorFunctionID);
                end
                
                E_data(:,end+1)             = sum(E)/length(E);
                norm_gradient_data(:,end+1) = norm_dE_dW + norm_dE_db;
                
                %Display progress
                if(options.displayProgress)
                    fractionComplete = k/numIterations;
                    
                    if(fractionComplete > currentFractionThreshold)
                        disp([num2str(fractionComplete*100),'% complete'])
                        currentFractionThreshold = currentFractionThreshold + deltaFraction;
                    end
                end                
            end
            
            %Transpose data so it is consistent with inputs
            E_data              = E_data';
            norm_gradient_data  = norm_gradient_data';
            
            %Output objects
            varargout{1} = E_data;
            varargout{2} = norm_gradient_data;
        end
        
        function [varargout] = TrainNeuralNetworkMultiEpoch(varargin)
            %TRAINNEURALNETWORKMULTIEPOCH Trains over multiple epochs
            %
            %   [E_data,norm_gradient_data] = TRAINNEURALNETWORKMULTIEPOCH(
            %   u_data,d_data,options) trains the neural network in a
            %   fashion similar to NeuralNetwork.TrainNeuralNetwork except
            %   it trains over multiple epochs.
            %
            %   General notes:
            %       -See NeuralNetwork.TrainNeuralNetwork.
            %
            %   Notes on 'options' (fields are the same as
            %   NeuralNetwork.TrainNeuralNetwork except the following are
            %   additional fields that can be specified)
            %       .numEpochs = error function ID
            %
            %INPUT:     -u_data:            matrix of input values
            %           -d_data:            matrix of desired outputs at
            %                               last layer (labels)
            %           -options:           structure with options
            %
            %OUTPUT:    -E_data:            data of error at each iteration
            %           -norm_gradient_data: data of norm gradient at each
            %                                iteration
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %05/07/23: Created
            %05/24/23: Updated documentation
            
            %----------------------OBTAIN USER PREFERENCES-----------------
            switch nargin
                case 4
                    %User supplies all inputs
                    obj     = varargin{1};
                    u_data  = varargin{2};
                    d_data  = varargin{3};
                    options = varargin{4};
                    
                case 3
                    %Assume standard options
                    obj     = varargin{1};
                    u_data  = varargin{2};
                    d_data  = varargin{3};
                    
                    optionsStandard.errorFunctionID = ErrorFunctionID.SquaredError;
                    optionsStandard.numSubSteps     = 1;
                    optionsStandard.eta             = 1;
                    optionsStandard.miniBatchSize   = 1;
                    optionsStandard.numEpochs       = 1;
                    optionsStandard.displayProgress = false;
                    
                    options = optionsStandard;
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            %obj
            %Checked by NeuralNetwork.TrainNeuralNetwork
            
            %u_data
            %Checked by NeuralNetwork.TrainNeuralNetwork
            
            %d_data
            %Checked by NeuralNetwork.TrainNeuralNetwork
            
            %options
            %Checked by NeuralNetwork.TrainNeuralNetwork
            assert(options.numEpochs>=1)
            assert(isinteger2(options.numEpochs))
            
            %--------------------BEGIN CALCULTIONS-------------------------
            [M_u_data,N_u_data] = size(u_data);
            
            E_data              = [];
            norm_gradient_data  = [];
            for k=1:options.numEpochs
                if(k>=2)
                    %Shuffle the training data on 2nd or higher epoch
                    P = randperm(M_u_data);
                    u_data = u_data(P,:);
                    d_data = d_data(P,:);
                end
                
                %Train on this epoch
                [E_data_k,norm_gradient_data_k] = obj.TrainNeuralNetwork(u_data,d_data,options);
                
                E_data              = [E_data;E_data_k];
                norm_gradient_data  = [norm_gradient_data;norm_gradient_data_k];
                
                %Display progress
                if(options.displayProgress)
                    disp(['Completed epoch ',num2str(k),' out of ',num2str(options.numEpochs)])
                end
            end
            
            %Output objects
            varargout{1} = E_data;
            varargout{2} = norm_gradient_data;
        end        
    end
    
    %----------------------------------------------------------------------
    %Private methods
    %----------------------------------------------------------------------
    methods (Access='private')
        function [ISVALID] = isValidLayerNumber(obj,L)
            %ISVALIDLAYERNUMBER Checks if L is valid or not
            %
            %   [ISVALID] = ISVALIDLAYERNUMBER(L) Checks if L is valie or
            %   not.
            %
            %INPUT:     -L: layer number
            %
            %OUTPUT:    -ISVALID
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            
            %-------------------CHECKING DATA FORMAT-----------------------
            
            
            %---------------------BEGIN CALCULATIONS-----------------------
            if(~isscalar(L))
                ISVALID = false;
                return
            end
            
            if(L>obj.NumLayers || L<1)
                ISVALID = false;
                return
            end
            
            %all checks pass
            ISVALID = true;
        end
        
        function [M,N] = sizeOfWeightsIncomingToLayer(obj,L)
            %SIZEOFWEIGHTSINCOMINGTOLAYER Size of weights matrix
            %
            %   [M,N] = SIZEOFWEIGHTSINCOMINGTOLAYER(L) determines the
            %   number of rows (M) and columns (N) of the weight matrix
            %   incoming to layer L.
            %
            %INPUT:     -L: layer number
            %
            %OUTPUT:    -M: number of rows
            %           -N: number of cols
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %02/26/23: Created
            
            %-------------------CHECKING DATA FORMAT-----------------------
            
            
            %---------------------BEGIN CALCULATIONS-----------------------
            M = obj.GetNumNodesInLayer(L);
            N = obj.GetNumNodesInLayer(L-1);
        end
    end
    
    
    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
        function [E] = Error(y_data,d_data,errorFunctionID)
            %ERROR Computes the error
            %
            %   [E] = ERROR(y_data,d_data,errorFunctionID) Computes the
            %   error for the various outputs y_data and desired outputs
            %   d_data using the specified errorFunctionID.
            %
            %   Note that y_data and d_data should be matrices with each
            %   example/datapoint as a separate column
            %
            %                [  |   |   |    |  ]
            %       y_data = [ y_1 y_2 ... y_Ns ]
            %                [  |   |   |    |  ]
            %
            %INPUT:     -y_data:            matrix of output values
            %           -d_data:            matrix of desired output values
            %           -errorFunctionID:   type of error metric to compute
            %
            %OUTPUT:    -E:                 error
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/10/23: Created
            %05/05/23: Added case for ErrorFunctionID.MeanSquaredError
            %05/06/23: Changed terminology to better fit notes
            
            %------------------CHECKING DATA FORMAT------------------------
            %y_data
            [M_y_data,N_y_data] = size(y_data);
            
            %d_data
            [M_d_data,N_d_data] = size(d_data);
            assert((M_y_data==M_d_data) && (N_y_data==N_d_data),...
                'y_data and d_data should have the same dimensions');
            
            N_s = N_y_data;
            
            %errorFunctionID
            assert(isa(errorFunctionID,'ErrorFunctionID'));
            
            %--------------------BEGIN CALCULTIONS------------------------
            switch errorFunctionID
                case ErrorFunctionID.SquaredError
                    
                    E = 0;
                    for k=1:N_s
                        y_c = y_data(:,k);
                        d_c = d_data(:,k);
                        r_c = y_c - d_c;
                        
                        %squared error for this single example
                        E_c = (1/2)*norm(r_c)^2;
                        
                        %accumulate total error
                        E = E + E_c;
                    end
                    
                case ErrorFunctionID.MeanSquaredError
                    E_absolute = NeuralNetwork.Error(y_data,d_data,ErrorFunctionID.SquaredError);
                    
                    [~,ns] = size(y_data);
                    E = (1/ns)*E_absolute;
                    
                otherwise
                    error('Unsupported ErrorFunctionID')
            end
        end
        
        function [norm_dEc_dW,norm_dEc_db] = GradientNorm(dEc_dW,dEc_db)
            %GRADIENTNUMERICAL Computes gradient via numerical perturbation
            %
            %   [norm_dEc_dW,norm_dEc_db] = GRADIENTNORM(dEc_dW,dEc_db)
            %   computes the norm of the gradient.
            %
            %   See NeuralNetwork.BackPropagate for definition of dEc_dW
            %   and dEc_db.
            %
            %INPUT:     -dEc_dW:        cell array of gradients w.r.t. weights
            %           -dEc_db:        cell array of gradients w.r.t. biases
            %
            %OUTPUT:    -norm_dEc_dW:   cell array of gradients w.r.t. weights
            %           -norm_dEc_db:   cell array of gradients w.r.t. biases
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %03/15/23: Created
            
            %------------------CHECKING DATA FORMAT------------------------
            %dEc_dW
            assert(isa(dEc_dW,'cell'));
            
            %dEc_db
            assert(isa(dEc_db,'cell'));
            
            %--------------------BEGIN CALCULTIONS------------------------
            vec_dEc_dW = [];
            vec_dEc_db = [];
            for k=1:length(dEc_dW)
                dEc_dW_k = dEc_dW{k};
                dEc_db_k = dEc_db{k};
                
                %Check that dimensions are consistent
                [numNodes,M]    = size(dEc_dW_k);
                [numNodes2,M2]  = size(dEc_db_k);
                
                assert(numNodes==numNodes2);
                assert(M2==1);
                
                %Reshape dEc_db_W into a vector (dEc_db_k is already a vec)
                vec_dEc_dW_k = reshape(dEc_dW_k,numNodes*M,1);
                
                %Stack into large vector
                vec_dEc_dW = [vec_dEc_dW;vec_dEc_dW_k];
                vec_dEc_db = [vec_dEc_db;dEc_db_k];
            end
            
            %Compute the norm of the vectors
            norm_dEc_dW = norm(vec_dEc_dW);
            norm_dEc_db = norm(vec_dEc_db);
        end
    end
    
end

