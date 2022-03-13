# ---------------------------------------------------------------
# How to create a self-signed SSL Certificate with Subject 
# Alternative Names(SAN) for local development w/ Chromium 
# ---------------------------------------------------------------

## Step 1: Generate a Private Key

```shell
openssl genrsa -des3 -out myapp.key 2048
```

## Step 2: Generate a CSR (Certificate Signing Request)

```shell
openssl req -new -key myapp.key -out myapp.csr
```

```
Enter pass phrase for myapp.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:
Organizational Unit Name (eg, section) []:
**Common Name (eg, your name or your server's hostname) []:keycloak.derekzoladz.com**
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

## Step 3: Remove Passphrase from Key

```shell
cp myapp.key myapp.key.org && openssl rsa -in myapp.key.org -out myapp.key
```

## Step 4: Create config file for SAN

```shell
touch v3.ext
```

File content
```
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints       = CA:TRUE
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement, keyCertSign
subjectAltName         = DNS:keycloak.derekzoladz.com, DNS:*.derekzoladz.com
issuerAltName          = issuer:copy
```

## Step 5: Generating a Self-Signed Certificate

```shell
openssl x509 -req -in myapp.csr -signkey myapp.key -out myapp.crt -days 3650 -sha256 -extfile v3.ext
```

## Step 6: Get OS X to trust self-signed SSL Certificates 

- Open up Keychain Access.
- Drag your certificate into Keychain Access.
- Go into the Certificates section and locate the certificate you just added
- Double click on it or right-click and select 'get info', enter the trust section.
- Under 'When using this certificate', select **Always Trust**
