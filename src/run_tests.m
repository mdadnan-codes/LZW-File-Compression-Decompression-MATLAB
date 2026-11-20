clc;
clear;

% Original input
data = uint8('ABABABA');

% Compress the original data
compressed = lzw_encode(data);

% Decompress the compressed codes
restored = lzw_decode(compressed);

% Display results
disp('Original Data:');
disp(char(data));

disp('Compressed Codes:');
disp(double(compressed));

disp('Restored Data:');
disp(char(restored));

% Check whether original and restored data are identical
if isequal(data, restored)
    disp('SUCCESS: Original and restored data are identical.');
else
    disp('ERROR: Data does not match.');
end