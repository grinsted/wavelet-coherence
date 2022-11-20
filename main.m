% 配置
parent_dir = "~/data/q/basic_series";
in_path = "ETP_LR04_0_1000ka.xlsx";
% out_path = "ETP_LR04_0_1000ka_out_wavelet.xlsx";
x_column = "age_ka";  % 列名只能以字母开头，包含字母、数字、_，不能有其他符号
y1_column = "ETP";  % 列名只能以字母开头，包含字母、数字、_，不能有其他符号
y2_column = "LR04";  % 列名只能以字母开头，包含字母、数字、_，不能有其他符号
mode = "CWT";  % 可以为 CWT、XWT、WTC，分别表示连续小波变换、交叉小波、小波相干
% mode = "XWT";
% mode = "WTC";

% 读数据
d = readtable(sprintf("%s/%s", parent_dir, in_path));
x = d.(x_column);
y1 = d.(y1_column);
y2 = d.(y2_column);

% 小波分析
if mode == "CWT"
    % CWT，连续小波变换
    wt([x y1]);
elseif mode == "XWT"
    % XWT，交叉小波
    xwt([x y1], [x y2]);
elseif mode == "WTC"
    % WTC，小波相干
    wtc([x y1], [x y2]);
else
    error("不支持的 mode: %s, 请设置为 CWT、XWT 或者 WTC", mode)
end