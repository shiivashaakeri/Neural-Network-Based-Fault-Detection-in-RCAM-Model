function XDOT = PropulsionSensorFailure(X, U, sensorType, failureImpact)
    % Simulate the effect of sensor failure on throttle setting
    if strcmp(sensorType, 'fuelPressure')
        % Adjust throttle based on assumed impact of fuel pressure sensor failure
        U(4) = U(4) * failureImpact; % Impact on throttle 1
        U(5) = U(5) * failureImpact; % Impact on throttle 2
    elseif strcmp(sensorType, 'engineTemperature')
        % Adjust throttle based on assumed impact of engine temperature sensor failure
        U(4) = U(4) * failureImpact; % Impact on throttle 1
        U(5) = U(5) * failureImpact; % Impact on throttle 2
    end
    
    % Calculate dynamics with potentially incorrect throttle settings
    XDOT = RCAM_model(X, U);
end
