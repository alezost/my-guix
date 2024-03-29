;; This is an operating system configuration template.

(use-modules (gnu)
             (gnu packages)
             (gnu services)
             (gnu system)
	     (guix monads))
(use-service-modules base networking ssh dbus xorg)

(use-package-modules
	 commencement gnupg guile vim wordnet
	 emacs conkeror ratpoison feh grub gawk perl ncurses fonts 
	 version-control ssh wget video xiph file compression admin linux xorg
	 aspell skribilo)

(operating-system
  (host-name "antelope")
  (timezone "Europe/Paris")
  (locale "en_US.utf8")

  ;; Assuming /dev/sdX is the target hard disk, and "root" is
  ;; the label of the target root file system.
  (bootloader (grub-configuration (device "/dev/vda")))
  (initrd (lambda (file-systems . rest)
            (apply base-initrd file-systems
                   #:extra-modules '("virtio.ko" "virtio_ring.ko"
                                     "virtio_blk.ko" "virtio_pci.ko" "virtio_net.ko")
                   rest)))
  (file-systems (cons (file-system
                        (device "root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (services (cons* 
        (slim-service #:allow-empty-passwords? #f #:auto-login? #f
                      #:startx (xorg-start-command #:drivers '("cirrus" "vesa")
                                                   #:resolutions
                                                     '((1024 768) (640 480))))
        (lsh-service #:port-number 22 #:root-login? #f
                     #:allow-empty-passwords? #f
                     #:initialize? #t)

	           (dbus-service '())
		   (dhcp-client-service)
                   %base-services))

  (packages (cons* alsa-utils
                   aspell
                   aspell-dict-en
                   binutils
                   bzip2
                   conkeror
                   diffutils
                   emacs
                   emms
                   feh
                   ffmpeg
                   file
                   font-dejavu
                   font-terminus
                   gawk
                   ; ?? gcc-toolchain
                   geiser
                   git
                   gnupg
		   grub
                   ; ?? guile
                   gzip
                   isc-dhcp
                   iw
                   magit
                   ; in base... make
                   mplayer
                   ncurses
                   openssh
                   paredit
                   perl
                   ratpoison
                   setxkbmap
                   skribilo
                   sudo
                   tar
                   vim
                   vorbis-tools
                   wget
                   wordnet
                   wpa-supplicant		
                   xinit
                   xkill
                   xorg-server
                   xrandr
                   xset
                   xterm
                   xz
		   %base-packages))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (list (user-account
                (name "paul")
                (comment "Bob's sister")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/paul")))))
