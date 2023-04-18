---------------cau1-------------------------
go
create proc	themnhanvienmoi(@manv nvarchar(20),@tennv nvarchar(20),@gioitinh nvarchar(20),
@diachi nvarchar(20),@sodt nvarchar(20),@email nvarchar(20),@phong nvarchar(20), @flag int)
as
if @gioitinh in('nam', 'nu')
begin
if @flag = 0
begin
insert into tbNHANVIEN(manv,tennv,gioitinh,diachi,sodt,email,phong)
values (@manv,@tennv,@gioitinh,@diachi,@sodt,@email,@phong)
end
else
begin
update tbNHANVIEN
set tennv = @tennv, gioitinh = @gioitinh, diachi = @diachi, sodt = @sodt, email = @email, phong = @phong
where manv = @manv
end
raiserror(N'mã lỗi 0', 16,1)
end
else
begin
raiserror(N'mã lỗi 1', 16,1)
rollback tran; 
end
go
exec themnhanvienmoi 'NV01','Nguyen Thi Thu','nu','Ha Noi','0982626521','thu@gmail.com','ke toan','1'
----------------cau2-----------------------
go
create proc	themsanphamoi(@masp nvarchar(20),@tenhang nvarchar(20),@tensp nvarchar(20),
@soluong nvarchar(20),@mausac nvarchar(20),@giaban nvarchar(20),@donvitinh nvarchar(20),@mota nvarchar(20),@flag int)
as
if @flag = 0
begin
if @tenhang not in(select mahangsx from tbSANPHAM )
begin
raiserror(N'mã lỗi 1', 16,2)
rollback tran; 
end
if @soluong < 0 
begin
raiserror(N'mã lỗi 2', 16,2)
rollback tran; 
end
if @tenhang in (select mahangsx from tbSANPHAM) and @soluong > 0
begin
insert into tbSANPHAM(MaSP,mahangsx,tenSP,soluong,mausac,giaban,donvitinh,mota)
values (@masp,@tenhang,@tensp,@soluong,@mausac,@giaban,@donvitinh,@mota)
end
raiserror(N'mã lỗi 0', 16,2)
end
else
begin
if @tenhang not in(select mahangsx from tbSANPHAM )
begin
raiserror(N'mã lỗi 1', 16,2)
rollback tran; 
end
if @soluong < 0 
begin
raiserror(N'mã lỗi 2', 16,2)
rollback tran; 
end
else
begin
update tbSANPHAM
set mahangsx = @tenhang,tenSP = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban, donvitinh = @donvitinh, mota = @mota
where MaSP = @masp
end
raiserror(N'mã lỗi 0', 16,1)
end 
go
exec themsanphamoi 'SP01','H02','F1 Plus','100','xam','7000000','chiec','hang can cao cap','0'
-------------cau3-----------------------
go
create proc xoadulieunhanvien(@manv nvarchar(20))
as
if @manv in (select manv from tbNHANVIEN)
begin
delete from tbNHANVIEN where manv = @manv
delete from tbNHAP where  manv = @manv
delete from tbXUAT where manv = @manv
raiserror(N'mã lỗi 0', 16,2)
end
else 
begin
raiserror(N'mã lỗi 1', 16,2)
rollback tran; 
end
go
exec xoadulieunhanvien 'NV01'
--------------cau4-------------------
go
create proc xoadulieusanpham(@masp nvarchar(20))
as
if @masp in (select MaSP from tbSANPHAM)
begin
delete from tbSANPHAM 
where MaSP = @masp
delete from tbNHAP 
where   MaSP = @masp
delete from tbXUAT 
where  MaSP = @masp
raiserror(N'mã lỗi 0', 16,2)
end
else 
begin
raiserror(N'mã lỗi 1', 16,2)
rollback tran; 
end
go
exec xoadulieusanpham 'SP03'
-------------------ca6------------------
go
create proc nhapdulieuhangsx(@mahangsx nvarchar(20), @tenhang nvarchar(20), @diachi nvarchar(20), @sodt nvarchar(10), @email nvarchar(20))
as
if @tenhang not in (SELECT tenhang from tbHANGSX)
begin
raiserror(N'mã lỗi 0', 16,2)
end
else 
begin
raiserror(N'mã lỗi 1', 16,2)
rollback tran;
end
go
exec nhapdulieuhangsx 'H01','OPP0','Korea','084-098262626','ss@gmail.com.kr'
-----------cau6-------------------