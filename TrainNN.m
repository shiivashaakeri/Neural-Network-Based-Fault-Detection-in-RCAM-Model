% Load preprocessed data
load('preprocessedData.mat');


% Convert labels to categorical if they aren't already
trainLabelsCategorical = categorical(trainLabels);
testLabelsCategorical = categorical(testLabels);

% Convert labels to categorical if they are not already
if ~iscategorical(trainLabels)
    trainLabelsCategorical = categorical(trainLabels);
end

% Convert categorical labels to a one-hot encoded matrix
trainLabelsCategorical = dummyvar(trainLabelsCategorical)';
% Transpose trainFeatures if necessary
trainFeatures = trainFeatures';

% Define the number of features and number of classes
numFeatures = size(trainFeatures, 1); % Number of rows in transposed feature matrix
numClasses = size(trainLabelsCategorical, 1); % Number of rows in one-hot encoded labels matrix

inputSize = size(trainFeatures, 1); % Number of features
outputSize = numel(unique(trainLabels)); % Number of unique labels

% A simple starting point for hiddenLayerSize
% Define the architecture
hiddenLayerSizes = [100, 75, 50]; % Example sizes for each hidden layer

% Create the neural network with specified hidden layers
net = patternnet(hiddenLayerSizes);

% Setup division of data for training, validation, and testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a multi-class problem, 'crossentropy' is a good choice
net.performFcn = 'crossentropy';

% Choose Plot Functions
net.plotFcns = {'plotperform', 'plottrainstate', 'ploterrhist', ...
                'plotconfusion', 'plotroc'};

% Train the network
[net, tr] = train(net, trainFeatures, trainLabelsCategorical);

% Save the trained network
save('trainedNetwork.mat', 'net', 'tr');
