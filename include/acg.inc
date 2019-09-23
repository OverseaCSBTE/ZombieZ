/////////////////////////////////////////////////////
///					Acfun Guard Module Includes						///
///					BuildDate:   Apr,3 2011							///
///			Email&Gtalk&QQ ggystudio@gmail.com				///
/////////////////////////////////////////////////////


// acg_userstatus
// Ŀ��: ��ȡ���ʹ��״̬
// ������Ϣ: (1)
// 		Index: Ŀ�����ʵ������ (id)
// ����ֵ (2, byte)
//		1: ���ʹ���� Acfun Guard
//		0: ���δʹ�� Acfun Guard
native acg_userstatus(Index);

// acg_getusermac
// Ŀ��: ��ȡ��һ�����
// ������Ϣ: (1)
// 		Index: Ŀ�����ʵ������ (id)
// ����ֵ (1, dword)
//		1: ��ҵĻ�����
native acg_getusermac(Index);

// acg_getlagtimes
// Ŀ��: ��ȡ��� lag ����
// ������Ϣ: (1)
// 		Index: Ŀ�����ʵ������ (id)
// ����ֵ (1, byte)
//		1: ��� lag ����
native acg_getlagtimes(Index);

// acg_scanmemory
// Ŀ��: ɨ������Ƿ�ʹ���˷Ƿ�ģ��
// ������Ϣ: (3)
// 		Operator: ����ָ��Ĺ���Աʵ������ (id)
// 		Index: Ŀ�����ʵ������ (id)
//		bDeepScan: ���ɨ�� [1= ��, 0= ��]
// ����ֵ (Boolean)
//		�����ͨ���ص� "acg_scanresult" �� "acg_operaresult" ����
native acg_scanmemory(Operator, Index, bDeepScan);

// acg_capturescreen
// Ŀ��: ��ͼĿ����ҵ���Ϸ���沢����������
// ������Ϣ: (2)
// 		Operator: ����ָ��Ĺ���Աʵ������ (id)
// 		Index: Ŀ�����ʵ������ (id)
// ����ֵ (Boolean)
//		�����ͨ���ص� "acg_operaresult" ����
native acg_capturescreen(Operator, Index);

// acg_createnotice
// Ŀ��: �����ϽǴ���һ�� "���־�Ӣ:����ж�" ��ʽ����ʾ��
// ������Ϣ: (3)
// 		Index: Ŀ�����ʵ������ (id)
//		Style: ��ʾ��ʽ
//			-- 1 :[!]��
//			-- 2 :[��]��
//			-- 4 :[��]��
//			-- 8 :[!]��
//			-- 16:[!]�ۺ�
//			-- 32:[!]��
//			-- 64:[!]��
//			-- 128:[!]��
//			-- 256:[!]��
//		szText: ��ʾ���� (����Ϊ UTF-8 ����)
// ����ֵ (Boolean)
native acg_createnotice(Index, Style, const szText[]);

// acg_closenotice
// Ŀ��: �ر�����������������ʾ��
// ������Ϣ: (1)
// 		Index: Ŀ�����ʵ������ (id)
// ����ֵ (Boolean)
native acg_closenotice(Index);

// acg_querymodule
// Ŀ��: �鿴��������ڴ��ģ��, ���ͨ�� acg_getmoduleinfo ����
// ������Ϣ: (3)
// 		Operator: ����ָ��Ĺ���Աʵ������ (id)
// 		Index: Ŀ�����ʵ������ (id)
//		bDeepScan: ���ɨ�� [1= ��, 0= ��]
// ����ֵ (Boolean)
native acg_querymodule(Operator, Index, bDeepScan);

// acg_insertblack
// Ŀ��: ����һ�������뵽������
// ������Ϣ: (2)
// 		Operator: ����ָ��Ĺ���Աʵ������ (id)
// 		Checksum: ������
// ����ֵ (Boolean)
native acg_insertblack(Operator, Checksum);

// acg_setextraammo
// Ŀ��: ���ö�����ʾ��ҩ������
// ������Ϣ: (2)
// 		Index: Ŀ�����ʵ������ (id)
//		AmmoCount: �ӵ���
// ����ֵ (Boolean)
native acg_setextraammo(Index, AmmoCount);

// acg_showextraammo
// Ŀ��: ���ö�����ʾ�ĵ�ҩ����ʾ״̬
// ������Ϣ: (2)
// 		Index: Ŀ�����ʵ������ (id)
//		bVisible [1= ��ʾ, 0= ����]
// ����ֵ (Boolean)
native acg_showextraammo(Index, bVisible);

// acg_setextraammotext
// Ŀ��: ���ö�����ʾ�ĵ�ҩ�Ե�˵������
// ������Ϣ: (2)
// 		Index: Ŀ�����ʵ������ (id)
//		szText: ˵������
// ����ֵ (Boolean)
native acg_setextraammotext(Index, const szText[]);

// acg_scanresult
// �������ַǷ�ģ��ʱϵͳ�����˻ص�
// ������Ϣ: (2)
// 		Index: ��ɨ������ʵ������ (id)
//		Code:  ɨ�����
// 		szCheater: �Ƿ�ģ����
forward acg_scanresult(Index, Code, const szCheater[]);

// acg_operaresult
// ������Ա����ҷ���ָ��, ��ҵĿͷ��˴����˺��������������
// ������Ϣ: (3)
// 		Operator: ����ָ��Ĺ���Աʵ������ (id)
// 		Code: ������� [0 ��ʾ�ɹ�, ��0 ��ʾʧ��]
// 		Value: ���� GetLastError ����ֵ��������Ϣ
forward acg_operaresult(Operator, Code, WinErrCode);

// acg_userlogin
// ʹ�� ACG ����ҽ�����Ϸʱ�����˻ص�
// ������Ϣ: (3)
// 		Index: ���ʵ������ (id)
// 		MacCode: ��һ�����
// 		szClientVer: �ͻ��� ACG �汾. ��: Feb  6 2011
forward acg_userlogin(Index, MacCode, const szClientVer[]);

// acg_getmoduleinfo
// ������������ڴ��ģ����Ϣ
// ������Ϣ: (4)
// 		Index: ���ʵ������ (id)
// 		Operator: ����ָ��Ĺ���Աʵ������ (id)
// 		szName: ģ����
// 		Checksum: ģ���Ӧ�ĺ�����������
forward acg_getmoduleinfo(Index, Operator, const szName[], Checksum);