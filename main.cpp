#include <iostream>
#include "Utility.h"
#include "Result.h"

//outputFormat和operateType可设不同的值，得到不同的输出格式（0-2)
int main() {
	CResult worker;
	int		outputFormat = 0;
	int		operateType = 2;
	char *in = "我是中国人。";
	char result[1000];
	worker.m_nOperateType = operateType;
	worker.m_nOutputFormat = outputFormat;
	worker.ParagraphProcessing(in, result);
	std::cout<<result<<std::endl;
	return 0;
}
