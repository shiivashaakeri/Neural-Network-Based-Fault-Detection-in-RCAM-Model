function XDOT = EngineFailure(X, U, engineNumber, failureType, failureValue)
    % Adjust thrust based on failure type
    if strcmp(failureType, 'complete')
        U(3 + engineNumber) = 0; % Complete power loss, throttle set to 0
    elseif strcmp(failureType, 'partial')
        % Partial power loss, reduce thrust by a percentage (failureValue)
        U(3 + engineNumber) = U(3 + engineNumber) * (1 - failureValue);
    end
    
    % Calculate dynamics with modified control input (throttle adjustment)
    XDOT = RCAM_model(X, U);
end
