CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

PROJECT_NAME = main

PROJECT_SRC  = src
DEVICE_SRC   = Device/
BSP_SRC      = Drivers/BSP/STM32L0xx_Nucleo/
STM_SRC      = Drivers/STM32L0xx_HAL_Driver/Src/
#USB_CORE_SRC = Drivers/STM32_USB_Device_Library/Core/Src


vpath %.c $(PROJECT_SRC)
vpath %.c $(BSP_SRC)
vpath %.c $(DEVICE_SRC)
vpath %.c $(STM_SRC)
#vpath %.c $(USB_CORE_SRC)


SRCS = main.c

SRCS += Device/startup_stm32l053xx.s

#SRCS += stm32f4xx_it.c
SRCS += system_stm32l0xx.c
SRCS += syscalls.c


EXT_SRCS  = stm32l0xx_hal.c
EXT_SRCS += stm32l0xx_hal_rcc.c
EXT_SRCS += stm32l0xx_hal_gpio.c
EXT_SRCS += stm32l0xx_hal_cortex.c
EXT_SRCS += stm32l0xx_hal_pcd.c
EXT_SRCS += stm32l0xx_hal_pcd_ex.c
#EXT_SRCS += stm32l0xx_ll_usb.c
EXT_SRCS += stm32l0xx_hal_uart.c
EXT_SRCS += stm32l0xx_hal_dma.c
EXT_SRCS += stm32l0xx_hal_spi.c
EXT_SRCS += stm32l0xx_hal_adc.c
EXT_SRCS += stm32l0xx_hal_adc_ex.c
EXT_SRCS += stm32l0xx_hal_msp.c


EXT_SRCS += stm32l0xx_nucleo.c


EXT_OBJ = $(EXT_SRCS:.c=.o)

INC_DIRS  = src/
INC_DIRS += Device/
INC_DIRS += Drivers/BSP/STM32L0xx_Nucleo/
INC_DIRS += Drivers/CMSIS/Device/ST/STM32L0xx/Include/
INC_DIRS += Drivers/CMSIS/Include/
INC_DIRS += Drivers/STM32L0xx_HAL_Driver/Inc/
#INC_DIRS += Drivers/STM32_USB_Device_Library/Core/Inc/


INCLUDE = $(addprefix -I,$(INC_DIRS))

DEFS = -DSTM32L053xx

#CFLAGS  = -ggdb -O0
CFLAGS  = -O0
CFLAGS += -mthumb -mcpu=cortex-m0plus -Wl,--gc-sections

WFLAGS += -Wall -Wextra -Warray-bounds -Wno-unused-parameter

LFLAGS = -TSTM32L053C8_FLASH.ld

.PHONY: all
all: $(PROJECT_NAME)

.PHONY: $(PROJECT_NAME)
$(PROJECT_NAME): $(PROJECT_NAME).elf

$(PROJECT_NAME).elf: $(SRCS) $(EXT_OBJ)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(WFLAGS) $(LFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJECT_NAME).elf   $(PROJECT_NAME).hex
	$(OBJCOPY) -O binary $(PROJECT_NAME).elf $(PROJECT_NAME).bin

%.o: %.c
	$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^

clean:
	rm -f *.o $(PROJECT_NAME).elf $(PROJECT_NAME).hex $(PROJECT_NAME).bin
