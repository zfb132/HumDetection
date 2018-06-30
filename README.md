<center>语音哼唱识别及评分系统</center>
------
## 1. 功能
* 识别：对用户输入的一段语音识别得到其频率，经处理后在界面输出旋律，并可以用钢琴来弹奏此旋律
* 评分：预先设置旋律和节拍，提取处理用户输入的语音文件与设置的旋律及节拍进行对比，根据评分规则输出实际得分
## 2. 运行环境
Matlab R2017a、 Windows 10 Professional 1803
## 3. 使用步骤
### 3.1 哼唱识别系统
1. 打开Matlab软件，切换工作目录到`HumDetection`文件夹下
2. 双击打开文件`HumDetection.m`，在菜单栏中选择`编辑器`，点击`运行`按钮即可正常运行代码（第一次运行时间可能较长，请耐心等待）
3. 界面加载完毕后，点击`选择文件`按钮，在弹出的窗口中选择`standard1-7.wav`文件，软件会将自动提取到的旋律显示在`识别结果`编辑框里并绘制该语音的时域波形和基频曲线（运行时间可能较长，请耐心等待）
4. 点击时域波形图后面的`扬声器标志`按钮，你将会听到该语音（**请等待图形的红色指示条移动到最右端再进行其他操作，以下所有播放声音时均要满足此条件**）
5. 点击`钢琴演奏`按钮，等待系统生成对应的旋律以及基频提取并自动显示在界面上；你可以通过点击此图形后面的扬声器按钮来播放钢琴演奏的声音
### 3.2 哼唱评分系统
1. 在上一个实验5的基础上点击`切换评分`按钮（或者打开程序界面后直接点击此按钮）转到评分界面
2. 首先在`输入旋律`编辑框中输入要指定的旋律 `1 2 3 4`（注意**空格为分隔符**），节奏`1`；点击`选择文件`按钮打开文件`test1234.wav`，等待系统自动显示其时域波形和基频提取；点击右侧扬声器按钮你将听到该语音
3. 点击`评分对比`按钮，等待系统自动生成理想的钢琴演奏出的旋律以及基频提取显示在图中，且会自动根据内置评分规则弹出提示框显示得分。另外，你可以点击右侧扬声器播放理想钢琴声音
4. 测试第二个样本，将步骤二中的关键数据改为下面所示，执行步骤2和步骤3  
    * 旋律&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`1 1 5 5 6 6 5 4 4 3 3 2 2 1 1 1 5 5 6 6 5 4 4 3 3 2 2 1`
    * 节奏&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`11/14`
    * 文件名&nbsp;`LittleStar.wav`  
5. 测试第三个样本，对应数据更改为：
    * 旋律&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`5 1 5 1`
    * 节奏&nbsp;&nbsp;&nbsp;&nbsp; `1`
    * 文件名&nbsp;`test5151.wav`
### 4. 其他说明
* 代码整体运行可能较慢，请耐心等待
* 运行遇到问题可直接在群里私戳我