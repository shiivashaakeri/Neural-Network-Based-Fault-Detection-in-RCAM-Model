clc
clear
close all

% DataGenerate.m - Script to generate simulation data for RCAM model under various conditions

% Define simulation parameters
simTime = 10; % Total simulation time
dt = 0.01; % Time step
timeVector = 0:dt:simTime-dt;
numSteps = length(timeVector);

trimpoints = load('trim_values_straight_level.mat');
% Define initial conditions and control inputs
X0 = trimpoints.XStar; 

% Your control inputs for steady-state level flight 
U_normal = trimpoints.UStar; 

% Define fault scenarios
faultScenarios = {
    {'normal', {}};
    {'AileronActuatorFailure', {'stuck', 15*pi/180}};
    {'AirspeedSensorFailure', {'complete'}};
    {'AngleofAttackSensorFailure', {}};
    {'ControlSurfaceDamage', {'aileron', 0.5}};
    {'ElectricalPowerFailure', {'partial'}};
    {'ElevatorActuatorFailure', {'limitedRange', 10*pi/180}}
    {'EngineFailure', {1, 'partial', 0.5}}; 
    {'FuelSystemMalfunction', {0.8}};
    {'FuselageIntegrityCompromise', {0.3}};
    {'GyroscopeSensorFailure', {}};
    {'LandingGearMalfunction', {true}};
    {'PropulsionSensorFailure', {'fuelPressure', 0.9}}; 
    {'RudderActuatorFailure', {'stuck', -5*pi/180}}; 
    {'SideslipAngleSensorFailure', {}};
    {'TailplaneDamage', {0.4}} ;
    {'TemperatureSensorFailures', {}};
    {'ThrottleActuatorFailure', {1, 'stuck', 0.5}} ;
    {'WingDamage', {0.2}}
};


% Preallocate data storage
data = struct();

% Loop over each fault scenario
for i = 1:length(faultScenarios)

    scenario = faultScenarios{i};
    faultFunction = scenario{1};
    faultParams = scenario{2};
    
    % Reset state and time
    X = X0;
    U = U_normal;
    
    % Create a storage for the state trajectory of this scenario
    X_trajectory = zeros(numSteps, length(X0));
    
    % Simulation loop
    for t = 1:numSteps
        % Select the appropriate model function based on the fault scenario
        if strcmp(faultFunction, 'normal')
            XDOT = RCAM_model(X, U);
        else
            % Dynamically call the fault function
            XDOT = feval(faultFunction, X, U, faultParams{:});
        end
        
        % Euler integration to update the state
        X = X + XDOT * dt;
        
        % Store state trajectory
        X_trajectory(t, :) = X;
    end
    
    % Save the state trajectory for this scenario
    data.(faultFunction) = X_trajectory;
end

% Save or process the generated data
% For example, you could save the data structure to a .mat file
save('simulationData.mat', 'data');

