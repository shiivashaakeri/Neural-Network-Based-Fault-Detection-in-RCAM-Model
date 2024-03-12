function XDOT = ElectricalPowerFailure(X, U, failureType)
    % Check the type of failure and adjust control inputs accordingly
    if strcmp(failureType, 'total')
        % In case of total power failure, all electrically powered systems fail
        U(:) = 0; % Set all control inputs to 0
    elseif strcmp(failureType, 'partial')
        % In case of partial failure, reduce effectiveness of control inputs
        U = U * 0.5; % Example: Reduce control effectiveness by 50%
    end
    
    % Calculate dynamics with modified control inputs
    XDOT = RCAM_model(X, U);
end
