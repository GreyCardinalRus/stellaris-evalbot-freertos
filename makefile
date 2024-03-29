#/*
#    FreeRTOS V7.1.1 - Copyright (C) 2011 Real Time Engineers Ltd.
#
#    ***************************************************************************
#    *                                                                         *
#    * If you are:                                                             *
#    *                                                                         *
#    *    + New to FreeRTOS,                                                   *
#    *    + Wanting to learn FreeRTOS or multitasking in general quickly       *
#    *    + Looking for basic training,                                        *
#    *    + Wanting to improve your FreeRTOS skills and productivity           *
#    *                                                                         *
#    * then take a look at the FreeRTOS books - available as PDF or paperback  *
#    *                                                                         *
#    *        "Using the FreeRTOS Real Time Kernel - a Practical Guide"        *
#    *                  http://www.FreeRTOS.org/Documentation                  *
#    *                                                                         *
#    * A pdf reference manual is also available.  Both are usually delivered   *
#    * to your inbox within 20 minutes to two hours when purchased between 8am *
#    * and 8pm GMT (although please allow up to 24 hours in case of            *
#    * exceptional circumstances).  Thank you for your support!                *
#    *                                                                         *
#    ***************************************************************************
#
#    This file is part of the FreeRTOS distribution.
#
#    FreeRTOS is free software; you can redistribute it and/or modify it under
#    the terms of the GNU General Public License (version 2) as published by the
#    Free Software Foundation AND MODIFIED BY the FreeRTOS exception.
#    ***NOTE*** The exception to the GPL is included to allow you to distribute
#    a combined work that includes FreeRTOS without being obliged to provide the
#    source code for proprietary components outside of the FreeRTOS kernel.
#    FreeRTOS is distributed in the hope that it will be useful, but WITHOUT
#    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#    more details. You should have received a copy of the GNU General Public 
#    License and the FreeRTOS license exception along with FreeRTOS; if not it 
#    can be viewed here: http://www.freertos.org/a00114.html and also obtained 
#    by writing to Richard Barry, contact details for whom are available on the
#    FreeRTOS WEB site.
#
#    1 tab == 4 spaces!
#
#    http://www.FreeRTOS.org - Documentation, latest information, license and
#    contact details.
#
#    http://www.SafeRTOS.com - A version that is certified for use in safety
#    critical systems.
#
#    http://www.OpenRTOS.com - Commercial support, development, porting,
#    licensing and training services.
#*/


#/************************************************************************* 
# * Please ensure to read http://www.freertos.org/portLM3Sxxxx_Eclipse.html
# * which provides information on configuring and running this demo for the
# * various Luminary Micro EKs.
# *************************************************************************/
SRC_DIR=./src
RTOS_ROOT=../FreeRTOS
RTOS_SOURCE_DIR=$(RTOS_ROOT)/Source
DEMO_COMMON_DIR=$(RTOS_ROOT)/Demo/Common/Minimal
DEMO_INCLUDE_DIR=$(RTOS_ROOT)/Demo/Common/include
UIP_COMMON_DIR=$(RTOS_ROOT)/Demo/Common/ethernet/uIP/uip-1.0/uip
#LUMINARY_DRIVER_DIR=$(RTOS_ROOT)/Common/drivers/Luminary
#LUMINARY_DRIVER_DIR=$(RTOS_ROOT)/Common/drivers/Stellaris
#LUMINARY_DRIVER_DIR=$(RTOS_ROOT)/Common/drivers/LuminaryMicro
LUMINARY_DRIVER_DIR=$(SRC_DIR)/driverlib

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
LDSCRIPT=$(SRC_DIR)/standalone.ld

# should use --gc-sections but the debugger does not seem to be able to cope with the option.
LINKER_FLAGS=-nostartfiles -Xlinker -oRTOSDemo.axf -Xlinker -M -Xlinker -Map=rtosdemo.map -Xlinker --no-gc-sections

DEBUG=-g
OPTIM=-O0


CFLAGS=$(DEBUG) -I $(SRC_DIR) -I $(RTOS_SOURCE_DIR)/include -I $(RTOS_SOURCE_DIR)/portable/GCC/ARM_CM3 \
		-I $(DEMO_INCLUDE_DIR) -D GCC_ARMCM3_LM3S9B92 -D inline= -mthumb -mcpu=cortex-m3 $(OPTIM) -T$(LDSCRIPT) \
		-D PACK_STRUCT_END=__attribute\(\(packed\)\) -D ALIGN_STRUCT_END=__attribute\(\(aligned\(4\)\)\) -D sprintf=usprintf -D snprintf=usnprintf -D printf=uipprintf \
		-I $(UIP_COMMON_DIR) -I $(SRC_DIR)/webserver -ffunction-sections -fdata-sections -I $(LUMINARY_DRIVER_DIR) \
		-I $(SRC_DIR)/evalbot_drivers -I $(SRC_DIR)/ethernet \
		-DTARGET_IS_TEMPEST_RB1

SOURCE=	$(SRC_DIR)/main.c \
		$(SRC_DIR)/timertest.c \
		$(SRC_DIR)/ParTest/ParTest.c \
		$(SRC_DIR)/evalbot_drivers/dac.c \
		$(SRC_DIR)/evalbot_drivers/display96x16x1.c \
		$(SRC_DIR)/evalbot_drivers/io.c \
		$(SRC_DIR)/evalbot_drivers/motor.c \
		$(SRC_DIR)/evalbot_drivers/sensors.c \
		$(SRC_DIR)/evalbot_drivers/sound.c \
		$(SRC_DIR)/evalbot_drivers/wav.c \
		$(LUMINARY_DRIVER_DIR)/ustdlib.c \
		$(DEMO_COMMON_DIR)/BlockQ.c \
		$(DEMO_COMMON_DIR)/blocktim.c \
		$(DEMO_COMMON_DIR)/death.c \
		$(DEMO_COMMON_DIR)/integer.c \
		$(DEMO_COMMON_DIR)/PollQ.c \
		$(DEMO_COMMON_DIR)/semtest.c \
		$(DEMO_COMMON_DIR)/GenQTest.c \
		$(DEMO_COMMON_DIR)/QPeek.c \
		$(DEMO_COMMON_DIR)/recmutex.c \
		$(DEMO_COMMON_DIR)/IntQueue.c \
		$(SRC_DIR)/IntQueueTimer.c \
		$(SRC_DIR)/webserver/uIP_Task.c \
		$(SRC_DIR)/webserver/emac.c \
		$(SRC_DIR)/webserver/httpd.c \
		$(SRC_DIR)/webserver/httpd-cgi.c \
		$(SRC_DIR)/webserver/httpd-fs.c \
		$(SRC_DIR)/webserver/http-strings.c \
		$(UIP_COMMON_DIR)/uip_arp.c \
		$(UIP_COMMON_DIR)/psock.c \
		$(UIP_COMMON_DIR)/timer.c \
		$(UIP_COMMON_DIR)/uip.c \
		$(RTOS_SOURCE_DIR)/list.c \
		$(RTOS_SOURCE_DIR)/queue.c \
		$(RTOS_SOURCE_DIR)/tasks.c \
		$(RTOS_SOURCE_DIR)/portable/GCC/ARM_CM3/port.c \
		$(RTOS_SOURCE_DIR)/portable/MemMang/heap_2.c

LIBS= $(LUMINARY_DRIVER_DIR)/gcc/libdriver.a $(LUMINARY_DRIVER_DIR)/gcc/libgr.a

OBJS = $(SOURCE:.c=.o)

all: RTOSDemo.bin
	 
RTOSDemo.bin : RTOSDemo.axf
	$(OBJCOPY) RTOSDemo.axf -O binary RTOSDemo.bin

RTOSDemo.axf : $(OBJS) $(SRC_DIR)/startup.o makefile
	$(CC) $(CFLAGS) $(OBJS) $(SRC_DIR)/startup.o $(LIBS) $(LINKER_FLAGS)


$(OBJS) : %.o : %.c makefile $(SRC_DIR)/FreeRTOSConfig.h
	$(CC) -c $(CFLAGS) $< -o $@

startup.o : $(SRC_DIR)/startup.c makefile
	$(CC) -c $(CFLAGS) -O1 $(SRC_DIR)/startup.c -o $(SRC_DIR)/startup.o
		
clean :
	touch makefile
	cs-rm -f $(OBJS) $(SRC_DIR)/startup.o $(SRC_DIR)/rtosdemo.map RTOSDemo.axf $(SRC_DIR)/RTOSDemo.bin
	



