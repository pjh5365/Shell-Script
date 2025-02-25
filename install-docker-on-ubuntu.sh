#!/bin/bash

: <<'EOF'
ubuntu 환경에서의 도커 세팅 스크립트

공식 매뉴얼 참조: https://docs.docker.com/engine/install/ubuntu/

지원하는 버전
- Ubuntu Oracular 24.10
- Ubuntu Noble 24.04 (LTS)
- Ubuntu Jammy 22.04 (LTS)
- Ubuntu Focal 20.04 (LTS)
EOF

# Docker apt repository 설정
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 도커 설치 확인
sudo docker run --rm hello-world > /tmp/docker_hello_output.txt 2>&1

if grep -q "Hello from Docker!" /tmp/docker_hello_output.txt; then
	echo ""
	echo ""
	echo "======================================================================================================"
  echo "✅ 도커 설치 성공!"
  echo ""
  echo "💡 sudo 명령없이 도커를 사용하려면 세션을 새로고침해주세요."
  # docker 권한 설정 (현재 사용자에게 docker 권한 부여)
	sudo groupadd docker 2>/dev/null
	sudo usermod -aG docker $USER
else
	echo ""
	echo ""
	echo "======================================================================================================"
    echo "❌ 도커 설치에 실패하였습니다. 에러 로그:"
    cat /tmp/docker_hello_output.txt
fi
echo "======================================================================================================"
echo ""
echo ""
rm /tmp/docker_hello_output.txt
