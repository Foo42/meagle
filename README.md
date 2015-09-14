# Meagle

Application to monitor services, and the service instances which make them up.

##Running
Best way to run is through Docker.

###Example docker command to run:
`docker run --name meagle -d -p 4000:4000 -v /etc/meagle:/etc/meagle -e CONFIG_DIR="/etc/meagle" foo42/meagle_manual_build`

Note that meagle loads config from a directory specified in the CONFIG_DIR environment variable. Config is loaded from a file in this directory called `monitoringTargets.json` (this will change in future versions to allow multiple config files for different environments) This file is a json file of the following form:

```
{
	"MyServer": ["https://a.myservice.com/status","https://b.myservice.com/status"]
}

```
The keys of the document are the logical services, with the values being an array of urls to instance status pages
