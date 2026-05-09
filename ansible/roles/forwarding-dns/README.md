# Ansible Role: Forwarding DNS (BIND9)

## Description
This role automates the installation and configuration of a Caching/Forwarder DNS Server using BIND9 in a private AWS subnet. It serves as the primary DNS resolver for client internal servers, handles caching for performance optimization, and securely routes queries.

## Features
- **Security:** Listens strictly on the private IP interface and `127.0.0.1`. DNS port 53 is fully protected from the public internet.
- **Access Control:** Queries and recursion are restricted to internal trusted clients (`10.0.0.0/16`).
- **Internal Resolution:** Automatically forwards local queries for `devops.internal` and reverse DNS zones to the primary and secondary master servers.
- **External Resolution:** Forwards all internet-bound DNS requests to external trusted upstream resolvers (`8.8.8.8`, `1.1.1.1`) using `forward only` policy.
- **Validation:** Integrates automated syntax validation via `named-checkconf` before running the service.

## Directory Structure
```text
forwarding-dns/
├── handlers/
│   └── main.yml        # Automatically restarts BIND9 upon config changes
├── tasks/
│   └── main.yml        # Installs packages, deploys templates, and validates syntax
└── templates/
    └── named.conf.options.j2  # BIND9 main configuration template
