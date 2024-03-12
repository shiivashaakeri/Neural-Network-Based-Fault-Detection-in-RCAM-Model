function engineThrust = calculate_thrust_compensation(engineStatus, engineNumber, failureValue, maxThrust)
% calculate_thrust_compensation: Calculates required thrust adjustments 
% after an engine failure for a multi-engine aircraft.  
%
% Inputs:
%   engineStatus:  Vector indicating status of each engine 
%                  ('operational' or 'failed')
%   engineNumber:  Index of the failed engine (1, 2, etc.)
%   failureValue:  Severity of failure (0 - no loss, 1 - complete loss)
%   maxThrust:     Vector of maximum thrust limits for each engine
%
% Outputs:
%   engineThrust:  Updated vector of thrust commands for each engine

numEngines = length(engineStatus);
operationalEngines = find(strcmp(engineStatus, 'operational'));

% Case 1: Complete Engine Failure
if failureValue == 1 
    failedEngineThrust = maxThrust(engineNumber); % Max for failed engine = lost thrust
    compensationPerEngine = failedEngineThrust / (numEngines - 1); % Split among others

    for engineIndex = operationalEngines
        engineThrust(engineIndex) = min(engineThrust(engineIndex) + compensationPerEngine, ...
                                        maxThrust(engineIndex));  % Limit check
    end

% Case 2: Partial Engine Failure  
else 
    lostThrust = failureValue * engineThrust(engineNumber); 
    compensationPerEngine = lostThrust / (numEngines - 1);

    for engineIndex = operationalEngines
        engineThrust(engineIndex) = min(engineThrust(engineIndex) + compensationPerEngine, ...
                                        maxThrust(engineIndex));  % Limit check
    end
end
end
