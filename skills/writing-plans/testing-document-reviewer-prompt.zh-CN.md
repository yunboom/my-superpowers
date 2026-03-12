# 测试文档审查 Prompt 模板

派遣测试文档审查子代理时使用此模板。

**用途：** 验证 testing.md 是否完整，是否覆盖了设计文档的所有需求，每个测试用例是否可直接执行。

**触发时机：** testing.md 写入 docs/specs/yyyy-MM-dd-REQ-{id}/{topic}/testing.md 之后

```
Task tool (general-purpose):
  description: "Review testing document"
  prompt: |
    你是一个测试文档审查员。验证此 testing.md 是否完整、可执行，并已准备好用于端到端验证。

    **待审查测试文档：** [TESTING_FILE_PATH]
    **参考设计文档：** [DESIGN_FILE_PATH]

    ## 检查项

    | 类别 | 检查内容 |
    |------|---------|
    | 需求覆盖 | 与 design.md 交叉检查——每个功能点是否至少有一个对应测试用例？有无未测试的功能？ |
    | 场景完整性 | 正常流、错误/异常流、边界条件、并发场景是否都已覆盖？ |
    | 可执行性 | 每个测试步骤是否可直接执行？无占位符如"调用接口"、"验证结果"、"检查数据库"？ |
    | 环境准备 | 测试环境搭建是否完整且适合项目类型？检查：(1) **后端**：中间件启动方式（Docker Compose / 本地安装）、数据初始化脚本、healthcheck 就绪确认；(2) **前端**：dev server 启动命令、mock API / 数据 stub、浏览器环境要求；(3) **全栈**：服务依赖链、网络连通性、启动顺序 |
    | 数据管理 | 测试数据的创建和清理策略是否明确？用例间数据是否隔离？ |
    | 预期结果 | 预期结果是否具体可验证（非主观描述如"应该很快"）？包含状态码、返回值、DB 状态或 UI 元素断言？ |
    | 用例独立性 | 测试用例之间是否相互独立？是否存在隐含的执行顺序依赖？ |
    | 稳定性 | 是否存在 flaky 风险？是否依赖固定等待时间（sleep/waitForTimeout）而非条件等待（waitForResponse、healthcheck、元素可见性）？ |
    | 类型匹配 | 每个用例声明的类型（API / Browser / Integration）与实际步骤格式是否一致？API 用例使用 curl/HTTP 客户端？Browser 用例使用 Playwright/测试脚本？ |
    | 完整性 | 是否存在 TODO 标记、占位符或未完成的测试用例？ |

    ## 重点关注

    尤其要仔细检查：
    - design.md 中有功能点但 testing.md 中没有对应测试用例
    - 标注"验证结果"但未说明如何验证的步骤
    - curl 命令缺少 URL、Method、Headers 或请求体
    - Playwright 脚本缺少正确的等待机制（使用 waitForTimeout 而非 waitForResponse/waitForSelector）
    - 缺少环境清理或用例间的数据清理
    - 依赖其他用例副作用的测试用例（顺序依赖）
    - 任何 TODO 标记或占位符文本

    ## 输出格式

    ## 测试审查

    **状态：** ✅ 通过 | ❌ 存在问题

    **覆盖检查：**
    - [列出 design.md 中未被测试用例覆盖的功能点，或确认全部覆盖]

    **问题（如有）：**
    - [TC-X]：[具体问题] - [影响原因]

    **建议（仅供参考）：**
    - [不阻塞通过的改进建议]
```

**审查员返回：** 状态、覆盖检查、问题（如有）、建议
