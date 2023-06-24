# Changelog

## 1.0.0 (2023-06-24)


### Features

* Add just scripts to toggle zram/deckswap on/off and resize ([bf850f7](https://github.com/EyeCantCU/bazzite/commit/bf850f75fda20a2bf2b37527659f9d2a0c1e6f95))
* Add RyzenAdj to Deck builds for users who wish to undervolt ([c95b431](https://github.com/EyeCantCU/bazzite/commit/c95b431ae5e2d396c64e9abd2ca05eb6e427ec13))
* Add SELinux rules for hl2_linux (Team Fortress 2) to solve in-game audio issues. ([3f03bed](https://github.com/EyeCantCU/bazzite/commit/3f03beddeaa9c2eb745977eb88f4817e2dec3907))
* Add service for applying TKG CFS tweaks. ([4f7ed95](https://github.com/EyeCantCU/bazzite/commit/4f7ed956532cc80103956e590ba510eda23ab6ff))
* Add sugar-steamOS SDDM theme. Set as default in deck variant. ([cf0869b](https://github.com/EyeCantCU/bazzite/commit/cf0869be28d4895f659cad2060dcb3ac01cc32a0))
* Add systemd service and config file in /etc/default for ryzenadj curve undervolting. ([6d5daa3](https://github.com/EyeCantCU/bazzite/commit/6d5daa32595c799938814305a449f6de0ab6159f))
* Add SystemD targets for AC and Battery power ([b0df542](https://github.com/EyeCantCU/bazzite/commit/b0df542a0b135b7c66829b3581b3b94558e7572b))
* Add Yafti ([d49fb49](https://github.com/EyeCantCU/bazzite/commit/d49fb4906b9ce5e85005ab01e75078ce22f5931e))
* Add yafti configuration and autostart ([48d0de4](https://github.com/EyeCantCU/bazzite/commit/48d0de49c0ba0cfa61c3e30d9da765da85497733))
* Autologin to gamescope-session on deck images ([17f9ab9](https://github.com/EyeCantCU/bazzite/commit/17f9ab9f02131907c0bd2bbab1575a726a7defc6))
* Generate ISOs every release ([547c0da](https://github.com/EyeCantCU/bazzite/commit/547c0da871b446159adf67db1e12f5bc32065d31))
* Install bazzite-arch and export Steam/Lutris via yafti ([304ede2](https://github.com/EyeCantCU/bazzite/commit/304ede290fd85034630de701e1d677403ad2fac0))
* Overhaul images ([eeb93f9](https://github.com/EyeCantCU/bazzite/commit/eeb93f970060086372938e1c324bd44db30c2112))
* Properly handle gamescope session switching ([2adc6e3](https://github.com/EyeCantCU/bazzite/commit/2adc6e39c258e9825abb00a828c551dc0493a843))
* Properly handle OS updates in Steam ([f1823b6](https://github.com/EyeCantCU/bazzite/commit/f1823b6d126ef349e7fe73474520b4aaea33a210))
* Remove Firefox and add shortcut to install the flatpak ([678898c](https://github.com/EyeCantCU/bazzite/commit/678898c64f593898a6bb4c839c7f97a7aa4fbf14))
* Switch to paru on bazzite-desktop ([8225cc4](https://github.com/EyeCantCU/bazzite/commit/8225cc4ca49c0234fb5b969a564bae0212c48a80))
* Tune ZRAM for the Steam Deck. ([1b1bad1](https://github.com/EyeCantCU/bazzite/commit/1b1bad18c0e713df7f7c415870c86075442d89f7))
* Use BFQ (Low Latency) I/O scheduler. ([0cb0c67](https://github.com/EyeCantCU/bazzite/commit/0cb0c67283971b6a09b1fede314c9a34abb84efc))


### Bug Fixes

* add dependabot for updating actions ([4b7cbea](https://github.com/EyeCantCU/bazzite/commit/4b7cbeac8998bf8a8dfac09b044a118f1dbdb428))
* Bring sysctl.conf in sync between deck and desktop variants. ([345cf9a](https://github.com/EyeCantCU/bazzite/commit/345cf9aa9d5b964c8389949db40534878db0a5b9))
* Correct distrobox-upgrade-automatic bug that prevented automatic updates with paru. ([525ec5b](https://github.com/EyeCantCU/bazzite/commit/525ec5b01817fcd2cf4a93b5e7483dd2f65d4c2d))
* Correct exit code for update script. ([43e3c46](https://github.com/EyeCantCU/bazzite/commit/43e3c469f0673a07292bdb0099cf2965613e9642))
* Enable MangoHUD by default ([5727266](https://github.com/EyeCantCU/bazzite/commit/572726689cce48920af2041b6e802354ac97685b))
* Force page-cluster of 0 for ZRAM. ([739fa9b](https://github.com/EyeCantCU/bazzite/commit/739fa9b9bfd85b39bdfd049cf48cbe82ebd717b9))
* Increase maximum size for zram-resize to 4096mb ([52cebae](https://github.com/EyeCantCU/bazzite/commit/52cebae3e8684e58ae73545169bfcb8cd406f614))
* specificy github-actions ([1d2055f](https://github.com/EyeCantCU/bazzite/commit/1d2055f20912478c10495524aba89e05122e49b4))
* Suspend using power button in deck images ([7ab07d4](https://github.com/EyeCantCU/bazzite/commit/7ab07d44852cbe35bcfa28720298f852ddbb5034))
* Use Plasma Discover in yafti ([ec776e6](https://github.com/EyeCantCU/bazzite/commit/ec776e6d904f0c1dea10aef5fe687f955d908b84))
