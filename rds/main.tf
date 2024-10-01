resource "aws_db_subnet_group" "db_subnet_group" {
  #name       = var.rds_cluster.db_subnet_group_name
  name = "rds_subnet_group"
  subnet_ids = var.private_subnet_ids
  #tags = merge(var.tags , {Name = "db_su bubnet"})
}

resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = var.rds_cluster.cluster_identifier
  engine                  = var.rds_cluster.engine 
  engine_version          = var.rds_cluster.engine_version
  availability_zones      = var.rds_cluster.availability_zones
  database_name           = var.rds_cluster.database_name
  master_username         = var.rds_cluster.master_username
  master_password         =  var.rds_password # getting this password form aws_secret_manager
  backup_retention_period = var.rds_cluster.backup_retention_period
  preferred_backup_window = var.rds_cluster.preferred_backup_window
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = var.sg_ids
  skip_final_snapshot = true
  tags = merge(var.tags, {Name = "db_cluster"})
}



resource "aws_rds_cluster_instance" "db_cluster_instances" {
  count = length(var.rds_cluster.cluster_instance.identifier)
  identifier =       var.rds_cluster.cluster_instance.identifier[count.index]
  cluster_identifier   = aws_rds_cluster.db_cluster.id 
  instance_class       = var.rds_cluster.cluster_instance.instance_class
  engine               = aws_rds_cluster.db_cluster.engine
  engine_version       = aws_rds_cluster.db_cluster.engine_version
  publicly_accessible  = var.rds_cluster.cluster_instance.publicly_accessible
  tags = merge(var.tags, {Name = "db_instance"})
  #apply_immediately    = var.db_instance.apply_immediately
  #tags = merge(var.tags, {Name = "wordpress_rds_tag"})
}