# 4096bit 蒙哥马利域模乘算法 

## IDDMM-MMP 4096bit 蒙哥马利域模乘算法说明

### 快速仿真说明

1. 预先安装```iverilog```或```modelsim```仿真器，确保仿真器在系统环境目录内。
1. 执行顶层仿真 ```./sim/mmp_iddmm_sp_tb/run_iverilog.bat``` 或 ```./sim/mmp_iddmm_sp_tb/run_modelsim.bat```。
1. 可在run_iverilog.bat内或do.do内定义宏```_VIEW_WAVEFORM_```用来查看单次波形，否则testbench将会进行随机测试，比较IDDMM-MMP和R2MM算法的一致性。
1. 使用**vivado 2017.4**打开```./vivado-mmp```内的vivado工程，时序情况可在该工程内查看，xdc内默认时钟304MHz。
1. 说明文档在```./output-doc```内。所有源码包括python模型在```./src```内

### 指标速览

1. 4096bit蒙哥马利域模乘算法
1. 纯verilog描述
1. 乘法器使用*实现
1. FPGA综合频率 304 MHz
1. 周期数 2293 cycles
1. 等效逻辑门数147KGate
1. 等效RAM用量 16Kbit
1. 可进行m固定的随机验证
1. 算法返回 x * y * R-1 mod m, R 需要预先计算

### Authors

2020, HDU E-M-T GROUP 

helrori2011 helrori2011@gmail.com 

lihehe muyexinya@163.com

### License

MIT
