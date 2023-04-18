------------------cau1---------------------
go
create trigger tg_nhap
on tbNHAP
for insert
as
begin
declare @masp nvarchar(30),@manv nvarchar(30)
declare @sln int, @dgn float
select @masp = masp, @manv = manv, @sln = soluongN, @dgn = dongiaN
from inserted
if(not exists(select*from tbSANPHAM where MaSP = @masp))
begin
raiserror(N'không tồn tại sản phẩm trong danh mục sản phẩm', 16,2)
rollback tran;
end
else
if(not exists(select*from tbNHANVIEN where manv = @manv))
begin
raiserror(N'không tồn tại nhân viên trong mã này', 16,2)
rollback tran;
end
else
if(@sln <= 0 or @dgn <= 0)
begin
raiserror(N'nhập sai số lượng hoặc đơn giá', 16,2)
rollback tran;
end
else
update tbSANPHAM set soluong = soluong + @sln
from tbSANPHAM
where MaSP = @masp
end
go
insert into tbNHAP values('N06','SP01','NV02','2019-02-28',200,100000)
select*from tbNHANVIEN
select*from tbNHAP
------------cau2---------------------
go
create trigger tg_xuat
on 
tbXUAT
for insert
as
begin
declare @masp nvarchar(30),@manv nvarchar(30)
declare @slx int
select @masp = masp, @manv = manv, @slx = soluongX 
from inserted
end
if(not exists(select*from tbSANPHAM where MaSP = @masp))
begin
declare @soluong int
select @soluong = soluong
from tbSANPHAM
begin
raiserror(N'không tồn tại sản phẩm trong danh mục sản phẩm', 16,2)
rollback tran;
end
end
else
if(not exists(select*from tbNHANVIEN where manv = @manv))
begin
raiserror(N'không tồn tại nhân viên trong mã này', 16,2)
rollback tran;
end
else
if(@slx< @soluong)
begin
raiserror(N'nhập sai số lượng nhập hay số lượng trong sản phẩm sai', 16,2)
rollback tran;
end
else
update tbSANPHAM 
set soluong = soluong + @slx
from tbSANPHAM
where MaSP = @masp
go
insert into tbXUAT
values('X06','SP05','NV05','2019-04-29','5')
select*from tbSANPHAM
select*from tbXUAT
-----------------------cau3------------------
go
create trigger tg_xoaphieuxuat1
on tbXUAT
for delete
as
begin
declare @masp nvarchar(30),@manv nvarchar(30)
declare @slx int
select @masp = masp, @manv = manv, @slx = soluongX 
from deleted
end
if(not exists(select*from tbSANPHAM where MaSP = @masp))
begin
declare @soluong int
select @soluong = soluong
from tbSANPHAM
begin
raiserror(N'không tồn tại sản phẩm trong danh mục sản phẩm', 16,2)
rollback tran;
end
end
else
update tbSANPHAM 
set soluong = soluong + @slx
from tbSANPHAM
where MaSP = @masp
go
insert into tbXUAT
values('X06','SP05','NV05','2019-04-29','5')
select*from tbXUAT
select*from tbSANPHAM
-----------------cau4----------------------
go
create trigger xuathang 
on tbXUAT
for update 
as
begin 
declare @masp nvarchar(20), @slx int
select @masp = masp, @slx = soluongX 
from inserted
update tbSANPHAM 
set soluong = soluong - @slx 
where masp = @masp
if @slx > (select top 1 Soluong from tbSANPHAM )  
begin
raiserror (N'So luong xuat cao hon ton kho',16,1)
rollback tran;
end
end
insert into tbXUAT
values('X06','SP05','NV05','2019-04-29','5')
select*from tbXUAT
select*from tbSANPHAM
------------------cau6----------------------
go
create trigger XoaPhieuNhap 
on tbNHAP
for delete 
as
begin
update tbSANPHAM 
set soluong = soluong-(select soluongN from deleted where masp= tbSANPHAM.masp)
from tbSANPHAM 
join deleted 
on tbSANPHAM.masp = deleted.Masp   
end
select*from tbNHAP
select*from tbSANPHAM