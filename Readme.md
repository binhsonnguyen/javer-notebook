Dockerized jupyter with buitin java kernel.

```
❯ docker run --name javer --rm -d -p 8888:8888 -v $PWD/Notebooks:/home/jovyan/work binhsonnguyen/javer-notebook:latest
❯ docker logs -f javer
```
