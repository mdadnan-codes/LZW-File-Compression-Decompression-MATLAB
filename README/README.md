# LZW File Compression and Decompression Using MATLAB

A MATLAB implementation of the **Lempel–Ziv–Welch (LZW)** lossless compression algorithm. The project compresses and decompresses files as binary byte streams and supports TXT, PDF, and JPG test files.

## Project Overview

The project contains an LZW encoder, decoder, and a file-management function. It stores compressed output in a custom binary format called **MZIP**.

### Main Features

- Lossless LZW encoding and decoding.
- Binary file handling, so the implementation is not limited to text files.
- Compression, decompression, and compressed-file information commands.
- A 16-bit code representation with dictionary codes from 0 to 65,535.
- Verification of restored files using byte-by-byte comparison.
- Performance measurements including file sizes, compression ratio, space saving, bits per input byte, and execution time.

## Project Files

| File | Description |
|---|---|
| `lzw_encode.m` | Encodes a `uint8` byte array into LZW dictionary codes (`uint16`). |
| `lzw_decode.m` | Decodes LZW codes and reconstructs the original byte array. |
| `mzip.m` | Main file utility. Handles compression, decompression, and file information. |
| `run_tests.m` | Runs a basic encoder/decoder test using the sequence `ABABABA`. |
| `collect_results.m` | Tests TXT, PDF, and JPG files, checks exact restoration, and saves results to CSV. |

## Requirements

- MATLAB.
- The project `.m` files listed above.
- Input files for testing (for example, a `.txt`, `.pdf`, and `.jpg` file).

No additional MATLAB toolbox is specified as a requirement in the project report.

## Setup

1. Place the MATLAB source files in the project folder.
2. Open MATLAB.
3. Set the **Current Folder** to the project folder containing `mzip.m`, `lzw_encode.m`, and `lzw_decode.m`.
4. Make sure the test files are located in the `tests` folder, or update the paths in the test script to match your folder structure.

Example folder structure:

```text
LZW/
├── src/
│   ├── lzw_encode.m
│   ├── lzw_decode.m
│   ├── mzip.m
│   ├── run_tests.m
│   └── collect_results.m
└── tests/
    ├── input.txt
    ├── input.pdf
    └── input.jpg
```

The exact folder layout may differ; use paths that match your local project.

## How to Use

Run these commands in the MATLAB Command Window from the folder containing `mzip.m`.

### 1. Compress a file

```matlab
mzip('c', 'input.txt', 'output.lzw')
```

This compresses `input.txt` and writes the compressed data to `output.lzw`.

### 2. Decompress a file

```matlab
mzip('d', 'output.lzw', 'restored.txt')
```

This decompresses `output.lzw` and writes the restored data to `restored.txt`.

### 3. Display compressed-file information

```matlab
mzip('i', 'output.lzw')
```

This displays the information stored or calculated for the compressed file.

> **Note:** Replace the example filenames with the actual file paths on your computer. The relative paths shown in the project tests work only when the current folder has the expected directory structure.

## How the Algorithm Works

### Encoder

1. Initialise the dictionary with all 256 possible single-byte values (codes 0–255).
2. Read the input bytes and build longer sequences.
3. If the extended sequence already exists, continue extending it.
4. If it does not exist, output the code for the current sequence and add the new sequence to the dictionary when capacity permits.
5. Output the code for the final remaining sequence.

### Decoder

1. Initialise the same 256 single-byte dictionary entries.
2. Read the first code and output its corresponding byte sequence.
3. Process each following code using the dictionary.
4. Handle the special LZW case when the current code equals the next dictionary code to be created.
5. Add the inferred sequence to the dictionary and continue until all codes are decoded.

The encoder and decoder build matching dictionaries in the same order, allowing the original data to be reconstructed without storing the complete dictionary in the compressed file.

## MZIP File Format

The compressed file contains a header followed by the LZW code stream:

| Field | Representation | Purpose |
|---|---|---|
| Identifier | 4 bytes | The characters `MZIP` identify the file format. |
| Original size | `uint64` | Stores the expected size of the original file. |
| Compression time | `double` | Stores the measured compression time. |
| Compressed codes | `uint16` array | Stores the LZW dictionary codes. |

The reported compressed size includes the header and the stored code stream.

## Experimental Results

The supplied project results report the following measurements:

| File type | Original size (B) | Compressed size (B) | Compression ratio | Space saving (%) | Verified |
|---|---:|---:|---:|---:|---|
| TXT | 75,000 | 6,622 | 11.3259 | 91.1707 | Yes |
| PDF | 4,027 | 5,852 | 0.6881 | −45.3191 | Yes |
| JPG | 95,344 | 130,992 | 0.7279 | −37.3888 | Yes |

**Interpretation:** The TXT file compressed effectively because it contains repeated byte patterns. The PDF and JPG files became larger in these tests because they may already contain compressed data, and the MZIP header and fixed-width code storage add overhead. All three files were restored successfully.

## Verification

The project checks lossless restoration by reading the original and restored files in binary mode as `uint8` arrays and comparing them with MATLAB's `isequal()` function.

A successful comparison returns logical `1` (`true`). The reported TXT, PDF, and JPG tests all passed this byte-for-byte verification.

## Performance Measures

- **Compression ratio** = Original Size / Compressed Size
- **Space saving (%)** = [1 − (Compressed Size / Original Size)] × 100
- **Bits per input byte** = (Compressed Size × 8) / Original Size
- **Entropy** = −Σ pᵢ log₂(pᵢ)

A compression ratio greater than 1 indicates size reduction. A ratio below 1 means the compressed output is larger than the original.

## Current Limitations

- Codes are stored using a fixed 16-bit representation.
- The dictionary supports codes from 0 to 65,535.
- When the dictionary becomes full, the implementation stops adding entries; it does not reset the dictionary.
- Already-compressed formats such as JPG and some PDFs may not become smaller.
- Header overhead can have a noticeable effect on small files.

## Possible Improvements

- Implement variable-width code packing to reduce storage overhead.
- Evaluate dictionary reset strategies when the dictionary becomes full.
- Run repeated timing trials and report average execution times.
- Record entropy for every test file in the results CSV.

## Report

The accompanying project report is titled **“LZW File Compression and Decompression Using MATLAB”**. It includes the algorithm explanation, encoder and decoder flowcharts, MATLAB program design, MZIP format, performance measures, experimental results, verification, limitations, and conclusion.

## References

- Welch, T. A., “A Technique for High-Performance Data Compression,” *IEEE Computer*, Vol. 17, No. 6, 1984.
- MathWorks MATLAB documentation for file I/O functions such as `fopen`, `fread`, and `fwrite`, timing functions `tic` and `toc`, and `containers.Map`.

---

**Project:** LZW File Compression and Decompression Using MATLAB  
**Course:** Fundamentals of Communication Engineering
