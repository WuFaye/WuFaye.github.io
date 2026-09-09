---
title: PaperReading-IRCoT
date: 2025-03-12 10:15:12
tags:
    - CoT
    - RAG
categories: PaperReading
mathjax: true
---
# Interleaving Retrieval with Chain-of-Thought Reasoning for Knowledge-Intensive Multi-Step Questions

> DOI: https://doi.org/10.48550/arXiv.2212.10509
> publication: ACL 2023
> Date of publication: 2022-12-20
> code: https://github.com/StonyBrookNLP/ircot

---

* CoT & RAG interleavation

* multi-step reasoning

<!-- more -->

## IRCoT structure

* retrieve on query

* alternate $t$
    * extend CoT
        $\{q, \sum_{i<t}RAG\_docu_i, \sum_{i<t}CoT_i\} \to CoT_t$
    * expand RAG
        $CoT_t \to RAG\_docu_t$

* till answer / maximum steps

* collect all paragraphs as context
    no ranking

- [x] why not directly use IRCoT generate final ans?
    suboptimal choice: a seperate QA reader perform better or same

* QA reader
    generate answer from query and retrieved docu.
    * CoT prompting
    same template but generate CoT again with final sentence" answer is:..."
    tip: same LM for CoT generater and answer

    * direct prompting
    only ans

### details

* in-context demonstrating:
    * complete CoT
    * ground-truth supporting paras + M * distractor paragraphs(randomly sampled)

    * 20 * (query + CoT)

* test:
    * CoT so far
    * paras so far

    * take the first reasoning
    * retrieve top-k paras


### hyperparameter 

* K: each step retrieve top-k paras $\in \{2, 4, 6, 8\}$
* M: number of distractor paragraphs in in-context demonstrating in QA reader $\in \{1, 2, 3\}$

using 1st demonstrating set to search the best hyperparas.

## Experiment Results
* OneR QA & IRCoT QA & NoR QA

* effective in ODD setting

* reduce factual errors

* effective in small models

## Highlight & Limitations

* Restricted retrieval and thought processes