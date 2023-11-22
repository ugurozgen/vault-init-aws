# vault-init

This is a port of [Kelsey Hightower](https://github.com/kelseyhightower) [vault-init](https://github.com/kelseyhightower/vault-init) to AWS.

The `vault-init` service automates the process of [initializing](https://www.vaultproject.io/docs/commands/operator/init.html) and [unsealing](https://www.vaultproject.io/docs/concepts/seal.html#unsealing) HashiCorp Vault instances running on [Amazon Web Services](http://aws.amazon.com/).

After `vault-init` initializes a Vault server it stores master keys and root tokens, encrypted using [AWS Key Management Service](https://aws.amazon.com/kms/), to a user defined [Amazon S3](https://aws.amazon.com/s3/) bucket.

## Usage

The `vault-init` service is designed to be run alongside a Vault server and communicate over local host.

### Kubernetes

Run `vault-init` in the same Pod as the Vault container. See the [vault statefulset](statefulset.yaml) for a complete example.

## Configuration

The vault-init service supports the following environment variables for configuration:

* `CHECK_INTERVAL` - The time in seconds between Vault health checks. (300)
* `S3_BUCKET_NAME` - The Amazon S3 Bucket where the vault master key and root token is stored.
* `S3_PATH` - The Amazon S3 Bucket folder path where the vault master key and root token is stored. Put `/` end of path
* `KMS_KEY_ID` - The Amazon KMS key ID used to encrypt and decrypt the vault master key and root token.
* `VAULT_ADDR` - The vault API address.

### Example Values

```
CHECK_INTERVAL="300"
S3_BUCKET_NAME="vault-storage"
S3_PATH="staging/"
KMS_KEY_ID="arn:aws:kms:us-east-1:1234567819:key/dead-beef-dead-beef-deadbeefdead"
VAULT_ADDR="https://vault.service.consul:8200"
```

### Docker run 
```
docker run \
    -e CHECK_INTERVAL="10" \
    -e S3_BUCKET_NAME="any-bucket-name" \
    -e KMS_KEY_ID="any-kms-key-id" \
    -e S3_PATH="any-path-ending-with-slash/" \
    -e VAULT_ADDR=http://any-vault-address:8200 \
    -v ~/.aws:/home/newuser/.aws \ # this is mandatory cause it uses your default aws credentials
    ugurozgen/vault-init:0.0.5
```
### AWS
It works with your default aws credentials.