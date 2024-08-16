# shoal

Personal Infrastructure, naming scheme based on [wikipedia.org/wiki/Shoaling_and_schooling](https://en.wikipedia.org/wiki/Shoaling_and_schooling)

```mermaid
flowchart BT

    subgraph Hetzner Cloud

        subgraph barracuda
            ranch[Rancher]
        end

        subgraph tetra
            ranchatetra[Rancher Agent] --> ranch
        end

    end

    subgraph OnPrem

        subgraph guppy
            rancheaguppy[Rancher Agent] --> ranch
        end

    end

    subgraph Oracle Cloud

        subgraph anchovy
            rancheanchovy[Rancher Agent] ---> ranch
        end

    end

    subgraph Backblaze
    end

    subgraph Cloudflare
    end
```