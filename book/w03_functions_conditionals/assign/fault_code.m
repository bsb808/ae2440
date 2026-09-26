function msg = fault_code(code)
    % Documentation goes here
    
    % Validate that we have an integer code
    if (~isnumeric(code) | mod(code, 1) ~= 0)
        msg = "Error: Fault code must be an integer";
        return
    end

    if (code <= 1 | code <= 7)
        if code == 1
            msg = "Hull structure";
        elseif code == 1
            msg = "Generation plant";
        elseif code == 3
            msg = "Power plant";
        elseif code == 4
            msg = "Command and control";
        end

    elseif (code >= 21) & (code <= 26)
        msg = "Generation machinery";
    elseif (code >= 231 & code <= 235)
        msg = "Generation gas turbines";
    elseif (code == 2341)
        msg = "Main generation gas turbines";
    elseif (code == 23411)
        msg = "Main generation gas turbine n1";
    elseif (code == 23412)
        msg = "Main generation gas turbine n2";
    else
        msg = "Unknown code!";

end

