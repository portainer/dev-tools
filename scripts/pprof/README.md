# Scripts

## Generate a pprof graph

### Apply the following patch to `main` function

```diff
+ import "github.com/pkg/profile"

 func main() {
+       defer profile.Start(profile.ProfilePath("/path/to/cpu.pprof")).Stop()
```
See the [documentation](https://pkg.go.dev/github.com/pkg/profile#section-readme)

* Run the portainer server binary (VSCode debug tool is a good option)
* `launch.json` example
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "program": "${workspaceRoot}/api/cmd/portainer",
      "cwd": "${workspaceRoot}",
      "env": {},
      "showLog": true,
      "args": ["--data", "${env:HOME}/portainer-data/portainer", "--assets", "${workspaceRoot}/dist", "--log-level", "DEBUG"]
    },
  ]
}
```
* Use the instance (API calls, use the UI etc)
* To ensure the callgraph is generated when the server is stopped
  * DONT: click the "Stop" button of VSCode
  * DO: open a terminal and kill the server using `pkill -SIGINT __debug_bin`

### Generate a graph from the cpu.pprof file

The following command will open a web interface to explore your pprof file, which allows to see the graph.

```sh
go tool pprof -http :9999 -edgefraction 0 -nodefraction 0 -nodecount 100000 cpu.pprof
```

Notes: `edgefraction`, `nodefraction` and `nodecount` allow to see the entire graph and not the top x% filtered by pprof tool by default