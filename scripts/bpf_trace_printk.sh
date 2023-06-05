#!/bin/bash
set -euo pipefail

docker exec -it fsm-worker cat /sys/kernel/debug/tracing/trace_pipe | grep bpf_trace_printk
