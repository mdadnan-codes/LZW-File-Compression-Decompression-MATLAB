# LZW File Compression and Decompression Using MATLAB

## 📌 Project Overview

This project implements the **Lempel-Ziv-Welch (LZW) algorithm** for lossless file compression and decompression using MATLAB.

The main objective is to reduce file size while preserving the original data accurately. The project supports file compression and decompression and has been tested with different file formats, including PDF and JPG.

The decompression process successfully restores the original file.

## 🎯 Objectives

- Implement the LZW lossless compression algorithm using MATLAB.
- Reduce file size by encoding repeated data patterns.
- Decompress compressed files to recover the original data.
- Calculate compression performance parameters.
- Test the algorithm on different file formats.
- Compare original and compressed file sizes.

## ⚙️ Technologies Used

- MATLAB
- MATLAB Programming
- Lempel-Ziv-Welch (LZW) Algorithm

## 📂 Project Structure

```text
LZW-File-Compression-Decompression-MATLAB/
│
├── README.md
│
├── report/
│   └── Project Report (PDF)
│
├── result/
│   └── Compression Results
│
├── src/
│   ├── lzw_encode.m
│   ├── lzw_decode.m
│   └── mzip.m
│
└── tests/
    ├── run_tests.m
    └── collect_results.m
```

## 🧠 Working Principle

The project consists of two main processes:

### 1. Encoding (Compression)

- Read the input file.
- Identify repeated patterns in the input data.
- Build a dictionary of patterns.
- Replace patterns with corresponding dictionary codes.
- Generate the compressed output file.

### 2. Decoding (Decompression)

- Read the compressed file.
- Reconstruct the dictionary.
- Decode the stored codes.
- Recover the original data.
- Save the restored file.

## 📊 Performance Parameters

The project evaluates the following parameters:

| Parameter | Description |
|---|---|
| Original Size | Size of the input file |
| Compressed Size | Size after compression |
| Compression Ratio | Original Size / Compressed Size |
| Bits per Input Byte | Compressed bits per original input byte |
| Entropy | Information content of input data |
| Compression Time | Time required for compression |
| Decompression Time | Time required for decompression |

**Note:** Compression performance depends on the input file. Some files may become larger after compression.

## 🧪 Testing and Results

The algorithm has been tested using different input files, including:

- PDF files
- JPG image files
- Other test files

The experimental results demonstrate that:

- The encoder successfully compresses input files.
- The decoder successfully restores the original files.
- The restored file size matches the original file size in the tested cases.
- Compression ratio and execution time vary depending on the input data.

**Testing Status:** Successful compression and decompression verified for the tested PDF and JPG files.

## ▶️ How to Run the Project

1. Install MATLAB on your computer.
2. Download or clone this repository.
3. Open the project folder in MATLAB.
4. Navigate to the `src` folder.
5. Make sure the required files are available in the MATLAB path.
6. Run the main MATLAB script (`mzip.m`) or the appropriate test script.
7. Select an input file for compression.
8. Perform decompression to restore the original file.
9. Check the generated results.

## 📈 Applications

- File storage optimization
- Data transmission
- Lossless data compression
- File archiving
- Data processing systems

## 👨‍💻 Author

**Md Adnan**

B.Tech – Electrical Engineering

Zakir Husain College of Engineering and Technology (ZHCET)

Aligarh Muslim University (AMU), Aligarh, Uttar Pradesh, India.

## 📜 License

This project is intended for educational and academic purposes.

## ⭐ Acknowledgement

This project was developed as an academic assignment to understand and implement the Lempel-Ziv-Welch (LZW) lossless data compression technique using MATLAB.
