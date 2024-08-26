
all of this needs to be in the operators NS, since the operator only scans in the operator ns known issue: (https://github.com/metallb/metallb-operator/issues/415)

The operator NS also needs to loose all pod-security.kubernetes.io labels, since the speaker pods can't start otherwise.