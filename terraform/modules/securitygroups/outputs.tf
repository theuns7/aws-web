output "allow_http_in_sg_id" {
  value = aws_security_group.allow_http_in.id
}

output "allow_all_out_sg_id" {
  value = aws_security_group.allow_all_out.id
}