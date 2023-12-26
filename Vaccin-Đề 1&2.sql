﻿create database NVL_2225
go
use NVL_2225
go
create table PhuHuynh
(
	idPH char(7) primary key,
	hoTenPH nvarchar(50),
	SDT varchar(11)
)
go
create table Tre
(
	idTre char(7) primary key,
	hoTenTre nvarchar(50),
	ngaySinh date,
	gioiTinh char(1), --nhập A nếu là Nam, U nếu là Nữ, và L còn lại
	idPH char(7) foreign key references PhuHuynh(idPH)
		on update cascade
		on delete cascade
)
go
create table BacSi
(
	idBS char(7) primary key,
	hoTenBS nvarchar(50)
)
go
create table NhanVienTiemChung
(
	idNVTC char(7) primary key,
	hoTenNVTC nvarchar(50)
)
go
create table Vaccin
(
	idVC char(7) primary key,
	tenVC nvarchar(50),
	soLuongCon int,
	donGia money
)
go
create table LieuTrinh --Liệu trình
(
	idLT int identity(1,1) primary key,
	--mỗi Vaccin có thể cần tiêm nhiều liều, mỗi liều quy định độ tháng tuổi được tiêm
	soThangTuoiToiThieu int, --số tháng tuổi tối thiểu
	soThangTuoiToiDa int, --số tháng tuổi tối đa
	mucDo nvarchar(50) default N'Bắt buộc'
		constraint CK_LieuTrinh_mucDo check(mucDo in
						(N'Bắt buộc',N'Tùy chọn')), --mức độ: nhận 1 trong 2 giá trị 'Bắt buộc' hoặc 'Tự chọn'
	idVC char(7) foreign key references Vaccin(idVC)
		on update cascade
		on delete cascade
)
go
--Một trẻ có thể tiêm một Vaccin nhiều liều, vì vậy khóa chính phải gồm cả thời gian đăng ký
--vì vậy cần bổ sung thêm cột ngayDangKy
create table Tre_Vaccin
(
	idTre char(7) foreign key references Tre(idTre),
	idVC char(7) foreign key references Vaccin(idVC),
	ngayGioDangKy datetime not null,
	ngayGioThanhToan datetime,
	ngayGioTiem datetime,
	primary key (idTre,idVC,ngayGioDangKy),
	tinhTrangSauTiem nvarchar(100),
	idNVTC char(7) foreign key references NhanVienTiemChung(idNVTC),
	idBS char(7) foreign key references BacSi(idBS)
)

--insert dữ liệu
go
insert into PhuHuynh
values('PH00001',N'Đào Thị Ngọc Hoàng','0901111111'),
	('PH00002',N'Lê Đình Quân','02363222222'),
	('PH00003',N'Bùi Văn Thịnh','0378333333')

go
set dateformat dmy
insert into Tre
values('T000001',N'Lê Thị Mộng Dung','11/1/2020','U','PH00001'),
	('T000002',N'Lê Đình Dũng','22/2/2022','A','PH00001'),
	('T000003',N'Bùi Văn Quang','13/3/2019','A','PH00002'),
	('T000004',N'Bùi Văn Toàn','14/4/2022','A','PH00002'),
	('T000005',N'Bùi Thị Hồng Loan','14/4/2022','U','PH00002')

go
insert into BacSi
values('BS00001',N'Đinh Quang Trung'),
	('BS00002',N'Mai Thị Cẩm Giang'),
	('BS00003',N'Đào Thanh Hùng')

go
insert into NhanVienTiemChung
values('NVTC001',N'Nguyễn Xuân Tuấn'),
	('NVTC002',N'Ngô Thị Mai Trang'),
	('NVTC003',N'Võ Thị Quỳnh My')

--bổ sung thêm 2 column: Nước sản xuất, Đơn vị tính của Vaccin
go
alter table Vaccin
	add NuocSanXuat nvarchar(50),
		DonViTinh nvarchar(50) 
			constraint Vaccin_DVT check (DonViTinh in (N'Lọ',N'Liều'))
go
insert into Vaccin
values('VC00001',N'INFANRIX Hexa (6 trong 1: BH-HG-UV-BL-Gan B-HIB)',8,980000,N'Bỉ',N'Lọ'),
	('VC00002',N'Vaccin phòng 6 bệnh Hexaxim',20,990000,N'Pháp',N'Lọ'),
	('VC00003',N'Viêm gan B - Gene- HBvac',5,100000,N'Việt Nam',N'Liều'),
	('VC00005',N'Vaccin thủy đậu - VARICELLA',40,590000,N'Hàn Quốc',N'Lọ'),
	('VC00006',N'Vaccin quai bị, sởi, Rubella',0,175000,N'Ấn Độ',N'Lọ'),
	('VC00099',N'Vaccin Phế cầu PREVENAR 13 ',43,1415000,N'Anh',N'Lọ')

go
insert into LieuTrinh(soThangTuoiToiThieu,soThangTuoiToiDa,mucDo,idVC)
values (0,6,N'Bắt buộc','VC00001'),
	(1,7,N'Bắt buộc','VC00001'),
	(2,8,N'Bắt buộc','VC00001'),
	(8,20,N'Bắt buộc','VC00001'),
	(12,48,N'Bắt buộc','VC00006'),
	(48,72,N'Bắt buộc','VC00006'),
	(21,24,N'Bắt buộc','VC00001'),
	(25,36,N'Tùy Chọn','VC00001'),
	(37,60,N'Tùy Chọn','VC00001'),
	(73,94,N'Tùy chọn','VC00006')
go
set dateformat dmy
insert into Tre_Vaccin
values('T000001','VC00001','25/1/2020 8:00:00.12','25/1/2020 9:00:00.12','25/1/2020 10:00:00.12',N'Bình thường','NVTC001','BS00001'),
	('T000001','VC00001','25/2/2020 8:00:00','25/2/2020 9:00:00.12','25/2/2020 10:00:00.12',N'Bình thường','NVTC001','BS00002'),
	('T000001','VC00001','25/3/2020 8:00:00','25/3/2020 9:00:00.12','25/3/2020 10:00:00.12',N'Bình thường','NVTC002','BS00001'),
	('T000001','VC00006','11/1/2021 8:00:00','11/1/2021 8:30:00','11/1/2021 9:00:00',N'Bình thường','NVTC001','BS00001'),
	('T000001','VC00006','10/12/2022 13:00:00',NULL,NULL,NULL,NULL,NULL),
	('T000002','VC00001','22/3/2022 7:30:00','22/3/2022 7:40:00','22/3/2022 7:50:00',N'Bình thường','NVTC003','BS00003'),
	('T000002','VC00001','25/4/2022 7:00:00','22/3/2022 7:10:00','22/3/2022 7:20:00',N'Bình thường','NVTC003','BS00003'),
	('T000002','VC00001','10/12/2022 9:00:00',NULL,NULL,NULL,NULL,NULL)


