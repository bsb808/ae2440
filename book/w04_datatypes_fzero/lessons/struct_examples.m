
echo on
rectangle.color = "red";
rectangle.width = 200;
rectangle.height = 100;
rectangle.corner = [0 0];
rectangle


rectangles(1).color = "red";
rectangles(1).width = 200;
rectangles(2).color = "green";
rectangles(2).width = 400;
rectangles(3).color = "blue";
rectangles(3).width = 800;
rectangles
rectangles.width

% Initialize a 2x1 structure array manually
people(1).name = 'Alice';
people(1).age = 25;
people(2).name = 'Bob';
people(2).age = 30;

% Create a 2x1 structure array using struct
people = struct('name', {'Alice', 'Bob'}, 'age', {25, 30});

people.age

peeps = struct2cell(people)
names = peeps(1,1,:)
ages = peeps(2,1,:)

echo off

