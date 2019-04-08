unit appgui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, sorter;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  lst,lstrev:TStringList;
  filechosen:boolean;
  opt:TSorterOptions;
  path, flagstring, readdata,tmp,line:string;
  ch:char;
  alst:array [1..32767] of string;
  fil:text;
  filestream:TFileStream;
  i,ind:integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  filechosen:=false;
  while not OpenDialog1.Execute do;
  if Sorter.sorter(lst,opt) then
    begin
      path:=OpenDialog1.FileName;
      Label1.Caption:=path;
      filechosen:=true;
    end
  else
    Label1.Caption:='Error';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //open file
  //check settings
  if CheckBox1.Checked then
    opt.DelDuplicates:=DelAllDups
  else
    opt.DelDuplicates:=skip;
  if RadioButton1.Checked then
    opt.SortAction:=asc;
  if RadioButton2.Checked then
    opt.SortAction:=desc;
  if RadioButton3.Checked then
    opt.SortAction:=off;
  case opt.SortAction of
    asc:flagstring:='Sorting:asc';
    desc:flagstring:='Sorting:desc';
    off:flagstring:='Sorting:none';
  end;
  if opt.DelDuplicates=DelAllDups then
    flagstring+=sLineBreak+'Delete all duplicates';
  //start process
  if not filechosen then
    ShowMessage('Please select a file!')
  else
    if sorter.sorter(lst,opt) then
      begin
        ShowMessage('Done!'+sLineBreak+'file path: '+path+sLineBreak+flagstring);
        filestream:=TFileStream.Create(path,fmOpenRead);
        try
          // старое чтение файла
          {SetLength(readdata,filestream.size);
          for i:=1 to 5 do
          begin
            filestream.read(readdata[i],1);
          end;
          ShowMessage(readdata);}
          lst:=TStringList.Create;
          //lst.Duplicates:=dupAccept;
          line:='';
          lstrev:=TStringList.Create();
          // вроде выбрасывает дупы, но и без этого тоэъже выбрасывает
          {
          if opt.DelDuplicates=DelAllDups then
            begin
              lstrev.Duplicates:=dupIgnore;
              lst.Duplicates:=dupIgnore;
            end
          else
            begin
              lstrev.Duplicates:=dupAccept;
              lst.Duplicates:=dupAccept;
            end;                                }
          //ShowMessage('before cycle: '+lst.Count.toString());
          ind:=1;
          while(filestream.Read(ch,1)=1) do
             if  (ch <> sLineBreak) then
               line+=ch
             else
               begin
                 if (lst.IndexOf(line)=-1) then
                     lst.Add(line);

                 alst[ind]:=line;
                 line:='';
                 ind+=1;
               end;
          //ShowMessage('after cycle '+lst.Count.toString()+' '+ind.tostring());//+ind.tostring());
          // получены все строки из файла
          // ShowMessage(IntToStr(lst.Count)+lst[3]);

          if not (opt.SortAction=off) then
            begin
              lst.Create;
              for i:=1 to ind do
                begin
                  lst.Add(alst[i]);
                end;
              {for i:=1 to ind do
                ShowMessage(alst[i]);}
              lst.sort;

              {for i:=0 to lst.count-1 do
                 alst[i+1]:=lst[i];}
            end;
          if opt.SortAction=desc then
            begin
              for i:=0 to lst.Count-1 do
                begin
                  lstrev.Add(lst[lst.Count-1-i]);

                end;
              lst:=lstrev
            end;

          //ShowMessage('after sorting '+lst.Count.toString());

          filestream.Destroy;
          FileCreate(path+'.new');
          //ShowMessage('before writing '+lst.Count.toString());
           assignFile(fil,path+'.new');
           rewrite(fil);
          //filestream:=TFileStream.Create(path+'.new',fmOpenWrite);
          for i:=1 to ind do
            begin
              //filestream.Write(alst[i][1],length(alst[i]));
              writeln(fil,lst[i]);
            end;
          //lst.SaveToStream(filestream);//writeerror
        finally
          closeFile(fil);
          // вызывало ошибку
          //filestream.free;
        end;
      end
    else
      ShowMessage('Error!')
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  filechosen:=false;
end;

end.

