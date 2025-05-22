# iStore OS 固件 | 定制的麻烦自行 fork 修改

## 默认配置

- IP: `http://10.0.0.1` or `http://immortalwrt.lan`
- 用户名: `root`
- 密码: ``
- 如果设备只有一个网口，则此网口就是 `LAN` , 如果大于一个网口, 默认第一个网口是 `WAN` 口, 其它都是 `LAN`
- 如果要修改 `LAN` 口 `IP` , 首页有个内网设置，或者用命令 `quickstart` 修改
- 北京时间每天 `0:00` 定时编译, `Release` 中只保留不同架构的最新版本
- 历史版本在 `Actions` 中选择一个已经运行完成且成功的 `workflow` 在页面底部可以看到 `Artifacts`, `Artifacts` 需要登录 Github 才能下载
- 请把要加入的插件配置项填写在仓库 “configfiles/config_data.txt” 文件里面，假如你直接填写到 “rk35xx/.config” 文件里面绝对会丢你新加的配置项，因为每天会定时执行同步文件工作流会自动更新.config为istoreos官方最新的配置文件。
- 自行定制时需要注意这几点：假如你禁用了 “Sync Files” 工作流的话，那插件配置项就要填写到 “rk35xx/.config” 文件里面才行，反之你没禁用 “Sync Files” 工作流的话，那插件配置项就要填写到 “configfiles/config_data.txt” 文件里面才行。
- 使用此仓库必须设置机密token，Actions云编译固件时需要用到，其他人无法看到的（通常在仓库设置里面，严禁在仓库可视代码中填写，否则后果自负），机密键名为 `ACCESS_TOKEN`

## 支持架构
### RK35xx 架构

| 设备           | 包名称                                                                   |
| -------------- | ------------------------------------------------------------------------ |


## 鸣谢

- [istoreos](https://github.com/istoreos/istoreos)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean&#39;s OpenWrt](https://github.com/coolsnowwolf/lede)
- [tmate](https://github.com/tmate-io/tmate)
- [mxschmitt/action-tmate](https://github.com/mxschmitt/action-tmate)
- [csexton/debugger-action](https://github.com/csexton/debugger-action)
- [Cowtransfer](https://cowtransfer.com)
- [WeTransfer](https://wetransfer.com/)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [ActionsRML/delete-workflow-runs](https://github.com/ActionsRML/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)
- [draco-china/istoreos-actions](https://github.com/draco-china/istoreos-actions)

