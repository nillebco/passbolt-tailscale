# passbolt server in a tailscale network

the purpose of this repository is to show how to deploy a passbolt server in a tailscale network

in order to privision this server you shall setup a few variables
in the .env.sample and the *.sample.tfvars files

then you should be able to

- provision the infrastructure using `./cli tf apply`
- destroy it using `./cli apply -destroy`
- connect to the server using `./cli ssh -h safe`

ideally you get an empty port scan on your host

```bash
❯ nmap safe.example.com
Starting Nmap 7.97 ( https://nmap.org ) at 2025-07-06 12:12 +0200
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
Nmap done: 1 IP address (0 hosts up) scanned in 8.04 seconds
```

## why this is cool

- your vault is accessible using only tailscale, no other network exposition
- we use podman rootless

## requirements

- a sendgrid api key
- a cloudflare api key
- a hetzner api key
-- a tailscale api key

## limitations

- the loadbalancer is useless - every node has its own database - set instances to 1
- there is no backup set up; I'd like to add a periodical export of the podman volumes and certificates
