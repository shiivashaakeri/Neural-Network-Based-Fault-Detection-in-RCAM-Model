function XDOT = ThrottleActuatorFailure(X, U, engineNumber, faultCondition, faultValue)
    % Extract control input vector
    d_th = U(3 + engineNumber); % Throttle for engine 1 or 2
    
    % Simulate fault condition
    switch faultCondition
        case 'stuck'
            d_th = faultValue; % Stuck at faultValue
        case 'limitedRange'
            d_th = max(min(d_th, faultValue), 0); % Limit range to 0 to faultValue
        case 'unresponsive'
            d_th = 0; % Throttle does not respond
    end
    
    % Update control input vector for the specific engine
    U(3 + engineNumber) = d_th;
    
    % Calculate dynamics with modified control input
    XDOT = RCAM_model(X, U);
end
