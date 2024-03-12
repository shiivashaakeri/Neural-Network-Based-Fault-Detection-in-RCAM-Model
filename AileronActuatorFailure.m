function XDOT = AileronActuatorFailure(X, U, faultCondition, faultValue)
    % Extract control input vector
    d_A = U(1); % Aileron
    
    % Simulate fault condition
    switch faultCondition
        case 'stuck'
            d_A = faultValue; % Stuck at faultValue radians
        case 'limitedRange'
            d_A = max(min(d_A, faultValue), -faultValue); % Limit range to +/- faultValue
        case 'unresponsive'
            d_A = 0; % Aileron does not respond
    end
    
    % Update control input vector
    U(1) = d_A;
    
    % Calculate dynamics with modified control input
    XDOT = RCAM_model(X, U);
end
