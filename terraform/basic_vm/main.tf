resource "aws_instance" "myec2" {
    ami = "ami-0ab193018f3e9351b"
    instance_type = "t2.micro"
    tags = {
        Name = "romanh-test"
    }
}
