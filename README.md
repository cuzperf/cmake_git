# cmake 获取 git 版本信息

我们要求仅对带有 tag 的 commit 进行发版，这样做可以平滑的从 svn 切到 git。

现在要对最新的 commit 发版，此时用 git 打个 tag，再编译，把编译好的库和二进制一起打包发布

> tag 可以是纯数字，这样就跟 svn 一致了

在本例中 LATEST_GIT_TAG 在构建时有四种情况

1. 本地无修改，HEAD 就是 tag（用于发版）
2. 本地有修改，HEAD 就是 tag（用于发版后的开发）：
3. 本地无修改，HEAD 不是 tag（内部打包）
4. 本地有修改，HEAD 不是 tag（内部调试开发）

- 如果有修改，LATEST_GIT_TAG 会带 dirty 字样
- 如果 HEAD 不是 tag，LATEST_GIT_TAG 会带 HEAD 的 hash 值
