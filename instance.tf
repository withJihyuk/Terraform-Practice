provider "aws" {
    region = "ap-northeast-2"
    // 버전의 경우 관련 내용이 변경 될 가능성이 낯다고 판단하여 아직 넣지 않았음. 
    // 종속성 고려시 넣어줘야 함.
}

resource "aws_instance" "backend_server" {
    ami = "ami-062cf18d655c0b1e8" // 우분투
    instance_type = "t2.micro" // 추후 바꿔줄 수 있다.
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.test_rule.id]
}