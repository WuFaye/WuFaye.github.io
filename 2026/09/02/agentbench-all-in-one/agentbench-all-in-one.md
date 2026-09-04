---
title: AgentBench All in One
date: 2026-09-02 15:55:00
categories:
  - PaperReading
tags:
  - LLM-Agent
  - Benchmark
---

# AgentBench All in One

> 设计一个面向精神科住院长病程的 LLM agent benchmark，重点评估 decision reasoning、active ward round、event-triggered triage，以及后续最有辨识度的 streaming ward monitor / memory task。

---

## Articles

### HealthFlow: Automating Electronic Health Record Analysis via a Strategically Self-Evolving Multi-Agent Framework

- Published: 2026-08-17
- Venue: npj Digital Medicine
- Link: https://www.nature.com/articles/s41746-026-03097-0
- Code / data: https://github.com/yhzhu99/HealthFlow

#### 核心技术机制

HealthFlow 的主系统可以理解成四个 agent 加一个 governed memory：

- Meta Agent / Planner
  - 把任务转成 EHR-aware plan。
  - 计划中显式考虑 dataset、schema、task family、risk tags。

- Executor Agent
  - 把 plan 转成代码、shell 命令、分析结果和报告。
  - 可调用外部 CLI / MCP 工具，例如 OneEHR 和 ToolUniverse。

- Evaluator Agent
  - 不只判断代码是否跑通，还判断方法学是否有效。
  - 例如模型指标异常完美时，不直接当成功，而是怀疑 temporal leakage 或 split misuse。
  - 输出 structured verdict：success status、failure type、violated constraints、repair guidance。

- Reflector Agent
  - 任务结束后读取完整 trajectory。
  - 把真正可复用的经验写回 long-term memory。
  - 服务的是跨任务学习，而不是当前任务即时修补。

- Governed Experience Memory
  - 把经验存成带 metadata 的结构化记忆。
  - 记忆类型包括 safeguard、workflow、dataset_anchor、code_snippet。
  - 检索受 task family、dataset signature、schema tags、risk tags 控制。

#### OneEHR

OneEHR 是一个 longitudinal EHR experiment Python library，用标准化 EHR 表和 TOML config 跑完整预测建模 / 分析流程。

它的核心接口是三张表：

- dynamic.csv：动态事件表。
- static.csv：患者静态信息表，可选。
- label.csv：标签事件表，可选。

#### ToolUniverse

ToolUniverse 是一组面向 biomedical agent 的工具集合，来自 TxAgent 相关生态，包含大量药物、疾病、生物医学知识查询工具，并连接可信来源，例如 FDA-approved drugs、Open Targets、Monarch Initiative 等。

Reference construction / human expert validation / blinded expert eval


---
### HealthAgentBench: A Unified Benchmark Suite of Realistic Agentic Healthcare Environments for Challenging Frontier AI Agents

- Published: 2026-06-30
- Venue: arXiv / Microsoft Research
- Link: https://arxiv.org/abs/2606.31179
- Project: https://microsoft.github.io/HealthAgentBench/
- Code: https://github.com/microsoft/HealthAgentBench

benchmark packaging：任务目录、执行环境、隐藏标签、verifier、leaderboard、成本时间统计。
根据时间戳构造数据环境？

#### 相比于普通的根据参数构建检索查血数据的方式 这种模型自主处理or写代码的方式体现的能力对于医学临床agent来说有必要吗

- 如果任务只是“查某个病人最近一次血钾”，结构化检索 API 更合理，不应该逼 agent 写代码。
- 如果任务是“从长病程中发现风险、整合多源证据、判断是否需要处置、形成结构化报告”，就需要 agent 自主选择证据、组织步骤、处理不完整信息。
- 如果任务是 EHR ETL、data quality audit、event modelling、cohort construction，写代码/运行脚本本身就是任务能力的一部分。

---
### GPAgentBench-2K: Benchmarking Large Language Model Agents in Complex Clinical Action Space

- Published: 2026-09-02
- Venue: arXiv
- Link: https://arxiv.org/abs/2608.30188
- Authors: Boqi Chen, Xudong Liu, Yunke Ao, Heejin Do, Jianing Qiu

它的关键创新：CMDP 而不是 MDP
普通 MDP 是最大化 reward，比如诊断对了就高分；CMDP 是在约束下最大化 reward，也就是：
maximize clinical reward
subject to safety cost <= threshold
and diagnostic cost <= threshold
单独惩罚安全风险 成本风险...

在外部 bench 里，类似思想通常表现为 cost / safety / policy compliance / over-escalation 等独立指标，而不是只看 task success；例如 HealthAgentBench 记录 cost/runtime，tau-bench 评估 policy compliance，医疗场景中 missed referral / unsafe action 应该单独成为不可被总分抵消的风险项。

persona-driven patient simulator

- 基于真实 GP encounter record 抽取结构化病例底座，再用人格、语言能力、病史可靠性、认知状态控制患者在问诊中的信息披露方式。
- 它模拟的不只是口吻，而是患者是否啰嗦、隐瞒、轻描淡写、表达有限、记忆混乱，从而让 agent 必须主动问诊和处理不完整信息。
  对应到精神病的患者问诊特诊？
  
#### 本地处理 vs 转诊二分类，在精神科住院里有没有类似标签
常规病区管理 vs 升级安全处置
继续当前治疗 vs 药物调整/暂停/紧急处理
精神科主线处理 vs 躯体/神经科会诊或转诊
可继续普通观察 vs 需要事件报警
出院准备 vs 暂缓出院/加强评估

whatif 构建一个长时程 随记录更新变化的精神病patient simulator

---
### MemoryAgentBench: Evaluating Memory in LLM Agents via Incremental Multi-Turn Interactions

- Published: 2025-07-07
- Venue: ICLR 2026
- Link: https://arxiv.org/abs/2507.05257
- Code / data: https://github.com/HUST-AI-HYZ/MemoryAgentBench

把 memory agent 的能力拆成四个可测维度：

- 准确检索、测试时学习、长程理解、选择性遗忘。

关键风险证据召回 single-hop /  multi-hop  

agent自己学什么


长程理解 替换现在的量表检索

病情反复 冲突/过期信息作为核心难点

增量注入协议： 按时间顺序喂入信息，这和住院病程天然一致。

- agent memory具体在记忆什么 是否应该在评测时持续提供早期时间的数据信息  

---
### FHIR-AgentBench: Benchmarking LLM Agents for Realistic Interoperable EHR Question Answering

- Published: 2026
- Venue: Proceedings of Machine Learning Research / MLHC
- Link: https://proceedings.mlr.press/v297/lee26a.html
- Code / data: https://github.com/JuliaLLee/FHIR-AgentBench

---

## Reading Queue

### Must Read 

#### APEX-MEM

- Venue: ACL 2026
- Link: https://aclanthology.org/2026.acl-long.749/
- Why read:
  - property graph + append-only temporal memory + retrieval-time conflict resolution。
- What to learn:
  - 状态演化如何保留。
  - 冲突记忆如何检索时解决，而不是写入时覆盖。
  - 精神科长病程中“否认风险 -> 出现风险 -> 风险缓解”的记忆表示。

#### Mem-Gallery: Benchmarking Multimodal Long-Term Conversational Memory for MLLM Agents

- Venue: ACL 2026
- Link: https://aclanthology.org/2026.acl-long.1892/
- Why read:
  - 多模态长期记忆 benchmark。
  - 评估 memory extraction、memory reasoning、memory knowledge management。
- What to learn:
  - memory benchmark 维度拆分。
  - 如何把多模态信息组织成可检索和可推理记忆。
  - 可迁移到 note / scale / lab / medication 多源临床记录。

#### TheAgentCompany: Benchmarking LLM Agents on Consequential Real World Tasks

- Venue: NeurIPS 2025 Datasets and Benchmarks Track
- Link: https://proceedings.neurips.cc/paper_files/paper/2025/hash/0d744742f6fac4d1134c019b7cef3c8a-Abstract-Datasets_and_Benchmarks_Track.html
- Why read:
  - 构造 self-contained simulated company environment。
  - 任务包含浏览、代码、程序执行、同事沟通。
  - 有 partial progress scoring。
- What to learn:
  - 如何把真实工作任务变成可控仿真环境。
  - 多角色、多工具、多步骤任务如何评估。
  - PsychAgentBench 可借鉴为多角色住院工作流。

### Important Reference

#### MedAgentBench / MedAgentBench v2

- Venue: NEJM AI / PSB 2026
- Link: https://doi.org/10.1056/AIdbp2500144
- Why read:
  - virtual EHR environment for medical LLM agents。
  - 涉及 patient communication、data retrieval、order、documentation 等临床工作任务。
- What to learn:
  - 临床 agent 环境如何组织。
  - EHR 工具和临床 action 如何绑定。
  - 我们如何进一步突出精神科长病程。

#### PhysicianBench: Evaluating LLM Agents in Real-World EHR Environments

- Venue: arXiv 2026
- Link: https://arxiv.org/abs/2605.02240
- Why read:
  - 100 个 long-horizon physician tasks，来自真实 primary care 到 subspecialty e-consult cases。
  - 使用 FHIR-compliant EHR sandbox 和 14 个结构化工具。
  - 任务覆盖 21 个 specialties，包括 psychiatry。
- What to learn:
  - checkpoint-level grading。
  - FHIR write actions 如何被 execution-grounded verifier 检查。
  - 长程 EHR workflow 如何拆成 data retrieval、reasoning、action execution、documentation。

#### MedMemoryBench: Benchmarking Agent Memory in Personalized Healthcare

- Venue: arXiv 2026
- Link: https://github.com/AQ-MedAI/MedMemoryBench
- Why read:
  - 面向 personalized healthcare dialogue 的 agent memory benchmark。
  - 包含多种 memory baseline 和 streaming evaluation。
- What to learn:
  - 医疗场景下 memory saturation、noise accumulation、temporal localization 如何评估。
  - 可作为 MemoryAgentBench 之外的医疗专门记忆参考。

#### AgentRx

- Venue: CHIL / PMLR 2026
- Link: https://proceedings.mlr.press/v333/al-jorf26a.html
- Why read:
  - multimodal clinical prediction agent。
  - 涉及 temporal EHR、影像、报告、notes 等 heterogeneous modalities。
- What to learn:
  - 多源临床信息如何组织为 agent prediction task。
  - baseline 和 evaluation 如何设计。

#### LLM-Based Multi-Agent Systems for Clinical Workflows: A Survey of AI Hospitals

- Venue: ACL 2026
- Link: https://aclanthology.org/2026.acl-long.2123/
- Why read:
  - clinical workflow multi-agent survey。
  - 可用于 introduction / related work。
- What to learn:
  - roles、handoff、shared state、EHR/guideline tools、safety gates、audit logs。
  - 如何把 PsychAgentBench 定位成 workflow-level clinical agent benchmark。

#### tau2 / tau3-bench series

- Link: https://taubench.com/
- Why read:
  - 动态 user-agent-tool interaction benchmark。
  - 强调 domain policy、database-state verification、multi-turn reliability。
- What to learn:
  - policy compliance scoring。
  - pass^k / reliability。
  - clinical policy constraints 的自动评分设计。

#### TUA-Bench: A Benchmark for Terminal-Use Agents

- Link: https://tuabench.ai/
- Why read:
  - terminal-based agent evaluation。
- What to learn:
  - 如果 PsychAgentBench 使用 terminal / file-system / structured data environment，可参考 setup、execution、artifact scoring。

#### AgentClinic: A Multimodal Benchmark for Tool-Using Clinical AI Agents

- Venue: npj Digital Medicine 2026
- Link: https://agentclinic.github.io/
- Why read:
  - 虽然早期版本是 2024 arXiv，但正式期刊版是 2026。
  - 用 patient、doctor、measurement、moderator agents 模拟临床交互。
  - 覆盖 sequential diagnosis、tool use、patient communication、bias。
- What to learn:
  - patient simulator 怎么构造。
  - clinical interaction bias 如何注入和评估。
  - 对精神心理场景的访谈、依从性、风险沟通可能有参考价值。

### Background Only

#### AgentBench: Evaluating LLMs as Agents

- Venue: ICLR 2024
- Link: https://github.com/THUDM/AgentBench
- Why only background:
  - 作为通用 agent benchmark 概念入口仍然重要，但时间较早。

#### WebArena: A Realistic Web Environment for Building Autonomous Agents

- Venue: ICLR 2024
- Link: https://proceedings.iclr.cc/paper_files/paper/2024/hash/4410c0711e9154a7a2d26f9b3816d1ef-Abstract-Conference.html
- Why only background:
  - functional correctness verifier 很经典，但不是医疗方向。

#### SWE-bench: Can Language Models Resolve Real-world GitHub Issues?

- Venue: ICLR 2024
- Link: https://www.swebench.com/original.html
- Why only background:
  - fail-to-pass executable verification 是必须知道的范式，但不是主读对象。

#### WorkArena / WorkArena++

- Venue: ICML 2024 / NeurIPS 2024
- Link: https://github.com/ServiceNow/WorkArena
- Why only background:
  - workflow benchmark 质量高，但 2025 前，作为工作流设计背景快速扫。

---
