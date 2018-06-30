function varargout = HumDetection(varargin)
% HUMDETECTION MATLAB code for HumDetection.fig
%      HUMDETECTION, by itself, creates a new HUMDETECTION or raises the existing
%      singleton*.
%
%      H = HUMDETECTION returns the handle to a new HUMDETECTION or the handle to
%      the existing singleton*.
%
%      HUMDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HUMDETECTION.M with the given input arguments.
%
%      HUMDETECTION('Property','Value',...) creates a new HUMDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HumDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HumDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HumDetection

% Last Modified by GUIDE v2.5 23-Jun-2018 10:52:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HumDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @HumDetection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HumDetection is made visible.
function HumDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HumDetection (see VARARGIN)

% Choose default command line output for HumDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% 清除可能其他项目的全局变量
clear global;
% GUI界面居中
movegui( gcf, 'center' );

% 为button添加背景图片
im=imread('sound.png');
set(handles.pushbutton_play1,'CData',im);
set(handles.pushbutton_play2,'CData',im);


% 0表示哼唱系统；1表示评分系统
global flag;
flag=0;
% 默认不显示这两个
set(handles.text_4score,'Visible','off');
set(handles.edit_4score,'Visible','off');
% 默认禁用edit_result，只作为输出
set(handles.edit_result,'Enable','inactive');
% 禁止显示警告，展示时用
warning off;

% UIWAIT makes HumDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HumDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_file.
function pushbutton_file_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global singley;global T;global order;global speed;global singleyr;global flag;
try
    %清空上次残留图像
%     if flag
%         set(handles.edit_result,'String','');
%     end
    cla(handles.axes1,'reset'); 
    cla(handles.axes2,'reset');
    cla(handles.axes3,'reset'); 
    cla(handles.axes4,'reset');
    %读取文件
    [filename,path]=uigetfile({'*.wav;*.mp3;*.ogg;*.flac;*.au;',  ...
        '音频文件(*.wav,*.mp3,*.ogg,*.flac,*.au)';},'打开文件') ;
    set(handles.edit_filename,'String',filename);
    [y,Fs] = audioread(strcat(path,filename));
    singley = y(:,1);
    % 重采样至8KHz
    fs=8000;
    % 预加重滤波
    singley=filter([1 -0.68],1,singley);
    singley=resample(singley,fs,Fs);
    info = audioinfo(strcat(path,filename));
    T = info.Duration;
    % 显示时域波形
    timeplot(singley,T,handles.axes1);
    [singleyr,order,speed]=create_audio_data(singley,Fs,T,handles.axes3);
    axes(handles.axes3);
    %timeplot(singleyr,T,handles.axes3);
    title('基音频率');xlabel('时间t/s');ylabel('频率f/Hz');xlim([0 T]);
    if ~flag
        set(handles.edit_result,'String',num2str(order));
    end
catch ErrorInfo
    disp(ErrorInfo)
end


function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_play1.
function pushbutton_play1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global singley;global T;global flag;
ts=timerfind;
if ~isempty(ts)
    stop(ts);
    delete(ts);
end
if(isempty(singley))
    msgbox('请先选择文件！','警告','warn');
    return;
end
if flag
    period=0.0112;
    amp=0.1;
else
    period=0.0112;
    amp=0.04;
end
t=timer('Name','HH','StartDelay',0,'TimerFcn',{@t_TimerFcn,handles.axes1,amp,0.02},...
    'Period',period,'ExecutionMode', 'fixedSpacing','TasksToExecute',floor(T/0.02));  
global tcnt;
tcnt=0;
start(t);
soundsc(singley,8000);

function t_TimerFcn(hObject,eventdata,object,a,num)
    global tcnt;
    tcnt=tcnt+num;
    if(tcnt~=num)
        h=get(object, 'children');
        delete(h(1));
    end
    line(object,[tcnt,tcnt],[-a,a],'color','r');


% --- Executes on button press in pushbutton_play2.
function pushbutton_play2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Y;global T2;
if(isempty(T2))
    msgbox('请先点击钢琴演奏按钮！','警告','warn');
    return;
end
ts=timerfind;
if ~isempty(ts)
    stop(ts);
    delete(ts);
end
t=timer('Name','HH','StartDelay',0,'TimerFcn',{@t_TimerFcn,handles.axes2,0.4,0.02},...
    'Period',0.0095,'ExecutionMode', 'fixedSpacing','TasksToExecute',floor(T2/0.02));  
global tcnt;
tcnt=0;
start(t);
soundsc(Y);



%% 自定义函数部分
% 在指定坐标axes上显示时域波形
function timeplot(x,T,hObject)
    axes(hObject);
    plot(linspace(0,T,length(x)),x);
    xlim([0 T]);
    title('语音信号时域波形');
    xlabel('时间/S');
    ylabel('信号幅度'); 
    
% 自定义分帧函数
function [segnum,segment]=frame(x,seglen,noverlap)
    % 向上取整
    segnum=ceil(length(x)/noverlap);
    % 不足一帧的补零
    x=[x',zeros(1,segnum*noverlap-length(x))]';
    % 因为seglen>noverlap，故i*noverlap+seglen要用segnum-1个段，否则超出索引
    segnum=segnum-1;
    % 输入x分段后用数组来保存，一列seglen个数据对应一个段，共segnum列
    segment=zeros([seglen,segnum]);
    for i=0:segnum-1
        segment(:,i+1)=x(i*noverlap+1:i*noverlap+seglen);
    end



function edit_result_Callback(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_result as text
%        str2double(get(hObject,'String')) returns contents of edit_result as a double


% --- Executes during object creation, after setting all properties.
function edit_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_piano.
function pushbutton_piano_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_piano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global order;global speed;global Y;global T2;global flag;global singleyr;
% if(isempty(Y))
%     msgbox('请先选择文件！','警告','warn');
%     return;
% end
if flag
    % 默认节拍为1
    ratio=get(handles.edit_4score,'String');
    ratio=str2num(ratio);
    str=get(handles.edit_result,'String');
    % 字符串预处理
    str=strtrim(str);
    str=regexp(str, '\s+', 'split');
    % 标准音的个数
    len=length(str);
    num=zeros(1,len);
    for i=1:len
        num(i)=str2num(str{i});
    end
    [Y,T2]=createpiano(num,ratio);
    % 显示时域波形
    timeplot(Y',T2,handles.axes2);
    %[yr,order,speed]=create_audio_data(Y,8000);
    cepstrum(Y',256,8000,handles.axes4);
    n=fix(length(singleyr)/ratio/8000);
   if(n<len)
       singleyr(length(singleyr):(n+1)*ratio*8000)=zeros((n+1)*ratio*8000-length(singleyr));
   end
    res=zeros(1,len);
    for i=0:n-1
       res(i+1)=mean(singleyr(i*ratio*8000+1:(i+1)*ratio*8000));
    end
    f4=[261.63 293.66 329.63 349.23 392.0 440.0 493.88];
    sum=0;
    for i=1:len
        sum=sum+abs(res(i)-f4(num(i)))/len/f4(num(i));
    end
    sum=100-100*sum;
    msgbox(num2str(sum),'总分','warn');
else
    [Y,T2]=createpiano(order,speed);
    % 显示时域波形
    timeplot(Y',T2,handles.axes2);
    %[yr,order,speed]=create_audio_data(Y,8000);
    cepstrum(Y',256,8000,handles.axes4);
end



function pitch=cepstrum(y,seglen,fs,hobject)
[segnum,segment]=frame(y,seglen,floor(seglen/2)); 
lowfre=floor(fs/500);
highfre=floor(fs/70);
n=linspace(1,seglen/2,seglen/2);
pitch=zeros(segnum,1);
for m=1:segnum
    column=segment(:,m);
    %----绘制倒谱计算的基音轨迹
    cep=rceps(column);
    cep=cep(1:seglen/2);
    index=findMaxIndex(cep(lowfre:highfre),n(lowfre:highfre),25,0.11);
    if(~isempty(index))
        pitch(m)=fs/index;
    end
end
axes(hobject);
stem(pitch);
xlim([0 segnum]);
title('倒谱法基音追踪');
xlabel('帧数');
ylabel('频率f/Hz');

function index=findMaxIndex(x,n,mpd,mph)
    [psor,lsor] = findpeaks(x,n,'MinPeakDistance',mpd,'MinPeakHeight',mph);
    [~,index]=max(psor);
    index=lsor(index);
    


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
global flag;
set(handles.edit_result,'Enable','on');
set(handles.text7,'String','输入旋律');
set(handles.text_title,'String','哼唱评分系统');
set(handles.edit_result,'String','');
set(handles.pushbutton_piano,'String','评分对比');
set(handles.edit_filename,'String','');
set(hObject,'String','切换识别');
% 显示这两个
set(handles.text_4score,'Visible','on');
set(handles.edit_4score,'Visible','on');
flag=1;
cla(handles.axes1,'reset'); 
cla(handles.axes2,'reset');
cla(handles.axes3,'reset'); 
cla(handles.axes4,'reset');



function edit_4score_Callback(hObject, eventdata, handles)
% hObject    handle to edit_4score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_4score as text
%        str2double(get(hObject,'String')) returns contents of edit_4score as a double


% --- Executes during object creation, after setting all properties.
function edit_4score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_4score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
