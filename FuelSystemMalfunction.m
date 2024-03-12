function XDOT = FuelSystemMalfunction(X, U, errorFactor)
    % Adjust throttle inputs by an error factor to simulate fuel flow malfunction
    U(4) = U(4) * errorFactor; % Adjust throttle 1
    U(5) = U(5) * errorFactor; % Adjust throttle 2
    
    % Calculate dynamics with modified control input (throttle adjustment)
    XDOT = RCAM_model(X, U);
end
