function outputBytes = lzw_decode(codes)

    % LZW DECODER
    % Input: Compressed dictionary codes
    % Output: Restored original bytes

    % Step 1: Handle empty input
    if isempty(codes)
        outputBytes = uint8([]);
        return;
    end

    % Step 2: Create dictionary
    dictionary = cell(1, 65536);

    % Step 3: Initialize dictionary with 256 possible bytes
    for i = 0:255
        dictionary{i+1} = uint8(i);
    end

    % Step 4: Initialize next available code
    nextCode = 256;

    % Step 5: Read the first code
    oldCode = double(codes(1));

    % Validate first code
    if oldCode < 0 || oldCode > 255 || oldCode ~= floor(oldCode)
        error('Invalid first LZW code.');
    end

    % Step 6: Initialize output
    w = dictionary{oldCode+1};
    outputBytes = w;

    % Step 7: Process remaining codes
    for i = 2:length(codes)

        % Read current code
        currentCode = double(codes(i));

        % Case 1: Code already exists
        if currentCode < nextCode && ~isempty(dictionary{currentCode+1})

            entry = dictionary{currentCode+1};

        % Case 2: Special LZW condition
        elseif currentCode == nextCode && nextCode <= 65535

            entry = [w, w(1)];

        else
            error('Invalid LZW compressed data.');
        end

        % Add decoded sequence to output
        outputBytes = [outputBytes, entry];

        % Create new dictionary entry
        if nextCode <= 65535

            dictionary{nextCode+1} = [w, entry(1)];

            nextCode = nextCode + 1;

        end

        % Update previous sequence
        w = entry;

    end

end