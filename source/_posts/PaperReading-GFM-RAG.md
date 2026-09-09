---
title: PaperReading_GFM-RAG
date: 2025-03-05 15:10:13
tags:
    - graph
    - RAG
categories: PaperReading
mathjax: true
---
# GFM-RAG:Graph Foundation Model for Retrieval Augmented Generation

> DOI: https://doi.org/10.48550/arXiv.2502.01113
> publication: 
> Date of publication: 2025-02-03
> code: https://github.com/RManLuo/gfm-rag

---

* a graph-enhanced(pre-trained) retriever

* Implement "Multi-hop Inference and multi-hop Retrieval of Graph" by embedding fine-tuning

* more effective than single-step methods and more efficient than multi-step ones

<!-- more -->

## GFM-RAG structure
![alt text](PaperReading-GFM-RAG\GFM-RAG_0.png)

$$
\mathcal{G} = KG-index(\mathcal{D}) \\
\mathcal{D}^{K} = GFM-Retriever(q, \mathcal{D}, \mathcal{G}) \\
a = LLM(q, \mathcal{D}^K)
$$



### KG-index

> factual triples pointing to original document

* extract entities $\mathcal{E}$ & relations $\mathcal{R}$

* mentioned index $ M \in \{0, 1 \} ^{|\mathcal{E}| \times |\mathcal{D}|}$

* add addtional edges between similar semantic entities
### GFM retriever
![GFM-RAG](PaperReading-GFM-RAG\GFM-RAG_1.png)

* query dependent GNN
    $$H_q^L = GNN_q(q, \mathcal{G},H_0)$$
    entity representations updating on query $q$ after layer $L$
    capturing query-specific info. in GNN

    > same frozen sentence embedding model

    * for every query $q$
        * entity features initialization:
        $$H_e^0 = 
        \begin{cases} 
        \mathbf{q} = SentenceEmb(q)& e \in \mathcal{E_q} \\
        0 & otherwise 
        \end{cases}
        $$
        $$
        h_r^0 = SentenceEmb(r)
        $$
    * passing messages on triples
        $$
        m_e^{l+1} = Msg(h_e^{l}, g^{l+1}(h_r^l), h_{e'}^l), (e,r,e')\in \mathcal{G} \\
        h_e^{l+1} = Update(h_e^l, Agg(\{m_{e'}^{l+1} | e' \in \mathcal{N}_r(e), r \in \mathcal{R}\}))
        $$
    Msg: $NBFNet: f(e_h, r, e_t) = e_h^T w_R e_t$
    g: 2 layer MLP
    $m_e^{l+1}$: “从关系和邻居实体的角度”传给实体e 的信息

    - [ ] $H^0 = h_e^0$???
    - [ ] $h_e^0$ initialized by query $q$?
    - [ ] does/how $h_r^l$ updating?

* relevant score to a centain query
    $$P_q = \sigma(MLP(H_q^L))$$

* training loss

    > maximize the likelihood of relevant entities to the query

    BCE & RANK

    $$
    \mathcal{L} = \alpha \mathcal{L}_{\text{BCE}} + (1 - \alpha) \mathcal{L}_{\text{RANK}} \\
    \mathcal{L}_{\text{BCE}} = - \frac{1}{|\mathcal{A}_q|} \sum_{e \in \mathcal{A}_q} \log P_q(e) - \frac{1}{|\mathcal{E}^-|} \sum_{e \in \mathcal{E}^-} \log (1 - P_q(e)) \\
    \mathcal{L}_{\text{RANK}} = - \frac{1}{|\mathcal{A}_q|} \sum_{e \in \mathcal{A}_q} \frac{ P_q(e)}{\sum_{e' \in \mathcal{E}^-}P_q(e')}
    $$


## Training

### step 1: unsupervised KG completion 

* sample a set of triples from KG $q = (e, r, e')$

* mask head or tail entity

* query $q = (e, r, ?)$ or $q = (?, r, e')$

* predict the masked entity from $q$ and KG

### step 2: supervised document retrieval fine-tuning

* $q$: natural language questions
* labeled target entity

## generation
* top-T entities

* weigh by reverse of document mentioning frequency

    banlance popular entities

* calculate document relevant score -> retrieval argument

## Experiment Results

* GFM-RAG is not sensitive to different sentence embedding models
* the
 pre-trainingstrategy,aswellasthelossweightingstrategy,
 arebothcrucialfortheperformanceofGFM-RAG.
* fit nerual scaling law

* path interpretations

    - [ ] NBFNet
    
    multi-hop distribution

* model transferability
    domain specific: perform well in zero-shot generation