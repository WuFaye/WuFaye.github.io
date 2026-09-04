---
title: AgentBench All in One
date: 2026-09-02 15:55:00
categories:
  - PaperReading
tags:
  - LLM-Agent
  - Benchmark
  - PsychAgentBench
  - EHR
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

#### bench 环境到底指什么

HealthAgentBench 里的 environment 不只是“agent 可见的数据文件”。它至少包括四层：

- agent-visible workspace：任务说明、原始数据、临床 artifact、可写 submission 文件。
- agent action interface：terminal、文件系统、脚本、图像处理、数据处理、模型训练等工具能力。
- hidden evaluation side：gold labels、verifier、success thresholds，这些不暴露给 agent。
- runtime lifecycle：container / Harbor trial、timeout、attempts、cost、runtime、metrics.json。

所以 benchmark environment 更接近“可执行任务沙盒”，而不是“检索数据库”。agent 看到的是工作区和工具，真正评分用的 gold/verifier 在测试侧。

#### 自主处理 / 写代码是否有必要

对医学临床 agent 来说，这种能力不一定总是必要，但对一类任务是必要的：

- 如果任务只是“查某个病人最近一次血钾”，结构化检索 API 更合理，不应该逼 agent 写代码。
- 如果任务是“从长病程中发现风险、整合多源证据、判断是否需要处置、形成结构化报告”，就需要 agent 自主选择证据、组织步骤、处理不完整信息。
- 如果任务是 EHR ETL、data quality audit、event modelling、cohort construction，写代码/运行脚本本身就是任务能力的一部分。

对 PsychAgentBench 更合适的折中是：

- clinical-facing mode 不强迫写代码，例如 active round / event trigger 主要通过临床语义工具和结构化输出完成。
- engineering / data mode 可以允许写代码，例如批量事件抽取、患者时间线构建、质量审计、统计汇总。
- 所有模式都应该限制 action space，避免“能写代码”变成绕过 benchmark 的作弊通道。

核心判断：自主处理能力不是为了炫技，而是为了测 agent 在复杂、长程、部分可见的临床任务中能否形成可验证的行动轨迹。

#### 这篇可以结束的原因

从 benchmark 设计角度，HealthAgentBench 最值得学的点已经清楚：

- packaged executable tasks
- hidden verifier / gold isolation
- task-specific metrics
- binary pass + raw score
- cost / runtime / attempts logging
- controlled variants for difficulty decomposition
- large clinical artifacts instead of prompt-ready QA

它对我们不是精神心理专门 benchmark，但它给出了“医疗 agent benchmark 怎么工程化”的最好模板之一；后续无需继续逐段精读。

---

## Reading Queue

### Must Read

#### GPAgentBench-2K: Benchmarking Large Language Model Agents in Complex Clinical Action Space

- Venue: arXiv 2026
- Link: https://arxiv.org/abs/2608.30188
- Why read:
  - 面向 primary-care clinical decision-making 的 CMDP benchmark。
  - 从 expert-validated real-world GP encounters 构建 2K+ cases。
  - 六类基础临床动作：ask、body_exam、test、diagnose、treat、refer。
  - 把 safety-informed abstention / refer 作为一等终局，而不是诊断失败。
- What to learn:
  - complex clinical action space 怎么定义。
  - topological workflow prior / action masking 怎么设计。
  - diagnosis accuracy、treatment score、management accuracy、missed referral、over-referral、diagnostic cost 如何共同评分。
  - quality-safety gap 怎么成为 benchmark 的亮点故事。

#### HealthAgentBench: A Unified Benchmark Suite of Realistic Agentic Healthcare Environments for Challenging Frontier AI Agents

- Venue: Microsoft Research / arXiv 2026
- Link: https://github.com/microsoft/HealthAgentBench
- Why read:
  - 医疗 agent benchmark 工程形态最值得参考。
  - 54 个 healthcare agent tasks，覆盖影像、病理、EHR ETL、trial matching、EHR data quality、EHR event modelling。
  - 每个 task 是 terminal environment + task-specific verifier。
- What to learn:
  - task directory
  - instruction format
  - verifier design
  - cost / time / success rate logging
  - gold leakage prevention

#### MemoryAgentBench: Evaluating Memory in LLM Agents via Incremental Multi-Turn Interactions

- Venue: ICLR 2026
- Link: https://github.com/HUST-AI-HYZ/MemoryAgentBench
- Why read:
  - 直接服务于 streaming ward monitor 设计。
  - 将 memory agent 能力拆成 accurate retrieval、test-time learning、long-range understanding、conflict resolution。
- What to learn:
  - 长期记忆任务如何构造。
  - 过期信息、冲突信息和新信息吸收如何评分。
  - 如何区分 long-context baseline 和 true memory agent。

#### FHIR-AgentBench: Benchmarking LLM Agents for Realistic Interoperable EHR Question Answering

- Venue: MLHC / PMLR 2026
- Link: https://proceedings.mlr.press/v297/lee26a.html
- Why read:
  - 评估 LLM agents 在 HL7 FHIR 标准 EHR 上做 realistic interoperable QA。
  - 比较 direct FHIR API、specialized tools、single/multi-turn、natural language/code reasoning。
- What to learn:
  - EHR 工具层怎么设计。
  - 不同 tool abstraction 对 agent 表现的影响。
  - 是否需要让 PsychAgentBench 暴露临床语义接口而不是底层表查询。

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

## Reading Template

每篇文献都按同一个模板记：

- 这篇 benchmark 想测什么能力？
- task instance 从哪里来？
- agent 能看到什么 observation？
- agent 能做什么 action？
- verifier / metric 怎么设计？
- 是否有 cost、time、trajectory、failure mode？
- 有哪些 reference construction / human expert validation / blinded expert eval？
- 有哪些可借鉴组件或工具？
- 它最强的设计点是什么？
- 它最弱或最容易被攻击的地方是什么？
- 哪一点能迁移到 PsychAgentBench？
- 哪一点不能照搬？
