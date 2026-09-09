## CPU
## Memory
### 字扩展
### 位扩展

## Direct Memory Access(DMA)
> 不通过微处理器直接DMAC控制进行内存与IO空间数据高速传输

> HOLD HLDA

|---|中断|DMA|
|---|---|---|
|响应时间|CPU执行完一条指令后|CPU执行完一个总线周期后|
|速度|通过中断服务程序，需保护/恢复现场|1B/(1-2)总线周期
|引起|均可由软硬件引起

> 8237 不要求
* 优先级
    * 固定优先级
    DREQ0>DREQ3
    * 循环方式
    响应后该通道优先级降为最低-> 2 3 0 1
## BUS INTERFACE
> data/address/control
> 数据传输/指令应答
### architecture
#### traditional bus architecture
 - [] chapter15 p9
 - system bus 上只接了主存 高速缓存和扩展总线接口
 - 扩展总线接外部设备

#### High speed bus
 - [] charpter15 p10

 expansion bus - high speed bus(scsi/lan/Graphic/video) -bridge - system bus
### design

* 同步/异步/半同步
* 数据传输
  
  申请 `arbitration` -> 寻址 `addressing` -> 传输数据 `data transferring` -> 结束 `ending`
  
### ISA bus




选择填空全英文
冒泡排序法 20'

AD DA
8251 8254 8255