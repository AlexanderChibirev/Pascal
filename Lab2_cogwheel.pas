program lab2;
{22. На  плоскости  расположена  система  из  N  шестеренок,
которая  приводится  в  движение  вращением  шестеренки  1  по
часовой стрелке.  Сцепленные шестеренки могут вращаться только
в    противоположных    направлениях.   Требуется   определить
направление движения каждой шестеренки  либо  установить,  что
систему   заклинит.   Некоторые   шестеренки   могут  остаться
неподвижными (10).}
Const N = 20000;
var
  cogwheel : array [1..N*2, 1..2] of integer;
  fixed: array [1..N*20] of integer;
  all_cogwheel: array[1..N*3] of integer;
  cogwise_l: array[1..N*2] of integer;
  cogwise_r: array[1..N*2] of integer;
  cogwise_r_compressed: array[1..N*2] of integer;
  cogwise_l_compressed: array[1..N*2] of integer;
  fixed_compressed: array[1..N*2] of integer;
  ender_array: array[1..N*3] of integer;
  i, number,n_par,num_cog, j,k,spicok_par_left_int, spicok_par_right_int,flag_for_mass2,counting_rows,m,num,k2,k3,k4,a1,k5,num_cog1: integer;
  count_r, count_l,flag1, flag_for_mass,prov,fixed_count:integer;
  input_f: TEXT;
  line,flag, filename, spicok_par_left, spicok_par_right :string;
  

function processing_clockwise(num_cog, flag_for_mass: integer): integer;
   var i: integer;
begin
  if flag_for_mass = 1 then
    begin
    for i:= 1 to N*2 do
      if cogwise_r[i] = num_cog then
        begin
        processing_clockwise:= 1;
        inc(prov);
        end
      else if cogwise_l[i] = num_cog then
        begin
        processing_clockwise:=0;
        inc(prov);
        end;
    end
  else if flag_for_mass = 0 then
    begin
      for i:= 1 to N*2 do
        if cogwise_l[i] = num_cog then
          begin
          processing_clockwise:= 0;
          inc(prov)
          end
        else if cogwise_r[i] = num_cog then
          begin
          processing_clockwise:= 1;
          inc(prov);
          end;
   end;
  //проверка на неподвижность, если неподвижна, то мы ее не включаем в массив
  if prov < 1  then
    begin
    processing_clockwise:= 3;
    end
  else
    prov:= 0;
end;
Begin
  writeln('введите название файла(путь):');
  readln(filename);
  j:=1;
  i:=1;
  k:=1;
  m:=1;
  fixed_count:= 1;
  if (FileExists(filename)=false) or (filename = '') then
    writeln('неверное имя')
  else
    BEGIN
    ASSIGN(input_f, filename);
    RESET(input_f);
    flag:='left';
    counting_rows := 1;
    While not EOF(input_f) do
      Begin
        readln(input_f,line);
        if counting_rows < 3 then
        begin
          if counting_rows = 1 then
            begin
            number:= StrToInt(line)
            end
          else
            begin
            n_par:=StrToInt(line)
            end;
        end
        else
        begin
        for a1:=1 to length(line) do
        begin
          if ',' = line[a1] then
            flag1:= 1;
        end;
        if flag1=1 then 
        //if length(line) > 2 then
        begin
            for i:=1 to (length(line)) do
            begin
              if flag = 'left' then
                begin
                if line[i] <> ',' then
                  begin
                    spicok_par_left := spicok_par_left + line[i];
                  end
                else
                  flag:= 'right';
                end  
              else if flag = 'right' then
                begin
                if i = length(line) then
                begin
                  flag:='left';
                  spicok_par_right := spicok_par_right + line[i];
                end
                else
                  spicok_par_right := spicok_par_right + line[i];
                end;
            end;        
        spicok_par_left_int:= StrToInt(spicok_par_left);
        spicok_par_right_int:= StrToInt(spicok_par_right);
        (cogwheel[k,j]) := spicok_par_left_int;
        (cogwheel[k,j+1]) := spicok_par_right_int;
        spicok_par_left := '';
        spicok_par_right := '';
        inc(k);
        flag1:=0;
        end
        else
        begin
          //m1:=StrToInt(line);
          //fixed[m]:= m1;
          //write('шестеренка неподвижна');
          //inc(m);
        end;
        //if length(line) < 2 then // åñëè ëèíèÿ èìååò çàïÿòóþ, òî ìû óâåëè÷èâàåì k åñëè íåò, òî èäåì äàëüøå, çàâòðà ïîìåíÿé, à ñåé÷àñ ñïàòåíüêè
        
        end;
        //for i:=1 to length(line) do
        //  if 
        inc(counting_rows);
      End;
    //writeln(cogwheel);    
    close(input_f);
    //m1:=m-1;
    num_cog := 1;
    count_r:= 1;
    count_l:= 1;
    cogwise_r[count_r]:= 1;
    inc(count_r);
    flag_for_mass:= 1;
    while num_cog < number+1 do
    begin
    while num_cog < number+1 do
    begin      
      flag_for_mass:= processing_clockwise(num_cog,flag_for_mass); //êîòîðàÿ âîçâðàùàåò çíà÷åíèå ôëàãà      
      if flag_for_mass = 1 then
      begin
        For i :=1 to n_par do
        begin
        if (cogwheel[i,1] = num_cog)  or (cogwheel[i,2] = num_cog) then
        begin
        if cogwheel[i,1] = num_cog then
        begin
          cogwise_l[count_l]:= cogwheel[i,2];
          inc(count_l);
          flag_for_mass2:= flag_for_mass;
        end
        else if cogwheel[i,2] = num_cog then
        begin
          cogwise_l[count_l]:= cogwheel[i,1];
          inc(count_l);
          flag_for_mass2:=flag_for_mass;
        end;
        end;
        end;
      end
      else if flag_for_mass= 0 then
      begin
        For i :=1 to n_par do
        begin
        if (cogwheel[i,1] = num_cog)  or (cogwheel[i,2] = num_cog) then
        begin
        if cogwheel[i,1] = num_cog then
        begin
          cogwise_r[count_r]:= cogwheel[i,2];
          inc(count_r);
          flag_for_mass2:=flag_for_mass;
        end
        else if cogwheel[i,2] = num_cog then
        begin
          cogwise_r[count_r]:= cogwheel[i,1];
          inc(count_r);
          flag_for_mass2:=flag_for_mass;
        end;
        end;
        end;
      end
      else if flag_for_mass= 3 then
        flag_for_mass:= flag_for_mass2;
    inc(num_cog);
    //write('массив против часовой: ');
//writeln(cogwise_l);
    //write('массив по часовой: ');
    //writeln(cogwise_r);
    //writeln();
    end;
    num_cog:=1;
    inc(num_cog1);
    end;   
//обход по часовой стрелки, удаление повторов++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i:=0;
j:=0;
k:=0;
num:=N;
  for i:=1 to num do begin
   m:=0;
   for j:=1 to k do
   if (cogwise_r[i]=cogwise_r_compressed[j]) then
    inc(m);
    if m=0 then begin
     inc(k);
     cogwise_r_compressed[k]:=cogwise_r[i];
    end;
  end;
k2:= k;
for i:=1 to k-1 do
begin
all_cogwheel[i]:= cogwise_r_compressed[i];
inc(k5);
inc(k4);
end;
//+++++++++++++++++++++++++конец обхода+++++++++++++++++++++++++++++++++++++++++++++===
//обход против часовой стрелки, удаление повторов++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
i:=0;
j:=0;
k:=0;
num:=N;
  for i:=1 to num do begin
   m:=0;
   for j:=1 to k do
   if (cogwise_l[i]=cogwise_l_compressed[j]) then
    inc(m);
    if m=0 then begin
     inc(k);
     cogwise_l_compressed[k]:=cogwise_l[i];
    end;
  end;
//writeln(k3);
//writeln(k4);
//writeln(k);
//writeln(k2);
//writeln(k5);
for i:=1 to k-1 do
begin
all_cogwheel[k2]:= cogwise_l_compressed[i];
inc(k2);
inc(k3);
end;
//writeln;
//+++++++++++++++++++++++++конец обхода++++++++++++++++++++++++++++++++++++++++++++++++
//write('по час');
//writeln(cogwise_r_compressed);
//write('против час');
//writeln(cogwise_l_compressed);
//writeln(all_cogwheel);
dec(k2);
//++++++++++++++++++++++++Проверка заклинит систему или нет++++++++++++++++++++++++++++
i:=0;
j:=0;
k:=0;
num:=N;
  for i:=1 to num do begin
   m:=0;
   for j:=1 to k do
   if (all_cogwheel[i]=ender_array[j]) then
    inc(m);
    if m=0 then begin
     inc(k);
     ender_array[k]:=all_cogwheel[i];
    end;
  end;
//writeln(number);
num_cog:=1;
fixed_count:= 1;
//======================ПРОВЕРКА НА НЕПОДВИЖКУ=========
while num_cog < number+1 do
  begin
  for i:=1 to k2 do
  begin
    if all_cogwheel[i] = num_cog then
      flag:= 'значит эта шестеренка подвижна';
  end;
  if flag = 'значит эта шестеренка подвижна' then
    flag:= 'неизвестность'
  else
    begin
    fixed[fixed_count]:= num_cog;
    inc(fixed_count);
    flag:= 'неизвестность';
    end;
  inc(num_cog);  
  end;
//==================КОНЕЦ ПРОВЕРКА=================
//writeln('pocle');
//writeln(all_cogwheel);
//writeln('фиксированые');
//writeln(fixed);
//writeln('неподвижка');
//writeln(fixed_compressed);
//проверка не неисправность
if  counting_rows > 2 then
begin
if (k-1) <> k2 then
  writeln('Ваша система неисправна')
//конец проверки,выдача на экран информации по шестеренкам
else  
  begin
    writeln('всего шестеренок: ',number);
    writeln('всего пар шестеренок: ',n_par); 
    writeln('Шестеренки по часовой: ');
    for i:=1 to k5 do writeln(cogwise_r_compressed[i]:3);
    writeln;
    writeln('Шестеренки против часовой стрелки: ');
    for i:=1 to k3 do writeln(cogwise_l_compressed[i]:3);
    writeln;
    writeln('Неподвижные шестеренки: ');
    for i:=1 to fixed_count-1 do writeln(fixed[i]:3);
  end;
//конец проверки
  //writeln(fixed_count - 1); это число фиксиров шестер
  end
else
  writeln('задайте данные правильно');
    END;
End.
