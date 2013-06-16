######################################
# 
# Generic makefile 
# 
# by George Foot 
# email: george.foot@merton.ox.ac.uk 
# 
# Copyright (c) 1997 George Foot 
# All rights reserved. 
# 保留所有版权 
# 
# No warranty, no liability; 
# you use this at your own risk. 
# 没保险，不负责 
# 你要用这个，你自己担风险 

# 
# You are free to modify and 
# distribute this without giving 
# credit to the original author. 
# 你可以随便更改和散发这个文件 
# 而不需要给原作者什么荣誉。 
# （你好意思？） 
# 
######################################

### Customising
# 用户设定
#
# Adjust the following if necessary; EXECUTABLE is the target
# executable's filename, and LIBS is a list of libraries to link in
# (e.g. alleg, stdcx, iostr, etc). You can override these on make's
# command line of course, if you prefer to do it that way.
# 
# 如果需要，调整下面的东西。 EXECUTABLE 是目标的可执行文件名， LIBS
# 是一个需要连接的程序包列表（例如 alleg, stdcx, iostr 等等）。当然你
# 可以在 make 的命令行覆盖它们，你愿意就没问题。
# 

EXECUTABLE := ICTCLAS
LIBS := 

# Now alter any implicit rules' variables if you like, e.g.:
#
# 现在来改变任何你想改动的隐含规则中的变量，例如

CFLAGS := -g -O3 -Wall
CXXFLAGS := $(CFLAGS)

# The next bit checks to see whether rm is in your djgpp bin
# directory; if not it uses del instead, but this can cause (harmless)
# `File not found' error messages. If you are not using DOS at all,
# set the variable to something which will unquestioningly remove
# files.
#
# 下面先检查你的 djgpp 命令目录下有没有 rm 命令，如果没有，我们使用
# del 命令来代替，但有可能给我们 'File not found' 这个错误信息，这没
# 什么大碍。如果你不是用 DOS ，把它设定成一个删文件而不废话的命令。
# （其实这一步在 UNIX 类的系统上是多余的，只是方便 DOS 用户。 UNIX
# 用户可以删除这５行命令。）

ifneq ($(wildcard $(DJDIR)/bin/rm.exe),)
RM-F := rm -f
else
RM-F := rm -f
endif

# You shouldn't need to change anything below this point.
#
# 从这里开始，你应该不需要改动任何东西。（我是不太相信，太ＮＢ了！）

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
  
