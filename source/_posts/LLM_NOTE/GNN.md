---
title: GNN
tags: notes
categories: 
date: 2024-10-8 08:00:11
mathjax: true
---
https://mp.weixin.qq.com/s/W30jAUdfRlgU6_Wt4D37EA

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<canvas id="myChart" width="400" height="200"></canvas>

<script>
    const ctx = document.getElementById('myChart').getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'bar', // 图表类型
        data: {
            labels: ['红色', '蓝色', '黄色', '绿色', '紫色', '橙色'], // X轴标签
            datasets: [{
                label: '# 的投票',
                data: [12, 19, 3, 5, 2, 3], // 数据
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>
## 模型

邻居聚合 -> 节点更新

### GCN

## 采样算法

### 基于节点采样
### 基于层采样
### 基于子图采样

## 图神经网络编程框架
## 分布式平台