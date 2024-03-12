function XDOT = FlightControlComputerMalfunction(X, U, malfunctionType)
    % Simulate flight control computer malfunction
    if strcmp(malfunctionType, 'incorrectProcessing')
        % Example: Incorrect processing leads to reversed control inputs
        U = -U; % Reverse control inputs
    elseif strcmp(malfunctionType, 'unintendedCommands')
        % Example: Execution of unintended commands
        U = 0.1 * randn(size(U)); % Random control inputs
    end
    
    % Calculate dynamics with modified control inputs
    XDOT = RCAM_model(X, U);
end
