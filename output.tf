
output "s3_bucket_name" {
  value = aws_s3_bucket.my-s3-bucket.id
}

output "s3_bucket_region" {
    value = aws_s3_bucket.my-s3-bucket.region
}

output "aws_vpc" {
  value = aws_vpc.vpc1.id
}
output "aws_subnet" {
  value = aws_subnet.subnet1.id
}
output "aws_rt" {
  value = aws_route_table.rt.id
}
output "public_ip" {
  value = ["${aws_instance.Vm1.*.public_ip}"]
}
