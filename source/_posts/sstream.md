---
title: sstream载入流的小笔记
mathjax: true
categories: C++
tags: notes
comments: true
---
# stringstream 载入流
---
## 1.int
读入当前指针所指的数字后并自动跳过后面的`tab` `\n` `\0`
如==1 3== 一开始指向1 读完1后指向3

## 2.char
也会跳过空格等，但是无法跳过/读到`eof`,只能让它强行读下一个
==a b c== 读完a指b 读完b指c 读完c还是c 再读一次指向eof
* 此条没查到 是我猜的，暂时未与实践矛盾

## 3.string
读入当前位置开始至缓冲结束 类似 `.str()`
移动到下一个开始处
==abc cba== 读完abc后指向c