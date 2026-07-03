# Latent Predictive Learning: a compact map

---

## 0. One line

Most latent predictive learning methods are answering five questions:

1. how to encode history into a query latent $q$
2. how to compress a future window into a target latent $k$
3. what supervision to use: contrastive or predictive
4. whether to inject static prior
5. where hard negatives come from

---

## 1. History side: causal context encoder

Given history embeddings $x_{1:T}$, a causal encoder only allows token $t$ to attend to $\le t$:

$$
h_{1:T} = \mathrm{Enc}_{\mathrm{causal}}(x_{1:T}), \qquad q = f(h_T)
$$

Typical choice:

- causal Transformer
- last valid hidden state as summary
- MLP head to latent space

Essence:

- compress the past into a state representation
- keep temporal direction correct

Pros:

- natural for progression / forecasting
- handles variable-length history well

Cons:

- summary may over-focus on the last step
- long-range dependency is still hard

Best for:

- sequential patient state modeling
- any task where "future cannot leak into past"

---

## 2. Future side: how to define the target

The future is usually a short window $y_{1:W}$, but the model needs a single target vector $k$.

### Mean pooling

$$
k = \frac{1}{W}\sum_{w=1}^{W} y_w
$$

Pros:

- simplest
- stable

Cons:

- ignores order
- smooths away sharp transitions

### Attention pooling

$$
\alpha_w = \mathrm{softmax}(u^\top \tanh(W y_w)), \qquad
k = \sum_w \alpha_w y_w
$$

Pros:

- can focus on salient future steps

Cons:

- still shallow
- learned weights may become heuristic rather than structural

### Transformer over future window

$$
\tilde y_{1:W} = \mathrm{Enc}(y_{1:W} + p_{1:W}), \qquad
k = \mathrm{Pool}(\tilde y_{1:W})
$$

Pros:

- models order and local interaction

Cons:

- heavier than pooling baselines
- overkill when $W$ is tiny

### Latent-query cross attention

Use a few learnable latent queries $z_{1:m}$ to read future tokens:

$$
\hat z = \mathrm{CrossAttn}(z, y_{1:W}), \qquad k = \mathrm{Pool}(\hat z)
$$

Pros:

- compresses future into a small set of latent slots
- closer to Perceiver-style summarization

Cons:

- more parameters
- less interpretable than mean / attention pooling

### Gated multi-summary

Fuse several summaries:

$$
k = g_1 k_{\text{mean}} + g_2 k_{\text{last}} + g_3 k_{\text{attn}}, \qquad
g = \mathrm{softmax}(W[\cdot])
$$

Pros:

- adaptive bias-variance tradeoff

Cons:

- can collapse to one branch if not regularized

---

## 3. Contrastive predictive objective

The core InfoNCE form is:

$$
\mathcal{L}_{\text{NCE}}
= - \frac{1}{B}\sum_{i=1}^{B}
\log
\frac{\exp(q_i^\top k_i / \tau)}
{\sum_{j=1}^{B}\exp(q_i^\top k_j / \tau)}
$$

Interpretation:

- positive pair: same sample's history and future
- negatives: mismatched futures
- training target: make the true future most retrievable

Essence:

- predictive learning becomes a retrieval problem in latent space

Pros:

- no manual label required
- geometrically clean
- easy to evaluate with Recall@K / MRR

Cons:

- quality depends strongly on negatives
- may learn shortcuts if positives / negatives are too easy

Best for:

- self-supervised sequence representation learning
- when future matching matters more than exact reconstruction

---

## 4. Hard negatives: from random mismatch to semantic confusion

Random negatives are often too easy. Hard-negative methods try to sample futures that are close in one sense but different in another.

### Retrieval bank / ANN / FAISS

Build a bank of normalized vectors and search nearest neighbors by cosine similarity:

$$
s(q, k) = \frac{q^\top k}{\|q\|\,\|k\|}
$$

Essence:

- use approximate nearest neighbor search to mine confusing candidates

### Hard-negative taxonomy

Common ideas:

- same current state, different future
- same diagnosis/template, different progression
- semantically close but future-discordant

This makes the model solve a sharper question:

- not "is this future random?"
- but "which future is truly mine among plausible alternatives?"

Pros:

- improves discrimination
- reduces trivial separation

Cons:

- can introduce false negatives
- bank quality matters

Best for:

- dense embedding spaces where in-batch negatives are weak

### MoCo-style queue

Maintain a momentum encoder and a FIFO queue:

$$
\theta_k \leftarrow m \theta_k + (1-m)\theta_q
$$

Queue negatives enlarge the negative set beyond the current batch.

Pros:

- more negatives without giant batch size

Cons:

- stale keys
- extra teacher/queue machinery

---

## 5. Static conditioning: inject what does not change quickly

Dynamic history does not contain everything. Static signals can be injected in several ways.

### Prefix fusion

Project static summaries into prefix tokens and prepend them before dynamic tokens.

Essence:

- static information participates inside attention

Pros:

- deep interaction

Cons:

- may blur static / dynamic roles

### Concatenation fusion

Repeat a static summary and concatenate it to each time step:

$$
\tilde x_t = [x_t ; s]
$$

Pros:

- simple

Cons:

- crude
- same static vector is copied everywhere

### Gated latent fusion

Fuse after separate encoding:

$$
g = \sigma(W[z_{\text{dyn}}; z_{\text{static}}]), \qquad
z = g \odot z_{\text{dyn}} + (1-g)\odot z_{\text{static}}
$$

Pros:

- explicit balance between static and dynamic

Cons:

- interaction happens late

---

## 6. FiLM modulation

FiLM uses static latent $s$ to modulate dynamic latent $z$:

$$
\gamma = 1 + \Delta_\gamma(s), \qquad
\beta = \Delta_\beta(s), \qquad
\tilde z = \gamma \odot z + \beta
$$

Essence:

- static information changes feature scale and offset instead of being simply concatenated

Pros:

- lightweight
- feature-wise controllable

Cons:

- assumes modulation is mostly affine

Best for:

- when static context should bias, not replace, dynamic representation

---

## 7. Prototype prior

Learn prototype matrix $P \in \mathbb{R}^{K \times d}$ and softly assign static latent $s$:

$$
a = \mathrm{softmax}\!\left(\frac{sP^\top}{\tau_p}\right), \qquad
p = aP
$$

Then fuse prototype prior $p$ with dynamic latent.

Two common routes:

- gated fusion
- residual fusion

Residual form:

$$
z = z_{\text{dyn}} + \alpha p
$$

Essence:

- convert heterogeneous static covariates into a mixture of a few latent archetypes

Pros:

- interpretable cluster-like prior
- good for heterogeneous populations

Cons:

- prototype collapse / underuse
- assignment entropy must be watched

Best for:

- when population structure matters more than raw static detail

---

## 8. JEPA / BYOL-style predictive latent learning

This family removes explicit negatives. An online network predicts the future latent produced by a target network:

$$
z_c = f_{\theta}(x_{1:T}), \qquad
\hat z_f = g_{\theta}(z_c), \qquad
z_f = f_{\xi}(y_{1:W})
$$

Loss is usually cosine prediction:

$$
\mathcal{L}_{\text{pred}} = 2 - 2 \cos(\hat z_f, \mathrm{sg}(z_f))
$$

Target parameters are updated by EMA:

$$
\xi \leftarrow m \xi + (1-m)\theta
$$

Essence:

- predict a stable target representation rather than rank against negatives

Pros:

- avoids negative-sampling sensitivity
- often smoother optimization

Cons:

- collapse prevention is subtle
- quality depends on teacher dynamics and asymmetry

Best for:

- when contrastive negatives are noisy or hard to define

---

## 9. A compact method map

In latent predictive learning, methods usually modify exactly one of these layers:

1. **context encoder**: causal Transformer, last-state summary
2. **future target constructor**: mean / attention / Transformer / latent queries
3. **training signal**: InfoNCE vs predictive cosine
4. **conditioning path**: prefix / concat / gate / FiLM / prototype prior
5. **negative source**: in-batch, bank-mined, queue-based
