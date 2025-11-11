#!/bin/bash

exec kubectl port-forward svc/web-service -n storegor-ns 8000:8000
