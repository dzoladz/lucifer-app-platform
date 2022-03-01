## Creating a Certificate Authority to Issue Self-Signed SSL Certificates on macOS
For testing, development, and trusted local deployments, you can use
self-signed certificates. Place the `.crt` and `.key` certificate files in
this `/certs` directory.

You'll need to import the Root CA certificate and mark it as a trusted on each
device. Once the Root CA is trusted, you can issue certificates from it to
secure your devices. Because the Root CA is trusted on the device, browsers
will see any certificates issued from it as trusted (i.e. not self-signed) and
happily show green lock.

## STEP 1: Creating Certificate Authority
* Start Keychain Access
* Select Keychain Access -> Certificate Assistant -> *Create Certificate
Authority*

### Create Your Certificate Authority
* `Name`: Choose a friendly name for your CA
* `Identity type`: select  `Self Signed Root CA`
* `User certificate`: Does not matter, we'll delete it later. `SSL Server` for now.
* `Let me Override Defaults`: **Check**. Very important!
* `Email from`: Select email
* `Make this CA as default`: Up to you.

### Certificate Information
* `Serial Number`: Choose any number you like. i.e. 1.
* `Validity Period (days)`: No longer than 825 days
* `Create a CA web site`: Unchecked.
* `Sign your invitation`: **Uncheck**

Press `Continue`

* `Email address`: Up to you
* `Name (Common Name)`: Select something telling, such as "Derek Zoladz's CA"
* `Organization`, `Unit`, `City`, `State`, `Country`: Optional

### Key Pair Information for This CA
* `Specify Key Pair Information For This CA`: 2048/RSA or longer

Press `Continue`

* `Specify Key Pair Information For Users of This CA`: 2048/RSA or longer

Press `Continue`

### Key Usage Extension For This CA:
* `Include Key Usage Extensions`: Checked
* `This extension is critical`: Unchecked
* `Capabilities`:
    * `Signature`: Checked
    * `Certificate Signing`: Checked

### Key Usage Extension For Users of This CA:
*  `Include Key Usage Extension`: Checked
    * `This Extension is Critical`: Checked
    * Capabilities
        * `Signature`: Checked
        * `Key Encipherment`: Checked

### Extended Key Usage Extension For This CA
* `Include Extended Key Usage Extension`: **Uncheck**.

### Extended Key Usage For Users of This CA
* Same as above, **Uncheck**.

### Basic Constraints Extension For This CA
* `Include Basic Constraints Extension`: Checked
    * `Use this certificate as a certificate authority: Checked
    * `Path Length Constraint Present`: Unchecked

### Basic Constraints Extension For Users fo This CA
* `Include Basic Constraints Extension`: Unchecked

### Subject Alternate Name Extension for This CA
* `Include Subject Alternate Name Extension`: Unchecked, Unless you have good
reason to provide alternate names

### Select Alternate Name for Users of This CA
* `Include Subject Alternate Name Extensions`: Unchecked, unless you have a
good reason otherwise

### Specify a Location for the certificate
You can decide to save your certificate authority to Login or System keychain.
If you select System then before finalizing the certificate creation you would
need to go back to the Keychain Access app, right-click on the System keychain
and **Unlock** it.

* `Keychain`: System
* `Trust certificates signed by this CA on this machine`: **Check**

Now press `Create` and provide your password a bunch of times - to import into
the system keychain and to mark it as trusted.

Now we have the Certificate Authority. We can now issue certificates from it.

## STEP 2: Issue certificates from this authority
* Start Keychain Access
* Select Keychain Access -> Certificate Assistant -> *Create a Certificate*

### Create your certificate
* `Name`: Choose a name for your certificate
* `Identity Type`: change it to **Leaf**
* `Certificate Type`: **SSL Server**
* `Let me override defaults`: **Check**

### Certificate information
* `Select Serial Number`: 1
* `Validity Period`: 825 days or shorter

Press `Continue`

* `Email`: up to you
* `Common name`: up to you

### Choose an Issuer
* `Identity`: **Select** Certificate authority we created in step one. Likely
this will be the only one offered.

### Key Pair Information
Leave at Defaults

### Key Usage Extension
Leave at Defaults

### Extended Key Usage
* `Extension is Critical`: Checked
* `SSL Server Authentication`: Checked

### Basic Constraints
Leave at Defaults

### Subject Alternate Name Extension
* `Include Subject Alternate Name Extension`: Checked
  * `This extension is critical`: Unchecked.
  * Extension Values
    * `rfc822Name`: **Empty**
    * `URI`: Empty
    * `DNSName`: **Specify** space-separated list of hostnames
      * `localtestserver localtestserver.local localtestserver.example.com`
    * `IPAddress`: **127.0.0.1**

### Specify the keychain
Does not matter. Complete the wizard.

## STEP 3: Testing the Certificates in a Local Webserver

### Export keys
Open Keychain, search for a newly created certificate by hostname. You will see
three entries: Certificate, Public key, and Private key.

* Select Certificate and export it to `certificate.cer` file.
* Select Private Key and export it to `certificate.p12` file, with some
pass-phrase.

### Convert to Plain Text

```bash
openssl x509 -inform der -in certificate.cer -out server.crt
openssl pkcs12 -in certificate.p12 -out server.key -nodes
```

You will be prompted for the private key pass-phrase (that you specified during
an export on the previous step).

### Install the certificate
Place the `server.crt` and `server.key` files in this directory. Run the
`infra-up.sh` script to build the application infrastructure. Update the local
`/etc/hosts` file with the hostname of the server (configured in Traefik) and
point it to the IP address of `127.0.0.1`

## OPTIONAL: Distributing Root CA to Clients
Export the CA certificate and distribute it to clients.

### On a macOS
Double-click the certificate to import it into Keychain. Find it there and mark
as Trusted.

### On Windows
[See this post](https://stackoverflow.com/questions/23869177/import-certificate-to-trusted-root-but-not-to-personal-command-line)

### On iOS
AirDrop or mail yourself the certificate. Open it to install it. Then go to
`Settings` -> `General` -> `About` -> `Certificate Trust Settings` and turn
on `Enable trust for that Root CA`
