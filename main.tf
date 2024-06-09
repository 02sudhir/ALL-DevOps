#create s3 bucket

resource "aws_s3_bucket" "mybuckets" {
  bucket = var.bucketname


}

resource "aws_s3_bucket_ownership_controls" "mybuckets" {
  bucket = aws_s3_bucket.mybuckets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



resource "aws_s3_bucket_public_access_block" "mybuckets" {
  bucket = aws_s3_bucket.mybuckets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "mybuckets" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mybuckets,
    aws_s3_bucket_public_access_block.mybuckets,
  ]

  bucket = aws_s3_bucket.mybuckets.id
  acl    = "public-read"
}






resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.mybuckets.id
     key    = "index.html"
     source = "index.html"
     acl = "public-read"
     content_type = "text/html"


}

resource "aws_s3_object" "error" {
    bucket = aws_s3_bucket.mybuckets.id
     key    = "error.html"
     source = "error.html"
     acl = "public-read"
     content_type = "text/html"


}

resource "aws_s3_object" "thor" {
   bucket = aws_s3_bucket.mybuckets.id
   key = "thor.png"
   source =  "thor.png"
   acl = "public-read"
  
}




resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybuckets.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

 depends_on = [ aws_s3_bucket_acl.mybuckets ]
}
