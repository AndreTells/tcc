# Fixing the list of Repos
Once a list of repos is defined in a .txt file, one can generate the script to
synthesize the file that will fix the repos with their most recent version using
the command:

```sh
nix-build create_repo_list.nix
```

Running the resulting shell script with the list of repos text file as an
argument as below should then yield a `out.nix` file that will contain all
listed repos' with the hash fixed to their latest version: 

```sh 
./result/bin/create-repo_list-0.1 ./input/few_repos.txt
```
(using the provided example repo list .txt)

For the real version, that same command was run against the entire
`./input/repos.txt` file, yielding the final `pinned_repos.nix` file used for
the current study.
