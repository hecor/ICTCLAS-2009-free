######################################
# 
# Generic makefile 
# 
# by George Foot 
# email: george.foot@merton.ox.ac.uk 
# 
# Copyright (c) 1997 George Foot 
# All rights reserved. 
# �������а�Ȩ 
# 
# No warranty, no liability; 
# you use this at your own risk. 
# û���գ������� 
# ��Ҫ����������Լ������� 

# 
# You are free to modify and 
# distribute this without giving 
# credit to the original author. 
# ����������ĺ�ɢ������ļ� 
# ������Ҫ��ԭ����ʲô������ 
# �������˼���� 
# 
######################################

### Customising
# �û��趨
#
# Adjust the following if necessary; EXECUTABLE is the target
# executable's filename, and LIBS is a list of libraries to link in
# (e.g. alleg, stdcx, iostr, etc). You can override these on make's
# command line of course, if you prefer to do it that way.
# 
# �����Ҫ����������Ķ����� EXECUTABLE ��Ŀ��Ŀ�ִ���ļ����� LIBS
# ��һ����Ҫ���ӵĳ�����б������� alleg, stdcx, iostr �ȵȣ�����Ȼ��
# ������ make �������и������ǣ���Ը���û���⡣
# 

EXECUTABLE := ICTCLAS
LIBS := 

# Now alter any implicit rules' variables if you like, e.g.:
#
# �������ı��κ�����Ķ������������еı���������

CFLAGS := -g -O3 -Wall
CXXFLAGS := $(CFLAGS)

# The next bit checks to see whether rm is in your djgpp bin
# directory; if not it uses del instead, but this can cause (harmless)
# `File not found' error messages. If you are not using DOS at all,
# set the variable to something which will unquestioningly remove
# files.
#
# �����ȼ����� djgpp ����Ŀ¼����û�� rm ������û�У�����ʹ��
# del ���������棬���п��ܸ����� 'File not found' ���������Ϣ����û
# ʲô�󰭡�����㲻���� DOS �������趨��һ��ɾ�ļ������ϻ������
# ����ʵ��һ���� UNIX ���ϵͳ���Ƕ���ģ�ֻ�Ƿ��� DOS �û��� UNIX
# �û�����ɾ���⣵�������

ifneq ($(wildcard $(DJDIR)/bin/rm.exe),)
RM-F := rm -f
else
RM-F := rm -f
endif

# You shouldn't need to change anything below this point.
#
# �����￪ʼ����Ӧ�ò���Ҫ�Ķ��κζ����������ǲ�̫���ţ�̫�Σ��ˣ���

SOURCE := $(wildcard *.c) $(wildcard *.cpp)
OBJS := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SOURCE)))
DEPS := $(patsubst %.o,%.d,$(OBJS))
MISSING_DEPS := $(filter-out $(wildcard $(DEPS)),$(DEPS))
MISSING_DEPS_SOURCES := $(wildcard $(patsubst %.d,%.c,$(MISSING_DEPS)) \
$(patsubst %.d,%.cc,$(MISSING_DEPS)))
CPPFLAGS += -MD

.PHONY : everything deps objs clean veryclean rebuild

everything : $(EXECUTABLE)

deps : $(DEPS)

objs : $(OBJS)

clean :
	@$(RM-F) *.o
	@$(RM-F) *.d

veryclean: clean
	@$(RM-F) $(EXECUTABLE)

rebuild: veryclean everything

ifneq ($(MISSING_DEPS),)
$(MISSING_DEPS) :
	@$(RM-F) $(patsubst %.d,%.o,$@)
endif

	-include $(DEPS)

$(EXECUTABLE) : $(OBJS)
	g++ -o $(EXECUTABLE) $(OBJS) $(addprefix -l,$(LIBS))
  