% Load the data from the .mat file if it's not already in the workspace
if ~exist('data', 'var')
    load('simulationData.mat');
end
 
% Initialize matrices for features and labels
features = [];
labels = [];

% Define label encoding for each fault condition
faultLabels = {
    'normal', 1;
    'AileronActuatorFailure', 2;
    'AirspeedSensorFailure', 3;
    'AngleofAttackSensorFailure', 4;
    'ControlSurfaceDamage', 5;
    'ElectricalPowerFailure', 6;
    'ElevatorActuatorFailure', 7;
    'EngineFailure', 8;
    'FuelSystemMalfunction', 9;
    'FuselageIntegrityCompromise', 10;
    'GyroscopeSensorFailure', 11;
    'LandingGearMalfunction', 12;
    'PropulsionSensorFailure', 13;
    'RudderActuatorFailure', 14;
    'SideslipAngleSensorFailure', 15;
    'TailplaneDamage', 16;
    'TemperatureSensorFailures', 17;
    'ThrottleActuatorFailure', 18;
    'WingDamage', 19
};

% Flatten the data
fieldNames = fieldnames(data);
for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    % Each row of the field data corresponds to a time step of the simulation
    % Stack them all to have a single matrix
    features = [features; data.(fieldName)];
    
    % Find the label for the current fault condition
    label = faultLabels{strcmp(faultLabels(:,1), fieldName), 2};
    labels = [labels; repmat(label, size(data.(fieldName), 1), 1)];
end

% Feature normalization (mean normalization or standardization)
% Here we're using z-score standardization
features = (features - mean(features)) ./ std(features);

% Randomly shuffle the data within each label to ensure a mix
uniqueLabels = unique(labels);
stratifiedIndices = [];

for i = 1:length(uniqueLabels)
    labelIndices = find(labels == uniqueLabels(i));
    shuffledIndices = labelIndices(randperm(length(labelIndices)));
    stratifiedIndices = [stratifiedIndices; shuffledIndices];
end

% Now stratifiedIndices is a list of indices with classes mixed
features = features(stratifiedIndices, :);
labels = labels(stratifiedIndices);

% Split the features and labels with stratification
trainFeatures = [];
trainLabels = [];
testFeatures = [];
testLabels = [];
splitRatio = 0.7;
for i = 1:length(uniqueLabels)
    labelIndices = find(labels == uniqueLabels(i));
    splitPoint = floor(splitRatio * length(labelIndices));
    trainFeatures = [trainFeatures; features(labelIndices(1:splitPoint), :)];
    trainLabels = [trainLabels; labels(labelIndices(1:splitPoint))];
    testFeatures = [testFeatures; features(labelIndices(splitPoint+1:end), :)];
    testLabels = [testLabels; labels(labelIndices(splitPoint+1:end))];
end

% Save preprocessed data
save('preprocessedData.mat', 'trainFeatures', 'trainLabels', 'testFeatures', 'testLabels');
