function XDOT = ElevatorActuatorFailure(X, U, faultCondition, faultValue)
    % Extract control input vector
    d_T = U(2); % Elevator
    
    % Simulate fault condition
    switch faultCondition
        case 'stuck'
            d_T = faultValue; % Stuck at faultValue radians
        case 'limitedRange'
            d_T = max(min(d_T, faultValue), -faultValue); % Limit range to +/- faultValue
        case 'unresponsive'
            d_T = 0; % Elevator does not respond
    end
    
    % Update control input vector
    U(2) = d_T;
    
    % Calculate dynamics with modified control input
    XDOT = RCAM_model(X, U);
end
