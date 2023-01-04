#!/bin/bash
set -euo pipefail

docker exec -it osm-worker cat /sys/kernel/debug/tracing/trace_pipe | grep bpf_trace_printk
