cReComp
===============================
creator for Reconfigurable hw Component  
  
**Git**:         https://github.com/kazuyamashi/cReComp.git  
**Author**:      Kazushi Yamashina (Utsunomiya University)  
**Copyright**:   2016, Kazushi Yamashina  
**License**:      new BSD License   
**Latest Version**: 0.5.0  
**Contact**: 	 kazushi_at_virgo.is.utsunomiya-u.ac.jp  

  

What is the cReComp?
===============================
The cReComp is a **automatic design environment for componentization of a single hardware or the multiple hardware**. The component generated by the cReComp is HW/SW co-system that is connected between CPU and FPGA (reconfigurable hw). The cReComp is possible to debug and test single hardware with software in a user development fase. When the development of a each hardware have been finished, the cReComp generates as one of the HW/SW system by integrating the each of the hardware.

Update
=================================
ver 0.50 renew ruby to python  
ver 0.40 Supported automatic assignment to your sub module  
ver 0.35 bug fix  
ver 0.30 Supported DSL. ".scrp" file is format to config for cReComp  
ver 0.20 added error check  
ver 0.10 released first version  

Install
================================

```
git clone https://github.com/kazuyamashi/cReComp.git
```

Contents
=================================

```
cReComp/
|--devel/
|--lib/
|--scrp/
|--cReComp.py
|--README.md
```

- devel/
 - this directry is location of the generated code　by cReComp
- lib/
 - library
- scrp/
 - location of file.scrp
- cReComp.py
 - Main Tool
- README.md

Run & Help
===============================

```
./cReComp [option] [name of scrp file] [sub modulle name(then "-s")]

option list
nothing		: Normal mode. Generate verilog file 
-h			 : show help of cReComp
-s 			: Generate template of setting file(.srcp)
-l 			: Show setting file list in scrp/
```

Tutorial
===============================

Please click following URL
