# alpine-rpi4-aports-docker

A Docker image for building Alpine packages for and on a Raspberry Pi 4.

Intended if you have an rpi4 running something other than Alpine,
but want to build Alpine packages, such as a kernel.

## Using it

1. Build the container:

        docker build -t alpinebuilder:latest --build-arg HOST_UID=$(id -u) .

    - Note the `HOST_UID` must be set to your host user's UID for permissions to work properly.
        We use the `id` command to inject it automatically.)

2. Set up a directory on your Docker host for artifacts that you want to keep after you exit:

        mkdir -p ~/alpinebuilder/{home,distfiles}

3. If you have an Alpine builder key, make sure it's in `~/alpinebuilder/home/.abuild`.
    If not, we'll make one later.

4. Start the container:

        docker run -it \
            -v ~/alpinebuilder/home:/home/builder \
            -v ~/alpinebuilder/distfiles:/var/cache/distfiles \
            -e USER_NAME='Micah R Ledbetter' \
            -e USER_EMAIL='me@micahrl.com' \
            -e TIMEZONE=US/Central \
            alpinebuilder:latest

5. You need to configure an Alpine builder key

    - If you don't have an Alpine builder key, you'll need to generate one in the container, and copy the public key so that abuild knows how to find it:

            abuild-keygen -a -i
            sudo cp ~/.abuild/me@micahrl.com-5fc94d02.rsa.pub /etc/apk/keys

        Note that once there is a key present in ~/.abuild, the entrypoint script will automatically copy it when the container starts, so you don't have to do the second command every time the container starts.

    - If you DO have an Alpine builder key, put it in `~/alpinebuilder/home/.abuild`, and _make sure_ the absolute path is specified in `~/alpinebuilder/home/.abuild/abuild.conf` to refer to `/home/builder/.abuild`, because that is the build user in the container.
        e.g. have this line in `abuild.conf`

            PACKAGER_PRIVKEY="/home/builder/.abuild/me@micahrl.com-5fc94d02.rsa"

6. If you haven't checked out aports, you'll need to do that in your homedir in the container: `git clone git://git.alpinelinux.org/aports`. You may want to use a branch for your work.

7. Now you can build packages. For instance, to build the kernel with the default settings, run this in the container: `cd ~/aports/main/linux-rpi; abuild -rKd`.

    - I like to log the results, so I added a simple `logcmd.sh` to the container. You can run it like `logcmd.sh LOGNAME abuild -rKd` and it will save the full log to a file like `~/logs/20201205-211333-LOGNAME.log`, as well as emit all messages to STDOUT.

    - You can use passwordless `sudo` to install packages if you need to.

## Further reading

Some helpful links:

- <https://wiki.alpinelinux.org/wiki/Custom_Kernel>
- <https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package#Setup_your_system_and_account>

### Notes and examples

- [Building a kernel](docs/build-kernel.md)
- [Reusing a Raspbian sdcard for Alpine](docs/reuse-raspbian-sdcard.md)

## Troubleshooting

### Why is root's prompt different?

Root uses `ash`, while the main user in the container uses `bash`. This will lead to some differences, such as `\t` being interpreted in `bash` as a time in HH:MM:SS format, but in `ash` as a time in just HH:MM format.
