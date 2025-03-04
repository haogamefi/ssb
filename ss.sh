#!/bin/bash

MAX_JOBS=100   # 控制并行启动的进程数，防止瞬间 CPU 过载
CPU_LIMIT=20   # 限制每个进程最多占用 20% CPU
CORE_COUNT=6  # VPS 实际 CPU 核心数

echo "开始启动 nodes..."

for i in $(seq 1 8000); do

    # 随机分配 CPU 核心（让负载均匀分布在 14 核上）
    CORE_ID=$((i % CORE_COUNT))

    # 启动 P2P 进程，并限制 CPU 占用
    taskset -c $CORE_ID /usr/bin/cpulimit -e antnode -l $CPU_LIMIT -- ./antnode --rewards-address 0x9a4044317175baf04b7cd16bdd3132a6f8fc6601 evm-arbitrum-one &

    # 控制启动速度，防止瞬间 CPU 100%
    if [[ $(jobs | wc -l) -ge $MAX_JOBS ]]; then
        wait -n  # 等待一个进程退出后继续
    fi

    sleep 0.5  # 每秒启动 1 个，降低 CPU 峰值
done

wait  # 确保所有进程启动后主脚本不退出

echo "所有 nodes 启动成功!"
