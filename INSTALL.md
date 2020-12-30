# Install arch

#### Check uefi

```
ls /sys/firmware/efi/efivars
```

#### For partitions

```
fdisk -l
fidsk /dev/sda
```

Check disklabel type: dos = mbr, gpt = gpt
Use Efi( fat 12..) for mbr and Efi system for gpt
Linux for root partition, Linux swap for swap
End section can be specified with size: e.g +10G, +512M

##### Format

```
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
```

#### Wifi

```
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect Mihi
```

#### Mount

```
mount /dev/sda1 /efi
swapon /dev/sda2
mount /dev/sda3 /mnt
```

#### Install

```
pacstrap /mnt base linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt


timedatectl set-timezone Europe/Zagreb
vim /etc/locale.gen
locale-gen
echo LANG=en_GB.UTF-8 > /etc/locale.conf
export LANG=en_GB.UTF-8

echo arch > /etc/hostname
vim /etc/hosts
"
127.0.0.1	localhost
::1		localhost
127.0.1.1	myarch
"
passwd

```

#### Bootloader

```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/efi
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Add user

```
pacman -S sudo zsh networkmanager git base-devel dhcpd dhclient iwd
visudo # uncomment %wheel ALL=(ALL) ALL
useradd -m -G wheel -s /bin/zsh mkucijan
passwd mkucijan
su mkucijan
cd /tmp && git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### Reboot

```
exit
umount /mnt
umount /efi
reboot
```

#### Clone this repo

```
sudo pacman -S git
git clone https://github.com/mkucijan/dotfiles.git
```

#### Install deps

```
sudo pacman -S --needed - < dotfiles/pkgs/pacman.list
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install $(cat dotfiles/pkgs/cargo.list)
yay -S - < dotfiles/pkgs/aur.list
```
