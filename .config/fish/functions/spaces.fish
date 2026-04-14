function spaces
    kubectl --context $argv get ns -o 'custom-columns=name:.metadata.name,account_name:.metadata.labels.internal\.spaces\.upbound\.io/account-name,cp_name:.metadata.labels.internal\.spaces\.upbound\.io/controlplane-name' --sort-by '.metadata.labels.internal\.spaces\.upbound\.io/account-name'
end


