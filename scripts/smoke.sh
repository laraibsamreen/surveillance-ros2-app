#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}===============================================${NC}"
echo -e "${YELLOW}       SURVEILLANCE APP SMOKE TEST RUNNER      ${NC}"
echo -e "${YELLOW}===============================================${NC}"

# 1. Port Verification
check_port() {
    local port=$1
    local name=$2
    if nc -z localhost "$port" 2>/dev/null || (echo > /dev/tcp/localhost/"$port") 2>/dev/null; then
        echo -e "[PORT] $name on :$port -> ${GREEN}ONLINE${NC}"
    else
        echo -e "[PORT] $name on :$port -> ${RED}OFFLINE${NC}"
    fi
}

echo -e "\n--- Step 1: Checking Microservice Ports ---"
check_port 9090 "rosbridge_server (WebSocket)"
check_port 8000 "FastAPI Analytics Backend"
check_port 5050 "FastAPI AI Commander"
check_port 5432 "PostgreSQL Database"

# 2. HTTP Endpoint Verification
echo -e "\n--- Step 2: Querying REST APIs ---"
if curl -s http://localhost:8000/docs >/dev/null; then
    echo -e "[HTTP] FastAPI Analytics Swagger Docs (:8000/docs) -> ${GREEN}200 OK${NC}"
else
    echo -e "[HTTP] FastAPI Analytics Swagger Docs (:8000/docs) -> ${RED}UNREACHABLE${NC}"
fi

if curl -s http://localhost:5050/docs >/dev/null; then
    echo -e "[HTTP] FastAPI AI Commander Swagger Docs (:5050/docs) -> ${GREEN}200 OK${NC}"
else
    echo -e "[HTTP] FastAPI AI Commander Swagger Docs (:5050/docs) -> ${RED}UNREACHABLE${NC}"
fi

# 3. ROS 2 Topics Verification
echo -e "\n--- Step 3: Checking Active ROS 2 Topics ---"
if command -v ros2 &> /dev/null; then
    ACTIVE_TOPICS=$(ros2 topic list 2>/dev/null || true)
    
    check_topic() {
        local topic=$1
        if echo "$ACTIVE_TOPICS" | grep -q "$topic"; then
            echo -e "[ROS2] Topic $topic -> ${GREEN}ACTIVE${NC}"
        else
            echo -e "[ROS2] Topic $topic -> ${YELLOW}NOT FOUND${NC}"
        fi
    }
    
    check_topic "/surveillance_camera/image_raw"
    check_topic "/surveillance_camera/image_raw/compressed"
    check_topic "/yolo/annotated/compressed"
    check_topic "/person_activity"
    check_topic "/map"
    check_topic "/amcl_pose"
    check_topic "/goal_pose"
    check_topic "/cmd_vel"
else
    echo -e "${YELLOW}ROS 2 environment not sourced in this subshell. Skipping live topic queries.${NC}"
fi

echo -e "\n==============================================="
echo -e "Smoke Test Complete."