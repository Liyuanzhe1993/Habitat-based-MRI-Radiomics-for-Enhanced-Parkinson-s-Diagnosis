# Habitat-based-MRI-Radiomics-for-Enhanced-Parkinson-s-Diagnosis
This repository contains all the code and executable tools used in the paper "Habitat-based MRI Radiomics for Enhanced Parkinson's Diagnosis". This study utilizes multi-center MRI data and a habitat-based radiomics approach to improve the diagnostic accuracy of Parkinson's disease (PD).

📁 File Description
1. Executable Programs (Pre-compiled Tools)
Note: Due to file size limitations, the following executable programs are hosted on Baidu Netdisk. Please download them from the provided link and use them in conjunction with the source code in this repository.

OKT-N4_bias_field_correction.exe
Used for N4 bias field correction of MRI images to improve image quality and consistency for feature extraction.

OKT-gen_feature_cluster.exe
Habitat analysis feature extraction tool, extracting various radiomic features (texture, intensity, etc.) from MRI images.

OKT-gen_habitat_cluster.exe
Habitat clustering segmentation tool, dividing Regions of Interest (ROIs) into multiple habitat sub-regions based on k-means clustering.

2. Source Code Folder
sol9.multi-center habitat analysis/
Complete source code for multi-center habitat radiomics analysis, including the full pipeline for data preprocessing, feature extraction, model training, and evaluation.

3. R Analysis Script
SVM_shap.R
R script for SVM model training and SHAP (SHapley Additive exPlanations) interpretability analysis, supporting feature importance visualization and model explanation.

📥 Download Executables
Due to GitHub file size limits (25MB), the executable tools are hosted externally.

Baidu Netdisk Link:

Link: https://pan.baidu.com/s/1jh2EscpK4DNeFCSFOgorhA?pwd=htut
Extraction code: htut

The archive contains the following 5 files:

OKT-N4_bias_field_correction.exe

OKT-gen_feature_cluster.exe

OKT-gen_habitat_cluster.exe

sol9.multi-center habitat analysis (folder)

SVM_shap.R

Please download and place the executables in your working directory alongside the source code.

🛠️ System & Environment Requirements
Runtime Environment
Operating System: Windows 10/11 or Linux (some .exe files require Windows)

R Version: 4.3.0 or higher

RStudio: 2023.03.1 or compatible version

Required R Packages:
Can be installed via the following command:

r
install.packages(c("caret", "e1071", "SHAPforxgboost", "pROC", "ggplot2", "dplyr"))
Data Requirements
MRI Image Format: NIfTI (.nii or .nii.gz)

ROI segmentation (e.g., caudate nucleus and putamen) must be completed in advance.

🚀 Usage Pipeline
Image Preprocessing
Run OKT-N4_bias_field_correction.exe to perform bias field correction on the original MRI images.

Habitat Segmentation & Feature Extraction
Run sequentially:

OKT-gen_habitat_cluster.exe for habitat clustering (k can be set from 1 to 10)

OKT-gen_feature_cluster.exe to extract radiomic features from each habitat region

Model Training & Interpretation
Run the SVM_shap.R script in R to perform:

SVM model training and hyperparameter tuning

SHAP analysis and feature importance visualization

📊 Output Results
Corrected MRI images

Habitat segmentation maps (visualization for each cluster)

Feature matrix (CSV format)

Model performance evaluation (AUC, Sensitivity, Specificity, etc.)

SHAP feature contribution plots and bee swarm plots

📖 Citation & Acknowledgement
The code implementation of this study is based on the computational framework and foundational methods provided by the OnekeyAI Platform https://github.com/OnekeyAI-Platform/onekey.
