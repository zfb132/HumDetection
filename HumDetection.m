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

% Last Modified by GUIDE v2.5 07-Jun-2018 19:06:07

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

% GUI�������
movegui( gcf, 'center' );

% Ϊbutton��ӱ���ͼƬ
im=imread('sound.png');
set(handles.pushbutton_play1,'CData',im);
set(handles.pushbutton_play2,'CData',im);

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
global singley;global T;
try
    %����ϴβ���ͼ��
    cla(handles.axes1,'reset'); 
    cla(handles.axes2,'reset');
    cla(handles.axes3,'reset'); 
    cla(handles.axes4,'reset');
    %��ȡ�ļ�
    [filename,path]=uigetfile({'*.wav;*.mp3;*.ogg;*.flac;*.au;',  ...
        '��Ƶ�ļ�(*.wav,*.mp3,*.ogg,*.flac,*.au)';},'���ļ�') ;
    set(handles.edit_filename,'String',filename);
    [y,Fs] = audioread(strcat(path,filename));
    singley = y(:,1);
    % �ز�����8KHz
    fs=8000;
    % Ԥ�����˲�
    singley=filter([1 -0.68],1,singley);
    singley=resample(singley,fs,Fs);
    info = audioinfo(strcat(path,filename));
    T = info.Duration;
    % ��ʾʱ����
    timeplot(singley,T,handles.axes1);
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
global singley;
if(isempty(singley))
    msgbox('����ѡ���ļ���','����','warn');
    return;
end
soundsc(singley);


% --- Executes on button press in pushbutton_play2.
function pushbutton_play2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global singley;
if(isempty(singley))
    msgbox('����ѡ���ļ���','����','warn');
    return;
end
soundsc(singley);


%% �Զ��庯������
% ��ָ������axes����ʾʱ����
function timeplot(x,T,hObject)
    axes(hObject);
    plot(linspace(0,T,length(x)),x);
    xlim([0 T]);
    title('�����ź�ʱ����');
    xlabel('ʱ��/S');
    ylabel('�źŷ���'); 
    
% �Զ����֡����
function [segnum,segment]=frame(x,seglen,noverlap)
    % ����ȡ��
    segnum=ceil(length(x)/noverlap);
    % ����һ֡�Ĳ���
    x=[x',zeros(1,segnum*noverlap-length(x))]';
    % ��Ϊseglen>noverlap����i*noverlap+seglenҪ��segnum-1���Σ����򳬳�����
    segnum=segnum-1;
    % ����x�ֶκ������������棬һ��seglen�����ݶ�Ӧһ���Σ���segnum��
    segment=zeros([seglen,segnum]);
    for i=0:segnum-1
        segment(:,i+1)=x(i*noverlap+1:i*noverlap+seglen);
    end