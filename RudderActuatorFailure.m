function XDOT = RudderActuatorFailure(X, U, faultCondition, faultValue)
    % Extract control input vector
    d_R = U(3); % Rudder
    
    % Simulate fault condition
    switch faultCondition
        case 'stuck'
            d_R = faultValue; % Stuck at faultValue radians
        case 'limitedRange'
            d_R = max(min(d_R, faultValue), -faultValue); % Limit range to +/- faultValue
        case 'unresponsive'
            d_R = 0; % Rudder does not respond
    end
    
    % Update control input vector
    U(3) = d_R;
    
    % Calculate dynamics with modified control input
    XDOT = RCAM_model(X, U);
end
