darkanakin41/
===

This Docker container provide the simple implementation of [Qafoo/QualityAnalyzer](https://github.com/Qafoo/QualityAnalyzer) in a specific environment.

## Configuration
In order to work, the container need to have access to the folder you want to analyse.

Here is an example of my docker-compose configuration : 
```yaml 
version: '3.7'

services:
  quality:
    image: darkanakin41/ docker-php-quality-analyzer
    volumes:
      - './:/var/www/html'
```

### Usage

The original command of [Qafoo/QualityAnalyzer](https://github.com/Qafoo/QualityAnalyzer), i.e bin/analyze, is available as global function in the container : 
```bash
    quality-analyzer analyze /path/to/source
```

So, if you want more information about this command, you can visit his repository.
