---
title: Analyzing Sensitive Information Leakage in Trajectory Embedding Models
tags: notes
categories: article notes
mathjax: true
---

# Analyzing Sensitive Information Leakage in Trajectory Embedding Models
## Basic Information
* link: https://dl.acm.org/doi/abs/10.1145/3557915.3561021
* abstract: trajectory embedding vector attack

## the similarity-based attack
> area passed by user

* with embeddings of pre-defined spatial regions
* with queries on the location level
* not the same division

> partition: uniform grid-cell partition

### 1.constructing cell embeddings

partition and query for embeddings of each cell

### 2.searching for similar cells
k most similar cells(cosine similarity)/(Euclidean distance/Pearson correlation coefficient/Hamming distance)
$s_i=\displaystyle\frac{e_i \cdot e}{||e_i||\cdot ||e||}$ $for i=1,2,\dots,|V|$

### 3.constructing dense passing areas
density clustering(DBSCAN)-> average as the center

## the learning-based attack
> revert whole shape of trajectory

* with queries of the embedding model on trajectory level

### location inference attack
> whether pass by the ROIs
ROI: DBSCAN cluster -> set radius r

multi-label classification problem: trajectory T for each ROI

minimize the cross-entropy loss $L_{MLC}=-\sum_{R \in R}y_R log(\hat{y}_R)+(1-y_R)log(1-\hat{y}_R)$
> partition: data-driven: cluster trajectory location in auxiliary dataset -> potential ROIs

### embedding inversion attack
> partition: uniform grid-cell partition
* assume constant length of trajectories

RNN -> embedding inversion

*tired, finish the details one day...*

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({ tex2jax: {inlineMath: [['$', '$']]}, messageStyle: "none" });
</script>