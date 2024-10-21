# Proxmox 설정
# 직접 cloud-init과 템플릿화를 통해 최적화 및 기능 추가, 이슈 트래킹등의 이점을 얻을 수 있을 듯 함. 시간 있을때 한번 해보자.
# 관련 링크: https://tech.kakao.com/posts/570 

# 환경 변수 참고: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
pm_api_url          = "https://192.168.0.64:8006/api2/json/"
pm_api_token_id     = "your-api-token-id"
pm_api_token_secret = "your-api-token-secret"
pm_tls_insecure     = false
pm_host             = "your-proxmox-host"
pm_timeout          = 600

# 네트워크
internal_net_name = "vmbr1"
internal_net_subnet_cidr = "10.0.1.0/24"
ssh_public_keys = "put-base64-encoded-public-keys-here"
ssh_private_key = "put-base64-encoded-private-key-here"

# 바스티온 서버 -> 서버 트래픽 전달 / 방화벽 역할?
bastion_ssh_ip   = "192.168.1.131"
bastion_ssh_user = "ubuntu"
bastion_ssh_port = 22

# VM 사양
vm_max_vcpus = 6

vm_k8s_control_plane = {
  node_count = 1
  vcpus      = 6
  memory     = 3072
  disk_size  = 25
}

vm_k8s_worker = {
  node_count = 3
  vcpus      = 4
  memory     = 4096
  disk_size  = 25
}

# 상세 설정
kube_version               = "v1.29.5"
kube_network_plugin        = "calico"
enable_nodelocaldns        = false
podsecuritypolicy_enabled  = false
persistent_volumes_enabled = false
helm_enabled               = false
ingress_nginx_enabled      = false
argocd_enabled             = false
argocd_version             = "v2.11.4"