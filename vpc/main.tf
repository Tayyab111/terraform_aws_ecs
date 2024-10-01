resource "aws_vpc" "ecs_vpc" {
  
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  enable_dns_support   = var.vpc.enable_dns_support

  #tags = merge(var.tags , {Name =  var.vpc_config.vpc_name}) 
    tags = merge(var.tags, { Name = "vpc"})
}
data "aws_availability_zones" "available" {
  
}
# public resources
resource "aws_subnet" "public_subnet" {
  count =   length(var.vpc.public_subnet.cidr_block)
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = var.vpc.public_subnet.cidr_block[count.index]
  map_public_ip_on_launch = true 
  #availability_zone = element(var.vpc.public_subnet.availability_zone, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge(var.tags, {Name = "public_subnet"})
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = var.vpc.public_route_table.cidr_block
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = merge(var.tags, {Name = "public_route_table"})
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = merge(var.tags, {Name = "interet_gateway"})
}

resource "aws_route_table_association" "public_association" {
  subnet_id = aws_subnet.public_subnet[0].id 
  route_table_id = aws_route_table.public_route_table.id
  
}
# private resources
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = merge(var.tags, {Name = "eip"})
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.vpc.private_subnet["cidr_block"]) > 0 ? 1 : 0
  allocation_id = aws_eip.elastic_ip.id
  connectivity_type = "public"
  subnet_id = aws_subnet.public_subnet[0].id 
  tags = merge(var.tags, {Name = "nat_gateway"})
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = var.vpc.private_route_table.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id 
  }
  tags = merge(var.tags, {Name = "private_route_table"})
}

resource "aws_route_table_association" "private_association" {
    subnet_id = aws_subnet.private_subnet[0].id 
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_subnet" "private_subnet" {
  count =   length(var.vpc.private_subnet.cidr_block)
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = var.vpc.private_subnet.cidr_block[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge(var.tags, {Name = "private_subnet"})
}