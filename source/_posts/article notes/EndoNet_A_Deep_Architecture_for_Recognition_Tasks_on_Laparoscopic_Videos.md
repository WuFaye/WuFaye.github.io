---
title: EndoNet A Deep Architecture for Recognition Tasks on Laparoscopic Videos
tags: notes
categories: article notes
mathjax: true
---

# EndoNet: A Deep Architecture for Recognition Tasks on Laparoscopic Videos
## Basic Information
* link: https://ieeexplore.ieee.org/document/7519080
* abstract: a new CNN architecture (EndoNet) capable of phase recognition and tool presence detection tasks to recognize surgical workflow (Laparoscopic)

## dont know what to write
### Tool Presence Detection 
> radio frequency identification (RFID)-tagged surgical tool / other methods / **visual features**

### Phase Recognition
> tool usage signals / surgical action triplets(the ulilized tool + the anatomical structure + the surgical action ) / **visual features**

## model
* get a pre-trained CNN model
* traning images -> fine-tunning -> EndoNet architecture
* images -> Tool presence detection (EndoNet)
* images -> Feature extraction (EndoNet) -> SVM -> Hierarchical HMM

## EndoNet
kan bu dong 