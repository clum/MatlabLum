%Demonstrate creating categorical arrays
%
%Christopher Lum
%lum@uw.edu


%Version History
%11/21/24: Created

clear
clc
close all

%% Define categorical arrays of different types
%char array
A_char = {'Ford','Nissan','Volvo','Ford'}';
c_char = categorical(A_char)

%string array
A_string = ["Ford","Nissan","Volvo","Ford"]';
c_string = categorical(A_string)

%double array
A_double = [1.1,2.1,-3.55,-5]';
c_double = categorical(A_double)

%datetime array
A_datetime = [
    datetime(2021,9,20,11,30,1)    
    datetime(2022,10,21,11,30,1)
    datetime(2023,11,22,12,30,1)
    datetime(2024,12,23,13,30,1)
    ];
c_datetime = categorical(A_datetime)

%% Define <undefined> entries
disp('----------<undefined> entries-------------')

%char array
char_undefinedIdentifier = '';
A_char_undefined = {'Ford','Nissan','Volvo','Ford',char_undefinedIdentifier}';  %cannot simply append to A_char
c_char_undefined = categorical(A_char_undefined)

%string array
string_undefinedIdentifierA = "";
string_undefinedIdentifierB = missing;
A_string_undefined = ["Ford","Nissan","Volvo","Ford",string_undefinedIdentifierA,string_undefinedIdentifierB]';
c_string_undefined = categorical(A_string_undefined)

%double array
double_undefinedIdentifierA = NaN;
double_undefinedIdentifierB = missing;
A_double_undefined = [A_double;double_undefinedIdentifierA;double_undefinedIdentifierB];
c_double_undefined = categorical(A_double_undefined)

%datetime array
datetime_undefinedIdentifierA = NaT;
datetime_undefinedIdentifierB = missing;
A_datetime_undefined = [A_datetime;datetime_undefinedIdentifierA;datetime_undefinedIdentifierB];
c_datetime_undefined = categorical(A_datetime_undefined)

%% Insert <undefined> at certain entries
disp('----------Insert <undefined> entries-------------')
%char array
c_datetime_undefined(1) = missing

%string array
c_string_undefined(1) = missing

%double array
c_double_undefined(1) = missing

%datetime array
c_datetime_undefined(1) = missing

disp('DONE!')