#!/usr/bin/env python3

import time
import random

from litex import RemoteClient

KiB = 1024
MiB = 1024*KiB

wb = RemoteClient()
wb.open()

test_size  = 32*KiB
burst_size = 255


data = [0, 0 ,0 ,0 ,0 ,0, 0, 0, 0, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0,
        0, 0 ,0 ,0 ,0 ,0, 0, 0, 0, 0]

for i in range(len(data) // 16):
    st = i * 16
    en = st + 16
    wb.write(wb.mems.main_ram.base + (st*4), data[st:en])

d = wb.read(wb.mems.s_hls.base, length=1)
print(f"Status {hex(d[0])}")

print("data")
for i in range(len(data) // 16):
    st = i * 16
    en = st + 16
    d = wb.read(wb.mems.main_ram.base + (st*4), length=16)
    print(d)


wb.write(wb.mems.s_hls.base + 0x10, wb.mems.main_ram.base)
wb.write(wb.mems.s_hls.base + 0x18, wb.mems.main_ram.base + 0x3000)
wb.write(wb.mems.s_hls.base + 0x00, 0x01)

d = wb.read(wb.mems.s_hls.base, length=1)
print(f"Status {hex(d[0])}")

print("data")
for i in range(len(data) // 16):
    st = i * 16
    en = st + 16
    d = wb.read(wb.mems.main_ram.base + (st*4), length=16)
    print(d)
d = wb.read(wb.mems.s_hls.base, length=1)
print(f"Status 2: {hex(d[0])}")

print("res data")
for i in range(len(data) // 16):
    st = i * 16
    en = st + 16
    d = wb.read(wb.mems.main_ram.base + 0x3000 + (st*4), length=16)
    print(d)

wb.close()