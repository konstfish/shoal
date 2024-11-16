talosctl gen config anchovy https://10.0.2.11:6443 --additional-sans <extmaster>

talosctl apply-config --insecure -n <extmaster> --file controlplane.yaml
talosctl apply-config --insecure -n <extworker> --file worker.yaml
talosctl apply-config --insecure -n <extworker> --file worker.yaml
talosctl apply-config --insecure -n <extworker> --file worker.yaml

talosctl bootstrap --nodes <intmaster> --endpoint <extmaster> --talosconfig=./talosconfig
talosctl kubeconfig --nodes <intmaster> --endpoints <extmaster> --talosconfig=./talosconfig