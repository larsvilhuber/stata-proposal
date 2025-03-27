# Computing and exporting installation counts for Stata

## Purpose

To run the command `ssccount` in a cloud environment using Stata, in order to export the data to other software. This deposit can both run automated code, or interactively in a Github Codespaces environment. A Stata license is required.

## Directory structure

The basic directory structure is as follows:

- `data/` will contain all data, if part of the repository. How to include large quantities of data (for which Github and similar repositories are not ideal) is not handled here.
- `code/` will contain all (Stata) code. 
- `/home/statauser/ado` contains all installed ado packages. 

## Requirements

You will need 

- [ ] Stata license file `stata.lic`. You will find this in your local Stata install directory.

To run this locally on your computer, you will need

- [ ] [Docker](https://docs.docker.com/get-docker/) 

([Singularity](https://github.com/sylabs/singularity/releases) might also work, but has not been tested)

To run this in the cloud, you will need

- [ ] A Github account, if you want to use the cloud functionality explained here as-is. Other methods do exist.
   - [ ] Your Github account must be enabled for [Github Codespaces](https://github.com/features/codespaces). You may need to ask somebody at your institution. It requires providing billing information. The expected cost for experimenting with this demonstration is a few cents.


## Setup

1. [ ] Configure your Stata license in the cloud (securely) - see below - and possibly locally.
2. [ ] Code runs upon commit

## Details

Consult the [AEADataEditor/stata-project-with-docker](https://github.com/AEADataEditor/stata-project-with-docker) for more details. The default `Dockerfile` works as-is.


### Adjust the setup.do file

The template repository contains a `setup.do` as an example. It should include all commands that are required to be run for "setting up" the project on a brand new system. In particular, it should install all needed Stata packages. For additional sample commands, see [https://github.com/gslab-econ/template/blob/master/config/config_stata.do](https://github.com/gslab-econ/template/blob/master/config/config_stata.do). This can be used both for interactive and non-interactive use. A full reproducible repository will provide both the installed packages, as well as the scripts (here: `setup.do`) used to install those packages.

```
    local ssc_packages "estout"

    // local ssc_packages "estout boottest"
    
    if !missing("`ssc_packages'") {
        foreach pkg in `ssc_packages' {
            dis "Installing `pkg'"
            ssc install `pkg', replace
        }
    }
```
Note that the default configuration will re-install all packages each time the online environment is recreated. Ado files are installed in `/home/statauser/ado`, and re-installed everytime a container is rebuilt. This may not be desired in all cases.

## Cloud functionality

The basic functionality can be tested locally, which we do not detail here. To run this in the cloud, we now need to set up the Github Codespaces environment. This is a one-time setup for each Github "organization,' and does not need to be repeated for every repository.

### Checklist for cloud functionality

- [ ] Ensure that all users who need access have access. This requires users to have "collaborator" access to repositories, i.e., `read` and `write` access. 
- [ ] Configure the online Stata license, securely

### Configuring user access

Users need to have "collaborator" status. This is somewhat ambiguously defined, but turns out to be `read` and `write` access. Go to  `https://github.com/YOURORG/REPONAME/settings/access` to set that access on a per-repository level, or more generally in the `YOURORG` settings.

### Configure the Stata license in the cloud

Your Stata license is valuable, and should not be posted to Github! However, we need it there in order to run the Docker image. Github and other cloud providers have the ability to store "secure" environment variables, that are made available to their systems. Github calls these "[secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)" because, well, they are meant to remain secret. However, secrets are text, not files. So we need a workaround to store our Stata license as a file in the cloud. You will need a Bash shell for the following step. You will need to generate the text, and copy and paste it in the web interface, as described [here](https://docs.github.com/en/actions/security-guides/encrypted-secrets). This could be done from a separate Github Codespaces instance!

> There is potential for some confusion, because (as of January 2022), Github has two types of "secrets": Those for Github Actions, and separately, those for Github Codespaces. You need to set those for Github Codespaces. This can be done at `https://github.com/organizations/YOURORG/settings/secrets/codespaces`. 

To run the image,  the license needs to be available to the Github Codespaces as `STATA_LIC_BASE64` in "base64" format. From a Linux/macOS command line, you can generate it like this:
 
```bash
cat stata.lic | base64
```

where `stata.lic` is your Stata license file. Then create a new organization secret called `STATA_LIC_BASE64`, and paste the information into the prompt. Alternatively, you can use the `gh` CLI:

```bash
gh secret set STATA_LIC_BASE64 --body "$(cat stata.lic | base64)"
```

which will set a repository-level secret (this might override one at the organization level).

![Secret named](assets/codespace-secret-1.png)

> An alternate method involves running the authorization code when building the Docker image. It requires more "secrets" to be set. This is not addressed here.

### Test the Cloud functionality

Assuming you have synced your git repository to Github, you should now be able to launch Codespaces from the Github interface, under the "Code -> Codespaces" button.

![Starting Codespaces](assets/start-codespaces-1.png))

## Other options

If "continuous integration" is not a concern but a cloud-based Stata+Docker setup is of interest, both [CodeOcean](https://codeocean.com) offer such functionality.

## Conclusion



## Comments

For any comments or suggestions, please [create an issue](https://github.com/labordynamicsinstitute/stata-project-with-docker-online/issues/new/choose) 
