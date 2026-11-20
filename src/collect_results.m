clc;
clear;

% Input files
files = {
    '../tests/large_input.txt'
    '../tests/sample.pdf'
    '../tests/sample.jpg'
};

fileTypes = {'TXT'; 'PDF'; 'JPG'};

n = length(files);

% Initialize result arrays
OriginalSize = zeros(n,1);
CompressedSize = zeros(n,1);
CompressionRatio = zeros(n,1);
SpaceSaving = zeros(n,1);
CompressionTime = zeros(n,1);
DecompressionTime = zeros(n,1);
Verification = false(n,1);

for k = 1:n

    inputFile = files{k};

    [~,name,ext] = fileparts(inputFile);

    compressedFile = ['../result/' name '.lzw'];
    restoredFile = ['../result/' name '_restored' ext];

    % Compression
    tic;
    mzip('c',inputFile,compressedFile);
    CompressionTime(k) = toc;

    % Decompression
    tic;
    mzip('d',compressedFile,restoredFile);
    DecompressionTime(k) = toc;

    % Read original and restored files
    fid = fopen(inputFile,'rb');
    original = fread(fid,Inf,'*uint8');
    fclose(fid);

    fid = fopen(restoredFile,'rb');
    restored = fread(fid,Inf,'*uint8');
    fclose(fid);

    % File sizes
    originalInfo = dir(inputFile);
    compressedInfo = dir(compressedFile);

    OriginalSize(k) = originalInfo.bytes;
    CompressedSize(k) = compressedInfo.bytes;

    % Compression metrics
    CompressionRatio(k) = ...
        OriginalSize(k)/CompressedSize(k);

    SpaceSaving(k) = ...
        (1 - CompressedSize(k)/OriginalSize(k))*100;

    % Verification
    Verification(k) = isequal(original,restored);

end

% Create result table
Results = table(fileTypes,OriginalSize,CompressedSize,...
    CompressionRatio,SpaceSaving,CompressionTime,...
    DecompressionTime,Verification);

% Display results
disp(Results);

% Save CSV
writetable(Results,'../result/results.csv');

fprintf('\nExperimental results saved successfully!\n');