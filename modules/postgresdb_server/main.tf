# security group for web and ssh access
resource "aws_security_group" "ssh_web_sg" {
  name        = "ssh_web_sg"
  description = "Allow SSH and web access"
  vpc_id      = var.vpc_id
  tags        = var.my_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ssh_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_web" {
  security_group_id = aws_security_group.ssh_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_eks" {
  security_group_id = aws_security_group.ssh_web_sg.id
  referenced_security_group_id = var.eks_cluster_sg
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.ssh_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# postgres db server
resource "aws_instance" "postgresdb" {
  instance_type               = "t2.micro"
  ami                         = "ami-037774efca2da0726"
  subnet_id                   = var.vpc_subnet
  key_name                    = var.key_name
  iam_instance_profile        = var.instance_profile
  vpc_security_group_ids      = [aws_security_group.ssh_web_sg.id]
  associate_public_ip_address = true
  user_data                   = file("./modules/postgresdb_server/postgres-server-setup.yaml")

  tags = var.my_tags
}

