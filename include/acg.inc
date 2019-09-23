/////////////////////////////////////////////////////
///					Acfun Guard Module Includes						///
///					BuildDate:   Apr,3 2011							///
///			Email&Gtalk&QQ ggystudio@gmail.com				///
/////////////////////////////////////////////////////


// acg_userstatus
// 目的: 获取玩家使用状态
// 参数信息: (1)
// 		Index: 目标玩家实体索引 (id)
// 返回值 (2, byte)
//		1: 玩家使用了 Acfun Guard
//		0: 玩家未使用 Acfun Guard
native acg_userstatus(Index);

// acg_getusermac
// 目的: 获取玩家机器码
// 参数信息: (1)
// 		Index: 目标玩家实体索引 (id)
// 返回值 (1, dword)
//		1: 玩家的机器码
native acg_getusermac(Index);

// acg_getlagtimes
// 目的: 获取玩家 lag 次数
// 参数信息: (1)
// 		Index: 目标玩家实体索引 (id)
// 返回值 (1, byte)
//		1: 玩家 lag 次数
native acg_getlagtimes(Index);

// acg_scanmemory
// 目的: 扫描玩家是否使用了非法模块
// 参数信息: (3)
// 		Operator: 发出指令的管理员实体索引 (id)
// 		Index: 目标玩家实体索引 (id)
//		bDeepScan: 深度扫描 [1= 是, 0= 否]
// 返回值 (Boolean)
//		检测结果通过回调 "acg_scanresult" 或 "acg_operaresult" 反馈
native acg_scanmemory(Operator, Index, bDeepScan);

// acg_capturescreen
// 目的: 截图目标玩家的游戏画面并传至服务器
// 参数信息: (2)
// 		Operator: 发出指令的管理员实体索引 (id)
// 		Index: 目标玩家实体索引 (id)
// 返回值 (Boolean)
//		检测结果通过回调 "acg_operaresult" 反馈
native acg_capturescreen(Operator, Index);

// acg_createnotice
// 目的: 在右上角创建一个 "反恐精英:零点行动" 样式的提示框
// 参数信息: (3)
// 		Index: 目标玩家实体索引 (id)
//		Style: 显示样式
//			-- 1 :[!]绿
//			-- 2 :[×]红
//			-- 4 :[×]蓝
//			-- 8 :[!]黄
//			-- 16:[!]粉红
//			-- 32:[!]橙
//			-- 64:[!]青
//			-- 128:[!]紫
//			-- 256:[!]白
//		szText: 显示内容 (必须为 UTF-8 编码)
// 返回值 (Boolean)
native acg_createnotice(Index, Style, const szText[]);

// acg_closenotice
// 目的: 关闭上述函数创建的提示框
// 参数信息: (1)
// 		Index: 目标玩家实体索引 (id)
// 返回值 (Boolean)
native acg_closenotice(Index);

// acg_querymodule
// 目的: 查看玩家载入内存的模块, 结果通过 acg_getmoduleinfo 反馈
// 参数信息: (3)
// 		Operator: 发出指令的管理员实体索引 (id)
// 		Index: 目标玩家实体索引 (id)
//		bDeepScan: 深度扫描 [1= 是, 0= 否]
// 返回值 (Boolean)
native acg_querymodule(Operator, Index, bDeepScan);

// acg_insertblack
// 目的: 插入一条特征码到黑名单
// 参数信息: (2)
// 		Operator: 发出指令的管理员实体索引 (id)
// 		Checksum: 特征码
// 返回值 (Boolean)
native acg_insertblack(Operator, Checksum);

// acg_setextraammo
// 目的: 设置额外显示弹药的数量
// 参数信息: (2)
// 		Index: 目标玩家实体索引 (id)
//		AmmoCount: 子弹数
// 返回值 (Boolean)
native acg_setextraammo(Index, AmmoCount);

// acg_showextraammo
// 目的: 设置额外显示的弹药的显示状态
// 参数信息: (2)
// 		Index: 目标玩家实体索引 (id)
//		bVisible [1= 显示, 0= 隐藏]
// 返回值 (Boolean)
native acg_showextraammo(Index, bVisible);

// acg_setextraammotext
// 目的: 设置额外显示的弹药旁的说明文字
// 参数信息: (2)
// 		Index: 目标玩家实体索引 (id)
//		szText: 说明文字
// 返回值 (Boolean)
native acg_setextraammotext(Index, const szText[]);

// acg_scanresult
// 仅当发现非法模块时系统触发此回调
// 参数信息: (2)
// 		Index: 被扫描的玩家实体索引 (id)
//		Code:  扫描代码
// 		szCheater: 非法模块名
forward acg_scanresult(Index, Code, const szCheater[]);

// acg_operaresult
// 当管理员向玩家发出指令, 玩家的客服端触发此函数反馈操作结果
// 参数信息: (3)
// 		Operator: 发出指令的管理员实体索引 (id)
// 		Code: 错误代码 [0 表示成功, ≠0 表示失败]
// 		Value: 函数 GetLastError 返回值或其他信息
forward acg_operaresult(Operator, Code, WinErrCode);

// acg_userlogin
// 使用 ACG 的玩家进入游戏时触发此回调
// 参数信息: (3)
// 		Index: 玩家实体索引 (id)
// 		MacCode: 玩家机器码
// 		szClientVer: 客户端 ACG 版本. 如: Feb  6 2011
forward acg_userlogin(Index, MacCode, const szClientVer[]);

// acg_getmoduleinfo
// 返回玩家载入内存的模块信息
// 参数信息: (4)
// 		Index: 玩家实体索引 (id)
// 		Operator: 发出指令的管理员实体索引 (id)
// 		szName: 模块名
// 		Checksum: 模块对应的黑名单特征码
forward acg_getmoduleinfo(Index, Operator, const szName[], Checksum);