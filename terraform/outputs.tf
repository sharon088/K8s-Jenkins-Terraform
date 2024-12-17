output "k8s_master_instance_ip" {
  description = "The public IP of the Kubernetes master instance"
  value       = aws_instance.k8s_master.public_ip
}

output "k8s_worker_instance_ips" {
  description = "The public IPs of the Kubernetes worker instances"
  value       = [for instance in aws_instance.k8s_worker : instance.public_ip]
}

output "jenkins_controller_instance_ip" {
  description = "The public IP of the Jenkins controller instance"
  value       = aws_instance.jenkins_controller.public_ip
}

output "jenkins_agent_instance_ips" {
  description = "The public IPs of the Jenkins agent instances"
  value       = [for instance in aws_instance.jenkins_agent : instance.public_ip]
}

output "gitlab_instance_ip" {
  description = "The public IP of the GitLab instance"
  value       = aws_instance.gitlab.public_ip
}