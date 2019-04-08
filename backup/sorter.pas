unit Sorter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TSorterSortAction=(off,asc,desc);
  TSorterDelDuplicates=(None,DelAllDups);
  TSorterOptions = record
    SortAction: TSorterSortAction {enum: off/ asc/ desc};
    DelDuplicates: TSorterDelDuplicates {enum: None, DelAllDups};
  end;

function Sorter(L: TStringList; Opts: TSorterOptions): boolean;

implementation

function Sorter(L: TStringList; Opts: TSorterOptions): boolean;
begin
   Result:=true;
end;

end.


