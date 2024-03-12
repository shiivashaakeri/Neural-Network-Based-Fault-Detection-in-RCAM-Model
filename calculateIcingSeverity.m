function icingSeverity = calculateIcingSeverity(X, U)
    % X: State vector (assuming altitude is part of the state vector)
    % U: Control input vector (not directly used here but included for consistency)
    
    % Extract altitude and airspeed from the state vector
    % Assuming altitude is at a certain position in the state vector, e.g., X(10)
    % and airspeed is calculated from the first three components of X
    altitude = X(10); % Placeholder index for altitude in the state vector
    airspeed = sqrt(X(1)^2 + X(2)^2 + X(3)^2);
    
    % Define conditions for icing severity based on altitude and airspeed
    % These conditions are simplifications and should be adjusted based on real data or a more detailed model
    
    % Example conditions for icing severity
    if altitude > 5000 && altitude < 8000 && airspeed > 100
        icingSeverity = 0.5; % Moderate icing conditions
    elseif altitude >= 8000 && airspeed > 150
        icingSeverity = 0.8; % Severe icing conditions
    else
        icingSeverity = 0; % No icing conditions
    end
    
    % The severity scale is 0 to 1, where 0 means no icing and 1 means maximum possible icing severity
end
