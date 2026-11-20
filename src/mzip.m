function mzip(option, inputFile, outputFile)

    % MZIP: LZW File Compression and Decompression
    %
    % Usage:
    % mzip('c', 'input.txt', 'output.lzw')
    % mzip('d', 'output.lzw', 'restored.txt')
    % mzip('i', 'output.lzw')

    % Check number of arguments
    if nargin < 2
        error('Not enough arguments. See mzip help.');
    end

    option = lower(char(option));

    % ================= COMPRESSION =================

    if strcmp(option, 'c')

        if nargin ~= 3
            error('Compression requires input and output filenames.');
        end

        % Check input file
        if ~isfile(inputFile)
            error('Input file does not exist.');
        end

        % Read original file as bytes
        fid = fopen(inputFile, 'rb');

        if fid == -1
            error('Cannot open input file.');
        end

        data = fread(fid, Inf, '*uint8').';
        fclose(fid);

        % Start compression timer
        tic;

        % Call LZW encoder
        codes = lzw_encode(data);

        compressionTime = toc;

        % Open output file
        fid = fopen(outputFile, 'wb', 'ieee-le');

        if fid == -1
            error('Cannot create output file.');
        end

        % Write file header
        fwrite(fid, uint8('MZIP'), 'uint8');
        fwrite(fid, uint64(length(data)), 'uint64');
        fwrite(fid, double(compressionTime), 'double');

        % Write compressed codes
        fwrite(fid, codes, 'uint16');

        fclose(fid);

        % Display compression results
        fileInfo = dir(outputFile);

        originalSize = length(data);
        compressedSize = fileInfo.bytes;

        if originalSize > 0
            ratio = originalSize / compressedSize;
            bitsPerByte = compressedSize * 8 / originalSize;
            entropy = calculate_entropy(data);
        else
            ratio = NaN;
            bitsPerByte = NaN;
            entropy = 0;
        end

        fprintf('\n----- COMPRESSION RESULTS -----\n');
        fprintf('Original Size: %d bytes\n', originalSize);
        fprintf('Compressed Size: %d bytes\n', compressedSize);
        fprintf('Compression Ratio: %.4f\n', ratio);
        fprintf('Bits per Input Byte: %.4f\n', bitsPerByte);
        fprintf('Entropy: %.4f bits/byte\n', entropy);
        fprintf('Compression Time: %.6f seconds\n', compressionTime);

    % ================= DECOMPRESSION =================

    elseif strcmp(option, 'd')

        if nargin ~= 3
            error('Decompression requires input and output filenames.');
        end

        if ~isfile(inputFile)
            error('Compressed file does not exist.');
        end

        % Open compressed file
        fid = fopen(inputFile, 'rb', 'ieee-le');

        if fid == -1
            error('Cannot open compressed file.');
        end

        % Read and verify header
        magic = fread(fid, 4, '*uint8').';

        if ~isequal(magic, uint8('MZIP'))
            fclose(fid);
            error('Invalid MZIP file format.');
        end

        originalSize = fread(fid, 1, '*uint64');
        compressionTime = fread(fid, 1, '*double');

        if isempty(originalSize) || isempty(compressionTime)
            fclose(fid);
            error('Incomplete compressed file header.');
        end

        % Read compressed codes
        codes = fread(fid, Inf, '*uint16').';

        fclose(fid);

        % Start decompression timer
        tic;

        % Call LZW decoder
        restoredData = lzw_decode(codes);

        decompressionTime = toc;

        % Verify restored size
        if numel(restoredData) ~= double(originalSize)
            error('Decompression failed: file size mismatch.');
        end

        % Write restored file
        fid = fopen(outputFile, 'wb');

        if fid == -1
            error('Cannot create restored file.');
        end

        fwrite(fid, restoredData, 'uint8');

        fclose(fid);

        fprintf('\n----- DECOMPRESSION RESULTS -----\n');
        fprintf('Restored Size: %d bytes\n', numel(restoredData));
        fprintf('Decompression Time: %.6f seconds\n', decompressionTime);

        fprintf('Original Compression Time: %.6f seconds\n', compressionTime);

        fprintf('File successfully restored!\n');

    % ================= INFORMATION =================

    elseif strcmp(option, 'i')

        if nargin ~= 2
            error('Information command requires one filename.');
        end

        if ~isfile(inputFile)
            error('Compressed file does not exist.');
        end

        fid = fopen(inputFile, 'rb', 'ieee-le');

        if fid == -1
            error('Cannot open compressed file.');
        end

        magic = fread(fid, 4, '*uint8').';

        if ~isequal(magic, uint8('MZIP'))
            fclose(fid);
            error('Invalid MZIP file format.');
        end

        originalSize = fread(fid, 1, '*uint64');
        compressionTime = fread(fid, 1, '*double');
        codes = fread(fid, Inf, '*uint16').';

        fclose(fid);

        % Decode to calculate entropy
        data = lzw_decode(codes);

        if numel(data) ~= double(originalSize)
            error('Invalid compressed file: size mismatch.');
        end

        fileInfo = dir(inputFile);

        compressedSize = fileInfo.bytes;

        if originalSize > 0
            ratio = double(originalSize) / compressedSize;
            bitsPerByte = compressedSize * 8 / double(originalSize);
            entropy = calculate_entropy(data);
        else
            ratio = NaN;
            bitsPerByte = NaN;
            entropy = 0;
        end

        fprintf('\n----- FILE INFORMATION -----\n');
        fprintf('Original Size: %d bytes\n', originalSize);
        fprintf('Compressed Size: %d bytes\n', compressedSize);
        fprintf('Compression Ratio: %.4f\n', ratio);
        fprintf('Bits per Input Byte: %.4f\n', bitsPerByte);
        fprintf('Entropy: %.4f bits/byte\n', entropy);
        fprintf('Compression Time: %.6f seconds\n', compressionTime);

    else

        error('Invalid option. Use c, d or i.');

    end

end


% ================ ENTROPY FUNCTION ================

function H = calculate_entropy(data)

    if isempty(data)
        H = 0;
        return;
    end

    counts = accumarray(double(data(:)) + 1, 1, [256, 1]);

    probabilities = counts(counts > 0) / numel(data);

    H = -sum(probabilities .* log2(probabilities));

end