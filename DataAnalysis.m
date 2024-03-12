% DataAnalysis.m - Script to analyze simulation data for RCAM model under various conditions

% Load the simulation data
load('simulationData.mat');

% Define the time vector based on your simulation parameters
simTime = 10; % Total simulation time in seconds
dt = 0.01; % Time step
timeVector = 0:dt:simTime-dt;

% Get the names of all fault conditions including the normal scenario
faultConditions = fieldnames(data);
% Initialize combined figure for comparison
figCombined = figure('Name', 'RCAM Data Analysis', 'NumberTitle', 'off');
set(figCombined, 'Position', [100, 100, 1200, 800]); % Adjust as necessary

% Loop through each fault condition to analyze and plot data
for i = 1:length(faultConditions)
    conditionName = faultConditions{i};
    conditionData = data.(conditionName);

    % Calculate means and variances
    means(i, :) = mean(conditionData, 1);
    variances(i, :) = var(conditionData, 0, 1);

    % State Trajectories
    subplot(3, 1, 1);
    hold on;
    plot(timeVector, conditionData, 'DisplayName', conditionName);
    title('State Trajectories');
    xlabel('Time (s)');
    ylabel('State Values');
    legend('-DynamicLegend');
    grid on;

    % Mean of States
    subplot(3, 1, 2);
    hold on;
    bar(i, means(i, :), 'DisplayName', conditionName);
    title('Mean of States Across Fault Conditions');
    ylabel('Mean Value');
    grid on;

    % Variance of States
    subplot(3, 1, 3);
    hold on;
    bar(i, variances(i, :), 'DisplayName', conditionName);
    title('Variance of States Across Fault Conditions');
    xlabel('Fault Condition');
    ylabel('Variance Value');
    grid on;
end

% Adjust subplot parameters for clarity
subplot(3, 1, 2);
set(gca, 'XTick', 1:length(faultConditions), 'XTickLabel', faultConditions);
xtickangle(45);

subplot(3, 1, 3);
set(gca, 'XTick', 1:length(faultConditions), 'XTickLabel', faultConditions);
xtickangle(45);