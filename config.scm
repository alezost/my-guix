;; This is an operating system configuration template.

(use-modules (gnu))

(operating-system
  (host-name "antelope")
  (timezone "Europe/Paris")
  (locale "en_US.UTF-8")

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
