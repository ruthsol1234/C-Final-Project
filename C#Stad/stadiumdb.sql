create database stadiumdatabase
use stadiumdatabase

create table tblUser
(
id int primary key identity,
firstname varchar(30) not null,
lastname varchar(30),
email varchar(50),
userName varchar(60),
password varchar(30),
photo image,
role varchar(30)
)


create table tblReservation
(
resid int primary key identity,
resdate varchar(30) not null,
restime varchar(30) not null,
numberofreservation int,
users int,
ticket int,
)
create table tblTicket
(
ticketid int primary key identity,
tickettype varchar(30) not null,
amount money,
event int
)
create table tblEvent
(
eventid int primary key identity,
name varchar(30) not null,
eventdate varchar(30) not null,
eventtime varchar(30) not null
)

create table tblSeat
(
seatnumber int primary key ,
seattype varchar(30) not null,
reservation int
)

alter table tblTicket
add constraint fk_ev
foreign key (event) references tblEvent(eventid)



alter table tblReservation
add constraint fk_us
foreign key (users) references tblUser(id) 

alter table tblReservation
add constraint fk_ti
foreign key (ticket) references tblTicket(ticketid)

alter table tblSeat
add constraint fk_re
foreign key (reservation) references tblReservation(resid)





insert into tblUser values
('Abebe','Alfawe','abe@gmail.com','Abebe Alfawe','123',null,'User'),
('Kebede','Amare','kbe@gmail.com','Kebede Amare','kbe',null,'User'),
('Abebech','Zeritu','bech@gmail.com','Abebech Zeritu','098',null,'User'),
('Alem','Kebede','alm@gmail.com','Alem Kebede','pass',null,'User'),
('Fatu','Abebe','fa@gmail.com','Fatu Abebe','word',null,'User'),
('Admin','Admin','Admin','Admin','pass',null,'Adminstrator')

select *from tblUser

insert into tblEvent values
('adama city vs. st.george','05/03/2013','05:00'),
('sebeta city vs. adama city','09/05/2013','04:00'),
('hawassa vs. dire dawa','12/03/2013','03:00'),
('fasil ketema vs. hawassa','05/03/2013','09:00')

select * from tblEvent
insert into tblTicket values

('VIP',500.00,1),('VIP',500.00,2),
('VIP',500.00,3),('VIP',500.00,4),
('REGULAR',300.00,1),('REGULAR',300.00,2),
('REGULAR',300.00,3),('REGULAR',300.00,4),
('REGULAR',300.00,3),('REGULAR',300.00,4)

/*insert into tblPayment values

('01/03/2013',500,5),
('09/04/2013',1000,2),
('09/04/2013',990,1),
('04/03/2013',500,5)*/

insert into tblReservation values

('01/03/2013','06:00',2,1,1),
('09/04/2013','11:00',1,2,2),
('09/04/2013','05:00',5,3,3),
('04/03/2013','07:00',4,4,4)

insert into tblSeat values

(1,'VIP',1),(2,'REGULAR',2),
(3,'VIP',3),(4,'REGULAR',4),
(5,'VIP',null),(6,'REGULAR',null)

select * from tblReservation
--Users

go
create procedure [dbo].[spGetRole]
@userName varchar(50),
@password varchar(50)
as
select role from tblUser
where userName =@userName and password=@password
go



go
alter proc [dbo].[spCreateUser]
@id varchar(50),
@firstName varchar(50),
@lastName varchar(50),
@email varchar(50),
@userName varchar(50),
@password varchar(50),
@photo image

as 
begin

insert into tblUser(firstName,lastName,email,userName,password,photo,role) 
values (@firstName,@lastName,@email,@userName,@password,@photo,'User')
end

go
alter proc [dbo].[AllUsers]
as
begin
select count(id)from tblUser
where role ='User'
end

go
create proc [dbo].[AllAdminstrator]
as
begin
select count(id)from tblUser
where role ='Adminstrator'
end

go
create proc [dbo].[UserByEvent]
@eventName varchar(30)
as 
begin
select count(users) from tblReservation as r
join tblTicket as t
on r.ticket=t.ticketid
join tblEvent as e
on t.event=e.eventid
where e.name=@eventName
end

--Event
go
create proc [dbo].[spGetEventbyName]
@eventName varchar(30)
as 
begin
select *from tblEvent 
where name like @eventName+'%' 
end
go

go
create proc [dbo].[spDisplayEvent]
as 
begin
select * from tblEvent
end 
go

go
create proc [dbo].[spInsertEvent]
@name varchar(50),
@eventdate varchar(30),
@eventtime varchar(30)
as 
begin

insert into tblEvent(name,eventdate,eventtime) 
values (@name,@eventdate,@eventtime)
end
go


go
create proc [dbo].[spUpdateEvent]
@eventid int,
@name varchar(50),
@eventdate varchar(30),
@eventtime varchar(30)
as 
begin
Update tblEvent set name=@name, eventdate=@eventdate,eventtime=@eventtime
where eventid = @eventid
end

go
alter proc [dbo].[spDeleteEvent]
@eventid int
as 
begin
update tblTicket set event=null where event=@eventid
delete from tblEvent
where eventid = @eventid
end
go








--Reservation

go
alter proc[dbo].[spDisplayUserreservation]
@userName varchar(30)
as
begin
select r.resid, r.resdate, r.restime,r.numberofreservation,userName ,t.ticketid,t.amount,t.tickettype ,e.name,s.seatnumber,s.seattype from tblReservation as r
join tblUser as u 
on r.users= u.id
join tblTicket as t
on r.ticket=t.ticketid
join tblEvent as e
on t.event=e.eventid
join tblSeat as s
on r.resid=s.reservation
where u.userName=@userName

end

go
create proc [dbo].[spInsertReservation]
@resdate varchar(30),
@restime varchar(30),
@user varchar(30),
@ticket int
--@seatNumber int
--@seatType varchar(30)
as 
begin
declare @identityval int,@users int,@seatType varchar(30)
select @users= users from tblReservation as r
join tblUser as u
on r.users=u.id
where username=@user
insert into tblReservation (resdate,restime,numberofreservation,users,ticket)
values (@resdate,@restime,1,@users,@ticket)
end




exec [dbo].[spInsertReservationandSeat]'06/04/2014','06:00','Abebe Alfawe',5,5



go
alter proc [dbo].[spUpdateReservation]
@resid int,
@resdate varchar(30),
@restime varchar(30),
@user varchar(30),
@ticket int
as 
begin
declare @users int
select @users= users from tblReservation as r
join tblUser as u
on r.users=u.id
where username=@user
update tblReservation set resdate=@resdate,restime=@restime,users=@users,ticket=@ticket
where resid=@resid

end
--
go
create proc [dbo].[spReservationstoreforvip]

as 
begin
declare @seattype varchar(30)
select @seattype= (seattype) from tblSeat
where @seattype='VIP'
end

--
go
create proc [dbo].[spReservationstoreforregular]

as 
begin
declare @seattype varchar(30)
select @seattype= (seattype) from tblSeat
where @seattype='Regular'
end







-- Ticket

go
alter proc [dbo].[spDisplayTicket]
as 
begin
select ticketid,tickettype,amount,name from tblTicket as t
join tblEvent as e
on t.event=e.eventid
where ticketid not in (select ticket from tblReservation)
end


go
alter proc [dbo].[spInsertTicket]
@tickettype varchar(30),
@amount varchar(30),
@event varchar(30)
as 
begin
declare @eventid int
select @eventid = event from tblticket as t
join tblEvent as e
on t.event=e.eventid
where name=@event

insert into tblTicket(tickettype,amount,event) 
values (@tickettype,@amount,@eventid)
end
go

select *from tblTicket
go
alter proc [dbo].[spUpdateTicket]
@ticketid int,
@tickettype varchar(30),
@amount varchar(30),
@event varchar(30)
as 
begin
declare @eventid int
select @eventid = event from tblticket as t
join tblEvent as e
on t.event=e.eventid
where name=@event
Update tblTicket set tickettype=@tickettype, amount=@amount,event=@eventid
where ticketid = @ticketid
end

go
create proc [dbo].[spDeleteTicket]
@ticketid int
as 
begin
delete from tblTicket
where ticketid = @ticketid
end

select * from tblTicket
go
create proc [dbo].[TicketbyType]
@tickettype varchar(30)
as
begin
select ticketid,tickettype,amount,name from tblTicket as t
join tblEvent as e
on t.event=e.eventid
where tickettype=@tickettype
end

--Seat
go 
alter proc [dbo].[spDisplaySeat]
as 
begin
select seatnumber,seattype,reservation from tblSeat as s
where s.reservation is null
end

--2
go 
create proc [dbo].[spAllSeat]
as 
begin
select * from tblSeat as s
end
--3

go
alter proc [dbo].[spInsertSeat]
@resid int,
@seatNumber int
--@seatType varchar(30)
as
begin
declare @identityVal int,@seatType varchar(30)
set @identityval= SCOPE_IDENTITY()
select @seatType= seattype from tblSeat where seatnumber=@seatNumber
insert into tblSeat(seatnumber,seattype,reservation)
values (@seatNumber,@seatType,@resid)

end
--4

go
create proc [dbo].[spEventReservationUserSeat]

as
begin
select s.seatnumber,u.userName,name from tblSeat as s
join tblReservation as r
on s.reservation=r.resid
join tblUser as u
on u.id=r.users
join tblTicket as t
on r.ticket=t.ticketid
join tblEvent as e
on t.event=e.eventid
end
--5
go
create proc 


--Functions

--Seat
go
create function [usd]

--Event
go
create function [usdAllEvents]()
returns table
as 
return(select  count(eventid) as AllEvents from tblEvent)



--Reservation
go
create function [udfNoReservationByevent]
(@eventName varchar(30))
returns int
as
begin 
declare @noofreservation int
select @noofreservation= count(numberofreservation) from tblReservation as r
join tblTicket as t
on r.ticket=t.ticketid
join tblEvent as e
on t.event=e.eventid
where name like @eventName+'%'

return @noofreservation

end

go 
create function [udfSeatsbyEvent]
(@eventName varchar(30))
returns int
as
begin
declare @numberofSeats int
select @numberofSeats=count(seatNumber) from tblSeat as s
join tblReservation as r
on s.reservation=r.resid
join tblTicket as t
on r.ticket=t.ticketid
join tblEvent as e
on t.event=e.eventid
where s.reservation is not null and e.name=@eventname

return @numberofSeats

end

go
create function [udfTicketsforEvent]
(@eventName varchar(30))
returns Table
return(select count(ticketid)as Tickets from tblTicket as t 
       join tblEvent as e
	   on t.event=e.eventid
	   where name=@eventName
	   )
go 
create function [udfVIPSeatsbyEvent]
(@eventName varchar(30))
returns table

return(select count(seatNumber) as VIPSeat from tblSeat as s
join tblReservation as r
on s.reservation=r.resid
join tblTicket as t
on r.ticket=t.ticketid
join tblEvent as e
on t.event=e.eventid
where s.reservation is not null and e.name=@eventname and s.seattype ='VIP')






--Triggers
go
alter trigger [ReservationGreaterthan10000]
on tblReservation
after insert
as
begin
declare @count int
select @count=count(numberofreservation) from tblReservation
if @count>10000
begin
 raiserror('All Tickets are soled out',16,1)
 rollback
 end
end



select * from tblReservation
go
create trigger [checkinsertname]
on tblUser
after insert
as
begin
declare @fullname varchar(30)
select @fullname= userName  from tblUser

if(@fullname=null or @fullname='')
  begin
 raiserror('name not entered',16,1)
 rollback
 end
 end

 --tri
 go
create trigger [checkpasswordamount]
on tblUser
after insert
as
begin
declare @password varchar(30)
select @password= password from tblUser

if(@password>16)
  begin
 raiserror('password too long',16,1)
 rollback
 end
 end

 --tri
  go
create trigger [checkclashdate]
on tblEvent
after insert
as
begin


if exists(select  eventdate,eventtime from tblEvent)
  begin
 raiserror('event date and event time clashes',32,1)
 rollback
 end
 end

 --tri
  go
create trigger [checkemail]
on tblUser
after insert
as
begin


if exists(select  email from tblUser)
  begin
 raiserror('email already registered',24,1)
 rollback
 end
 end
