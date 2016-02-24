# Chef repo boilerplate

A chef repo boilerplate with custom generators

## Get started

1. Copy `config/developer.example.rb` to `config/developer.rb`
2. Edit `config/developer.rb` to match your preferences

    You have to set, at least, your company short name

3. Copy your keys to `config/secrets` with the names `[user].pem` and `[org]-validator.pem`
4. Generate a new encrypted data bag secret

        $ openssl rand -base64 512 | tr -d '\r\n' > config/encrypted_data_bag_secret

5. Download your repo

        $ knife download /
