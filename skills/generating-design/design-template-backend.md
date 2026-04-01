# 技术⽅案模板

# xxx技术⽅案

# 模板说明：

以todo前缀标注的段落/图⽚是需要进⾏替换或设计。最后请删除掉模板说明这段⽂字。案例参考(旧模板)： 保险平台技术⽅案 分账系统技术⽅案

# ⼀、 修订历史

<table><tr><td rowspan=1 colspan=1>修订内容</td><td rowspan=1 colspan=1>修订时间</td><td rowspan=1 colspan=1>修订人</td></tr><tr><td rowspan=1 colspan=1>新建初稿</td><td rowspan=1 colspan=1>202x-xx-xX</td><td rowspan=1 colspan=1>xxx</td></tr></table>

# ⼆、 需求背景

# 2.1、需求内容

todo//替换成对应PRD链接

# 2.2、需求分析

系统0-1建设、系统重构、中⼤型项⽬要求填写，其他项⽬结合实际情况评估

todo//结合业务流程及业务模型诉求，确认系统的业务架构及核⼼功能要求的分析过程，并确认最终的可⾏性

# 2.3、⽬标评估（包含性能\容量）

todo//xxx接⼝需要达到50qps，并且P99在xxms以内。

# 2.4、术语说明

todo//⽂档中的术语

# 三、系统设计

# 3.1、⽅案总述

系统0-1建设、系统重构、中⼤型项⽬要求填写，功能迭代可以⾮必填

• 从系统架构设计⻆度进⾏总述，可以包括但不限于，标准化、配置化、准确性、⼀致性、⾼性能、⾼吞吐、⾼扩展、⾼可⽤等。

设计⽬标：

a. 标准化：

b. 准确性：c. ⾼扩展d. ⾼可⽤：

总体思想：todo//请陈述总体思想详细信息。

# 3.2、架构设计

todo//系统模块图、业务架构图

# 3.3、部署设计

todo//部署图

# 3.4、模块设计

常规设计考量点：设计原则（软件设计的七⼤原则、 后端开发实践-领域驱动设计）、设计模式、幂等、时序、锁、事务（粒度）、慢查询（DB/Redis）、补偿、数据可溯源、读写分离主从延迟、历史功能/数据兼容性（务必确保评估的完整性，可通过⼤数据⽅式评估）、流量回放数据核对（重构场景）、灰度设计（C端流量可通过AB进⾏灰度，MQ和批处理任务需要⾃⼰实现灰度功能）。

# 3.4.1、数据模型

# todo//数据模型图

以下是每个数据模型说明， 例如数据模型A例如数据模型A。

• 数据模型A：数据模型A详细描述。

# 3.4.2、状态机

todo//状态机说明。

# todo//xx状态扭转图

# 3.4.3、xxx模块

todo//模块简述

# 3.4.3.1、xxx功能

todo//功能简述。

# todo//xxx功能流程图（泳道图/时序图）

以下是针对流程图的详细说明

1. xxxx。
2. xxxx。

# 3.4.3.2、可维护性设计

todo//模块设计原则和设计模式，主要是平台化设计，包括：业务模型抽象、标准化、扩展性、配置化设计等

# 3.5、存储设计

# 3.5.1、DB设计（如不涉及，填写⽆）

• 数据库规范： MySQL数据库设计规范 ；唯⼀索引是否合理（唯⼀索引作为最后的数据防重⼿段，系统设计上需要将并发请求拦截在应⽤层，勿将⽆效流量穿透到DB）。

• 有些历史表存在测试环境字符集和⽣产环境字符集不⼀致的情况，对这类表字符串字段的的操作和转换可能会引起慢查询，请注意。

# 3.5.1.1、ER图

# 请参⻅3.4.1、数据模型章节

3.5.1.2、DDL

# 3.5.1.3、DML

update\insert\delete

3.5.1.4、关键SQL select

# 3.5.2、缓存设计（如不涉及，填写⽆）

<table><tr><td rowspan=1 colspan=1>含义</td><td rowspan=1 colspan=1>KEY</td><td rowspan=1 colspan=1>VALUE</td><td rowspan=1 colspan=1>数据结构</td><td rowspan=1 colspan=1>过期时间</td><td rowspan=1 colspan=1>所在实例</td><td rowspan=1 colspan=1>缓存失效处理</td></tr><tr><td rowspan=1 colspan=1>分布式锁</td><td rowspan=1 colspan=1>前缀+xx产品编码+业务单号</td><td rowspan=1 colspan=1>imt</td><td rowspan=1 colspan=1>string</td><td rowspan=1 colspan=1>305</td><td rowspan=1 colspan=1> xxx_cache</td><td rowspan=1 colspan=1>过期失效策略</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.5.3、环境变量（如不涉及，填写⽆）

<table><tr><td rowspan=1 colspan=1>名称</td><td rowspan=1 colspan=1>VALUE</td><td rowspan=1 colspan=1>描述</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.6、消息队列设计（如不涉及，填写⽆）

<table><tr><td rowspan=1 colspan=1>TOPIC</td><td rowspan=1 colspan=1>GROUP</td><td rowspan=1 colspan=1>生产者</td><td rowspan=1 colspan=1>消费者</td><td rowspan=1 colspan=1>body内容</td><td rowspan=1 colspan=1>场景</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.7、接⼝设计（如不涉及，填写⽆）

# 3.7.1、接⼝总览

<table><tr><td rowspan=1 colspan=1>应用名</td><td rowspan=1 colspan=1>接口</td><td rowspan=1 colspan=1>接口功能描述</td><td rowspan=1 colspan=1>新增/修改</td><td rowspan=1 colspan=1>改动说明</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

![](images/c4facd52d9877d5e7bc897a2430f721d63543c772cd6d48b095c72fbd05dd8df.jpg)

# 3.7.2、接⼝协议

# 3.7.2.1 xxx功能

请求参数

响应参数

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>名称</td><td rowspan=1 colspan=1>参数</td><td rowspan=1 colspan=1>是否必传</td><td rowspan=1 colspan=1>类型</td><td rowspan=1 colspan=1>备注</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>名称</td><td rowspan=1 colspan=1>参数</td><td rowspan=1 colspan=1>是否必传</td><td rowspan=1 colspan=1>类型</td><td rowspan=1 colspan=1>备注</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.8、可靠性设计

# 3.8.1、监控告警（如不涉及，填写⽆）

监控可分为系统监控和数据监控，监控告警遵循不漏报，不误报原则，告警通知需要及时处理或调整，避免故障升级为事故。

系统监控：接⼝耗时、成功率，⾃定义上报等关键指标，请参考： 监控告警平台(grafana)使⽤⼿册 。

• 数据监控：系统内/间数据准确性、⼀致性。准实时/ $\mathtt { D } + 1$ 对账监控，请参考： 监控看板样例 ，监控看板上线后申请https://finebi.shoplazza.com/相应看板空间权限。

<table><tr><td rowspan=1 colspan=1>监控对象</td><td rowspan=1 colspan=1>监控指标</td><td rowspan=1 colspan=1>故障影响</td></tr><tr><td rowspan=1 colspan=1>接口/自定义监控项</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.8.2、异常处理（如不涉及，填写⽆）

<table><tr><td rowspan=1 colspan=1>异常点描述</td><td rowspan=1 colspan=1>监控机制 (工具和级别)</td><td rowspan=1 colspan=1>异常处理方案</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>阐述SOP流程</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.8.3、流量评估（如不涉及，填写⽆）

对下游服务流量影响评估。新功能⼀般采⽤灰度放量机制，灰度量级增加时需要关注业务链路各系统运⾏情况。

<table><tr><td rowspan=1 colspan=1>接口名称</td><td rowspan=1 colspan=1>接口流量</td><td rowspan=1 colspan=1>依赖服务/组件</td><td rowspan=1 colspan=1>评估结论</td></tr><tr><td rowspan=1 colspan=1>xxx</td><td rowspan=1 colspan=1>xxx/秒</td><td rowspan=1 colspan=1>列出所有的依赖服务和组件（DB、redis、ES)</td><td rowspan=1 colspan=1>xxx服务需新增扩容x个pod支撑本次业务接入</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 3.8.4、刷数脚本（如不涉及，填写⽆）

批处理最重要的影响评估项是数据更新频率，更新过快会影响数据库性能或下游系统负载，同时如果是读写分离架构会拉⻓主从数据同步延迟影响正常业务。因此数据更新频率评估极其重要，设计技术⽅案时可找DBA确认⽬标数据库合理的更新频率。

<table><tr><td colspan="1" rowspan="1">脚本名称</td><td colspan="1" rowspan="1">预计变更数量</td><td colspan="1" rowspan="1">变更频率</td><td colspan="1" rowspan="1">下游服务</td><td colspan="1" rowspan="1">评估结论</td></tr><tr><td colspan="1" rowspan="1">xxx</td><td colspan="1" rowspan="1">xxx</td><td colspan="1" rowspan="1">xxx/秒</td><td colspan="1" rowspan="1">列出所有的下游依赖服务</td><td colspan="1" rowspan="1">：  数据更新xxx/秒时不影响xxxdb吞吐能力. xxx服务需新增扩容×个pod支撑本次脚本执行</td></tr><tr><td colspan="1" rowspan="1"></td><td colspan="1" rowspan="1"></td><td colspan="1" rowspan="1"></td><td colspan="1" rowspan="1"></td><td colspan="1" rowspan="1"></td></tr></table>

# 3.9、安全合规（如不涉及，填写⽆）

• 加密所有的敏感数据◦ 参数传递◦ 敏感信息存储◦ ⽇志脱敏

收集⽤⼾信息是否合法◦ cookie信息以及是否可⽤重要信息需要鉴权访问◦ C端接⼝屏蔽敏感信息◦ B端接⼝员⼯访问权限

# 四.影响范围

todo//各团队梳理⾃⼰模块的影响范围checklist。

## 4.1 业务场景影响

描述本次变更对现有业务场景/用户流程的影响，需覆盖以下维度：

• **正向场景（新增/增强）**：本次变更新增或优化了哪些业务能力，用户/商家将获得哪些新体验。

• **存量数据兼容**：现有数据在变更上线后是否能正常流转，涉及状态迁移、历史订单/账单处理的需说明兼容策略。

• **异常/边界场景**：变更对降级、熔断、退款、退款重试等异常链路的影响，以及是否引入新的失败路径。

• **跨业务域联动**：变更是否触发其他业务域（如风控、结算、通知、积分）的联动逻辑，需逐一说明触发条件与预期行为。

<table><tr><td rowspan=1 colspan=1>业务场景</td><td rowspan=1 colspan=1>影响类型</td><td rowspan=1 colspan=1>影响说明</td><td rowspan=1 colspan=1>兼容策略</td></tr><tr><td rowspan=1 colspan=1>xxx场景（如：用户下单）</td><td rowspan=1 colspan=1>新增 / 变更 / 无影响</td><td rowspan=1 colspan=1>描述具体影响点</td><td rowspan=1 colspan=1>描述如何保证存量数据/用户不受损</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

## 4.2 代码模块影响

<table><tr><td rowspan=1 colspan=2>影响模块</td><td rowspan=1 colspan=1>说明</td></tr><tr><td rowspan=3 colspan=1>xxx模块</td><td rowspan=1 colspan=1>xxx功能</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>

# 五.上线部署

# 5.1发布计划

发布变更：需要特别注意检查环境变量和DB变更信息的完整性和准确性，确保不漏变更、不错变更。

# 灰度原则：

C端：美服A/B 美服全量

B端：选取⼩流量店铺逐级灰度，每个灰度阶段需要核实数据符合预期后才能进⼊下⼀灰度阶段。

需求发布前在 RD&QA 群创建发布话题。并遵守如下：

主动沟通前置依赖⽅，明确其完成时间并记录发布完成后，主动在群⾥通知下⼀步骤负责⼈发布前确认清楚相关⼈的时间，避免发完QA⽆法及时验收、后续步骤负责⼈⽆法联系等• 开发周期 ${ > } 5$ 或参与⼈ ${ > } 3$ ，务必要有发布计划

<table><tr><td rowspan=1 colspan=1>发布内容</td><td rowspan=1 colspan=1>发布单</td><td rowspan=1 colspan=1>发布方式</td><td rowspan=1 colspan=1>前置依赖</td><td rowspan=1 colspan=1>负责人</td><td rowspan=1 colspan=1>完成进度</td></tr><tr><td rowspan=1 colspan=1>创建xxx模块数据表ABC</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>无</td><td rowspan=1 colspan=1>@xxx</td><td rowspan=1 colspan=1>美服完成</td></tr><tr><td rowspan=1 colspan=1>后端xxx模块发布</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>灰度全量</td><td rowspan=1 colspan=1>无</td><td rowspan=1 colspan=1>@xxx</td><td rowspan=1 colspan=1>美服完成</td></tr><tr><td rowspan=1 colspan=1>前端xxx模块修改环境变量xxx增加配置xxx</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>全量</td><td rowspan=1 colspan=1>□依赖A@xxx</td><td rowspan=1 colspan=1>@xxx</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1>B端前端服务发布</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>灰度店铺</td><td rowspan=1 colspan=1>□依赖A@xxx</td><td rowspan=1 colspan=1>@xxx</td><td rowspan=1 colspan=1></td></tr></table>

# 5.2 压测

• 是否需要压测，参考 性能压测⽅案

# 5.3 回滚⽅案

# 应⽤回滚顺序按照应⽤发布顺序逆向回滚

具备回滚能⼒的⽅案是旧代码能够兼容新数据，接⼝升级能够兼容⽼接⼝调⽤⽅式，需要考虑

• 数据库变更是否兼容，不兼容如何处理◦ 兼容

• 回滚代码会不会导致上游服务调⽤失败◦ 不会

# 六、遗留问题&后续规划

<table><tr><td rowspan=1 colspan=1>待确认问题</td><td rowspan=1 colspan=1>问题确认人</td><td rowspan=1 colspan=1>结果</td></tr><tr><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td></tr></table>