# Rails Docker builder

The script for building a Rails Docker environment. 

## Prerequisites 

- FreeBSD-based OS, i.e. macOS
- Docker
- Docker Compose 
- Zsh

## Usage

### Build a image

```
$ ./build.sh [<rails_version> [mysql|postgresql [<ruby_version>]]]
```

#### rails\_version

You can choose a rails version from the following url.  
However, version 5.0 or higher is strongly recommended.

[All versions of rails](https://rubygems.org/gems/rails/versions)

#### mysql|postgresql

You can choose between 'mysql' or 'postgresql'.

The latest version of the image will be built. 

see more information

- [MySQL](https://hub.docker.com/_/mysql/)
- [PostgreSQL](https://hub.docker.com/_/postgres)

#### ruby\_version

You can choose a ruby version from the following url.  

[Ruby](https://hub.docker.com/_/ruby)

#### Default execution

The following two commands will run the same operation

```
$ ./build.sh
```

```
$ ./build.sh 5.2.2 mysql 2.5
```

### Remove unused images and cache resources

If you have been creating another Docker environment, do not run it casually!

```
$ ./clean.sh
```

## References

- [Quickstart: Compose and Rails](https://docs.docker.com/compose/rails/)

## License

Rails Docker builder is released under the MIT License, see MIT-LICENSE.txt.
