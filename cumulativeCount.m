function [state, country] = cumulativeCount()
%load matlab data
covid_data = load('covid_data.mat');
state = [];
country = [];

a = covid_data;
b = a.covid_data;

[~,col]=size(b);

%loop and sum through the totals for each state and/or country
for i = 3:col

state = [state sum(cellfun(@(v)v(1),b(2:10,i)))+sum(cellfun(@(v)v(1),b(19:42,i)))+sum(cellfun(@(v)v(1),b(59:62,i)))+...
    sum(cellfun(@(v)v(1),b(96:106,i)))+sum(cellfun(@(v)v(1),b(109:112,i)))+sum(cellfun(@(v)v(1),b(134:195,i)))+...
    sum(cellfun(@(v)v(1),b(200:256,i))+sum(cellfun(@(v)v(1),b(267,i))))+sum(cellfun(@(v)v(1),b(324:339,i)))];

country = [country sum(cellfun(@(v)v(2),b(2:10,i)))+sum(cellfun(@(v)v(2),b(19:42,i)))+sum(cellfun(@(v)v(2),b(59:62,i)))+...
    sum(cellfun(@(v)v(2),b(96:106,i)))+sum(cellfun(@(v)v(2),b(109:112,i)))+sum(cellfun(@(v)v(2),b(134:195,i)))+...
    sum(cellfun(@(v)v(2),b(200:256,i))+sum(cellfun(@(v)v(2),b(267,i))))+sum(cellfun(@(v)v(2),b(324:339,i)))];
end
end