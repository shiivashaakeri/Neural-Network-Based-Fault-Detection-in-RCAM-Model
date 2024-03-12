function XDOT = EnvironmentalSensorFailure(X, U, sensorType, isFaulty)
    % Example: Assuming a sensor that detects icing conditions
    if strcmp(sensorType, 'icing') && isFaulty
        % If the sensor fails, the system might not activate de-icing systems
        % This example assumes the model includes logic to handle icing based on sensor input
        icingSeverity = 0; % System believes there's no icing due to sensor failure
    else
        icingSeverity = calculateIcingSeverity(X, U); % A function to calculate severity based on conditions
    end
    
    % Adjust model for icing as if the sensor is working correctly or not
    XDOT = IcingEffect(X, U, icingSeverity);
end
