function codes = lzw_encode(inputBytes)

    % LZW ENCODER
    % Input: Original data in uint8 format
    % Output: Compressed dictionary codes in uint16 format

    % Step 1: Create an empty dictionary
    dictionary = containers.Map('KeyType', 'char', 'ValueType', 'double');
                                

    % Step 2: Initialize dictionary with all 256 possible bytes
    for i = 0:255
        dictionary(char(i)) = i;
    end

    % Step 3: Initialize next available dictionary code
    nextCode = 256;

    % Step 4: Initialize output codes
    codes = uint16([]);

    % Step 5: Convert input into a row vector
    inputBytes = uint8(inputBytes(:).');

    % Handle empty input
    if isempty(inputBytes)
        return;
    end

    % Step 6: Start with the first byte
    w = char(inputBytes(1));

    % Step 7: Process remaining bytes
    for i = 2:length(inputBytes)

        % Read next byte
        k = char(inputBytes(i));

        % Combine current sequence and next byte
        wk = [w, k];

        % Step 8: Check whether combined sequence exists
        if isKey(dictionary, wk)

            % If found, extend current sequence
            w = wk;

        else

            % If not found, output current sequence code
            codes(end+1) = uint16(dictionary(w));

            % Add new sequence if dictionary has space
            if nextCode <= 65535

                dictionary(wk) = nextCode;

                nextCode = nextCode + 1;

            end

            % Start new sequence
            w = k;

        end
    end

    % Step 9: Output the remaining sequence
    codes(end+1) = uint16(dictionary(w));

end