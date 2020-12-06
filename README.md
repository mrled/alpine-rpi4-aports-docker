# alpine-rpi4-aports-docker

A Dockerfile for building Alpine packages for and on a Raspberry Pi 4.

Intended if you have an rpi4 running something other than Alpine,
but want to build Alpine packages, such as a kernel.

## Using it

1. Build the container: `docker build -t alpinebuilder:latest .`

2. Set up a directory on your Docker host for artifacts that you want to keep after you exit:
    `mkdir -p ~/alpinebuilder/{home,distfiles}`

3. If you have an Alpine builder key, make sure it's in `~/alpinebuilder/home/.abuild`.
    If not, we'll make one later.

4. Start the container: `docker run -it alpinebuilder:latest -v ~/alpinebuilder/home:/home/builder -v ~/alpinebuilder/distfiles:/var/cache/distfiles -e USER_NAME='Micah R Ledbetter' -e USER_EMAIL='me@micahrl.com'`

5. If you don't have an Alpine builder key, you'll need to generate one in the container: `abuild-keygen -a -i`

6. If you haven't checked out aports, you'll need to do that in your homedir in the container: `git clone git://git.alpinelinux.org/aports`. You may want to use a branch for your work.

7. Now you can build packages. For instance, to build the kernel with the default settings, run this in the container: `cd ~/aports/main/linux-rpi; abuild -rKd`

Some helpful links:

- https://wiki.alpinelinux.org/wiki/Custom_Kernel
- https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package#Setup_your_system_and_account
