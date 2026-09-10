---
title: AgentBench Safety All in One
date: 2026-09-10 00:00:00
categories:
  - PaperReading
tags:
  - LLM-Agent
  - Benchmark
  - Safety
  - Psychiatry
---

# AgentBench Safety All in One

> 以安全性为主线，整理临床 agent benchmark 如何从“答对没有”推进到“是否在正确的时间，基于正确证据，采取了不会伤害患者的行动”。目标是为 PsychAgentBench 增加可独立成文的 safety track。

## 研究问题

普通医学问答只检查最终答案，无法区分“临床上合理地完成任务”和“碰巧给出了正确结论”。对精神科住院长病程 agent，真正危险的失败包括：没有发现自杀或冲动风险、错过药物不良反应、在证据不足时过度自信、没有升级处置、重复或越权执行操作，以及使用已经被新事件否定的旧信息。

因此安全评测至少要同时记录四类结果：

- **结局安全**：最终是否漏掉高风险、是否给出危险处置。
- **过程安全**：是否查阅了必要证据、完成了关键核查、按临床流程升级。
- **行动安全**：工具调用、写入、转诊、停药或加药等动作是否在权限和证据范围内。
- **运行可靠性**：长任务中是否稳定，是否重复调用工具，是否在资源和时间预算内完成。

## Articles

### GPAgentBench-2K: Benchmarking Large Language Model Agents in Complex Clinical Action Space

- Published: 2026-08-31
- Venue: arXiv
- Link: https://arxiv.org/abs/2608.30188
- Task type: expert-validated primary-care encounters with executable clinical actions

#### 核心问题

GPAgentBench-2K 关注的不是模型能否从病例中猜出诊断，而是模型能否在复杂临床行动空间中选择合适的下一步。作者把一次全科诊疗建模为一个**约束马尔可夫决策过程**：状态包含患者信息和当前工作流位置，动作包含问诊、检查、诊断、治疗、随访等临床行为，约束则规定某些高风险状态下必须先完成核查、转诊或安全处置。

与普通 MDP 只有“最大化任务奖励”不同，约束版本要求同时满足安全条件。可以写成：

$$
\max_\pi J_R(\pi),\qquad \text{s.t. }J_{C_k}(\pi)\le d_k
$$

其中 $J_R$ 是临床任务收益，$J_{C_k}$ 是第 $k$ 类违规风险的期望代价，$d_k$ 是允许上限。这个形式表达了一个重要原则：安全违规不能被其他正确动作的奖励完全抵消。

#### 技术方法

- 用专家验证的真实 GP encounter 构造病例和参考行动路径。
- 将临床行动空间扩展为六类基础动作，而不是只输出一个诊断标签。
- 用拓扑工作流先验限制不合理的动作顺序，例如不能在没有必要信息时直接完成高风险治疗动作。
- 把 **abstention** 作为正式结果：模型可以承认信息不足并请求人工或升级处理，而不是被迫猜测。
- 采用约束感知的训练基线 C-GRPO，与无约束强化学习方法比较。

#### 主要结果

模型性能随着行动空间扩大显著下降。更重要的结果是 **clinical quality-safety gap**：诊断准确率最高的前沿模型，在高风险病例中仍有超过一半违反安全约束。加入约束的强化学习比无约束方法更好，但距离临床可接受水平仍然很远。

#### 对 PsychAgentBench 的直接启发

1. 不把“诊断正确”当作安全。高风险病例应有硬约束，例如必须完成自杀风险核查、冲动/攻击风险判断、药物相互作用核查或升级建议。
2. `abstain`、`escalate`、`need_more_evidence` 应成为一等输出，而不是失败答案。
3. 安全分数应单独报告，不能与任务成功率简单平均。
4. 用工作流拓扑约束精神科住院动作顺序，例如“发现异常 -> 核实趋势 -> 判断紧急程度 -> 采取病区措施/通知上级 -> 记录依据”。

### HealthAgentBench: A Unified Benchmark Suite of Realistic Agentic Healthcare Environments for Challenging Frontier AI Agents

- Published: 2026-06-30
- Venue: arXiv / Microsoft Research
- Link: https://arxiv.org/abs/2606.31179
- Code: https://github.com/microsoft/HealthAgentBench
- Task type: terminal-based end-to-end healthcare workflows

#### 核心问题

HealthAgentBench 把 agent 放进一个终端环境，让它自己查看原始数据、使用工具、编写或运行代码，并完成多步医疗或生物医学任务。它评测的是环境中的工作能力，而不是从题目文本直接生成答案。

#### 技术方法

- 共 54 个任务，覆盖 7 个 healthcare task categories。
- 每个任务都有独立环境、最小化指令、可执行工作流和 task-specific verifier。
- 输入可能是文本、结构化 EHR、二维或三维医学影像、病理全切片等原始材料。
- verifier 检查最终 artifact 或结构化结果，而不是依赖主观的语言相似度。
- 同时统计 task success、运行成本和耗时，使“完成任务但极度浪费资源”的 agent 暴露出来。

#### 主要结果

总体任务成功率仍然很低。论文报告中，最强且成本效率较高的 Codex GPT-5.5 也只有约 42% 的整体成功率。模型在 EHR 建模流水线方面已有一定能力，但医学影像和需要大规模搜索加组合推理的任务仍很困难。

#### 安全价值

它最值得借鉴的不是某一个医学指标，而是 benchmark packaging：任务目录、隔离环境、隐藏标签、执行记录和 verifier 组合成一个可复现评测单元。对 PsychAgentBench，这意味着每个病例不能只保存 gold answer，还要保存允许动作、禁止动作、必须检查的证据和关键时间点。

### HealthFlow: Automating Electronic Health Record Analysis via a Strategically Self-Evolving Multi-Agent Framework

- Published: 2026-08-17
- Venue: npj Digital Medicine
- Link: https://www.nature.com/articles/s41746-026-03097-0
- Code: https://github.com/yhzhu99/HealthFlow
- Benchmark: EHRFlowBench

#### 核心问题

HealthFlow 面向 EHR 分析工作流，而不是临床对话。agent 需要理解数据集和 schema，规划分析步骤，写代码执行，检查结果，再根据失败原因修复。其安全含义是：一个分析结果即使数值漂亮，也可能因为数据泄漏、时间切分错误或错误理解字段而不可信。

#### 技术方法

系统由四类角色和受治理的经验记忆组成：

- **Planner**：把自然语言任务转成考虑数据集、schema、任务族和风险标签的计划。
- **Executor**：调用工具、写代码、运行分析并产出结果。
- **Evaluator**：检查代码是否运行，也检查统计方法、切分方式和潜在 temporal leakage。
- **Reflector**：从完整 trajectory 中提取可复用经验。
- **Governed memory**：以 safeguard、workflow、dataset anchor、code snippet 等结构保存经验，并按任务族、schema 和风险标签检索。

EHRFlowBench 提供 100 个 EHR 分析任务。任务重点不是给 agent 一份整理好的 QA 数据，而是让 agent 在规定的数据和分析环境中完成可验证的 EHR workflow。

#### 对安全 benchmark 的启发

HealthFlow 把安全从“输出内容是否危险”扩展到“分析过程是否污染了结论”。PsychAgentBench 也需要检查时间穿越：agent 在住院第 $t$ 天做判断时，不能访问 $t$ 天之后的化验、量表或医嘱。这个约束应由环境和 verifier 强制执行，而不是只在 prompt 中提醒。

### MedCTA: A Benchmark for Clinical Tool Agents

- Published: 2026
- Venue: clinical-agent benchmark / preprint project
- Link: https://ivul-kaust.github.io/MedCTA/
- Task type: clinician-validated tool-use trajectories

#### 技术方法

MedCTA 包含 107 个真实临床任务，覆盖 5 个部署工具和多模态输入。它提供临床专家验证的、隐含步骤的可执行 trajectory。评价拆成五个层次：

- tool selection：是否选了正确工具；
- argument validity：工具参数是否正确；
- execution stability：调用是否成功、是否能处理错误；
- trajectory fidelity：行动顺序和证据路径是否接近合理临床流程；
- outcome quality：最终临床结果是否正确且安全。

#### 最值得学习的地方

MedCTA 说明“最终答案正确”无法覆盖工具 agent 的中间风险。比如查询错患者、时间范围错误、参数缺失、在工具失败后假装成功，最后都可能生成看似合理的文本。PsychAgentBench 的 `active_round_tasks` 和 `event_trigger_tasks` 应保存每次工具调用的患者、时间窗、字段、返回状态和引用证据，便于做 checkpoint-level safety grading。

### PatientAgentBench: A Benchmark Framework for Evaluating Patient-Facing Health AI Agents

- Published: 2026-07
- Venue: arXiv
- Link: https://arxiv.org/abs/2607.25485
- Code: https://github.com/amazon-science/PatientAgentBench
- Task type: patient-facing conversation with a healthcare tool sandbox

#### 技术方法

PatientAgentBench 将基础模型包装成 agent，放入医疗工具沙箱，并让它与模拟患者进行多轮交互。它同时评价任务完成、临床安全、工作流准确性、分诊质量和对话帮助性，因此把患者体验和医疗风险放在同一套 agent 评测中。

它特别关注两类不可接受失败：agent 声称执行了实际上没有执行的工具动作，以及在紧急情况下没有给出危机资源或升级建议。评价结果显示，前沿模型的失败率已较低，但仍存在未验证工具输出和遗漏危机资源等安全错误。

#### 对精神心理场景的价值

精神心理 agent 不能只测“是否给出正确建议”，还必须测是否识别危机语句、是否避免不当保证、是否询问必要的风险信息、是否在需要时把患者交给人工或急诊系统。PatientAgentBench 的患者模拟器和多轮工具沙箱可以作为门诊/患者端 safety track 的参考，但不能替代 PsychAgentBench 的住院时序环境。

### PhysicianBench: Evaluating LLM Agents in Real-World EHR Environments

- Published: 2026
- Venue: arXiv
- Link: https://arxiv.org/abs/2605.02240
- Task type: long-horizon physician tasks in a FHIR-compliant EHR sandbox

#### 技术方法

PhysicianBench 使用 100 个跨专科的长程 physician tasks，配套 FHIR-compliant EHR sandbox 和结构化工具。任务从真实 primary-care 到专科 e-consult 场景抽取，拆分成数据检索、推理、行动执行和文档记录。评价不只看终点，还在 checkpoint 检查中间状态和写操作。

#### 安全启发

FHIR write action 需要 execution-grounded verifier：只有真的在环境中完成写入才算完成，文本里声称“已下医嘱”不能算。PsychAgentBench 可以把“通知上级”“加入观察”“调整监测频率”“记录风险评估”等动作建成可验证事件，并区分建议动作、已执行动作和需要人工批准的动作。

## 统一比较

| 工作 | 环境真实性 | 安全粒度 | 主要可迁移设计 |
| --- | --- | --- | --- |
| GPAgentBench-2K | 结构化临床行动环境 | 约束、拒答、高风险病例 | CMDP、硬安全约束、abstention |
| HealthAgentBench | 终端和多模态执行环境 | 任务成功、成本、耗时 | 隔离环境、隐藏 verifier、artifact scoring |
| HealthFlow | EHR 分析流水线 | 方法学和数据泄漏 | 风险感知规划、失败诊断、过程审计 |
| MedCTA | 多工具临床环境 | 调用级和轨迹级 | 参数校验、工具失败检测、checkpoint grading |
| PatientAgentBench | 患者多轮对话 | 危机和患者端安全 | 模拟患者、危机升级、未执行动作检测 |
| PhysicianBench | FHIR EHR 工作流 | 中间状态和写操作 | execution-grounded verifier、长任务分解 |

## PsychAgentBench Safety Track 设计

### 1. 风险场景分层

将病例按安全严重度分为普通、需要关注、高风险和紧急四层。高风险不是只由一个标签决定，而应由时间序列中的证据组合决定，例如自杀意念变化、既往行为史、保护因素减弱、激越升级、药物不良反应和实验室异常共同出现。

### 2. 必须完成的安全检查

每个高风险节点保存一组 `must_check`，例如风险意念、计划和手段、近期行为、精神病性症状、冲动/攻击风险、药物暴露和关键生命体征。agent 没有完成必要检查时，即使最后给出正确升级结论，也应在过程安全中扣分。

### 3. 可执行动作与禁止动作

动作分成观察、追问、检索、复核、通知、升级、转诊、记录和治疗建议。每个动作有权限、前置证据、时间窗和严重度。禁止动作包括无依据停药/加药、把未执行的通知写成已执行、把未来信息当作当前证据，以及在紧急病例中仅给出安慰而不升级。

### 4. 指标

建议至少报告以下指标，而不是只给一个总分：

- `critical_miss_rate`：关键风险未发现的比例。
- `unsafe_action_rate`：发生危险或越权动作的比例。
- `required_check_completion`：必须安全检查的完成率。
- `appropriate_escalation`：需要升级时正确升级、无需升级时不过度升级的联合指标。
- `evidence_temporal_fidelity`：每个判断引用的证据是否在当前时间点可见且未被更新信息否定。
- `tool_execution_fidelity`：声称动作与环境中真实执行动作的一致率。
- `pass^k`：连续 $k$ 个病例都无关键安全错误的概率，用于衡量部署所需的稳定性。
- `cost_per_safe_task`：完成一个无关键安全错误任务的工具和 token 成本。

安全主分数不应与普通任务成功率简单相加。更合适的报告方式是先给硬门槛，再给效率：只要出现 critical miss 或 unsafe action，病例安全判定失败；通过安全门槛后，再比较任务完成率、路径质量和成本。

### 5. 长时序 streaming ward monitor

这是 PsychAgentBench 最有辨识度的安全任务：按住院时间顺序增量注入病程、量表、化验、用药和行为事件，agent 每一步决定是否报警、继续观察、追问或升级。评测同时检查：

- 新风险是否及时发现；
- 旧风险缓解后是否停止重复报警；
- 后续事件是否覆盖早期判断；
- 缺失信息时是否保持不确定性；
- 关键事件是否在有限窗口和成本预算内被检索出来。

这个任务把 memory、时间一致性和安全决策放在同一个可执行环境中，能够区别于单轮医学 QA，也能和普通滑动窗口、RAG、summary baseline 做清晰对比。

## 当前结论

这些工作共同说明，临床 agent benchmark 的核心单位正在从“病例-答案”变成“状态-证据-动作-后果”的可验证轨迹。GPAgentBench-2K 提供约束行动空间，HealthAgentBench 提供端到端环境和 verifier，HealthFlow 提供过程审计，MedCTA 提供工具调用级评分，PatientAgentBench 提供患者端危机安全，PhysicianBench 提供长程 EHR 和真实写操作验证。

PsychAgentBench 的亮点不应是再做一个精神科问答集，而应是：在真实住院时间轴上，用风险严重度驱动的任务采样、不可被总分抵消的安全门槛、checkpoint-level 轨迹评分和 streaming monitor，系统测量 agent 是否能够及时发现、正确升级并持续更新精神心理风险。

