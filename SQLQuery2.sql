-- Cleaning data in SQL Queries 
Select * 
From [Data Analysis].dbo.[Nashville Housing]


--- Standadize Date Format 
Select SaleDateConverted, convert(Date, SaleDate)
From [Data Analysis].dbo.[Nashville Housing]

Update [Nashville Housing]
Set SaleDate = CONVERT(Date,SaleDate)

Alter Table  [Nashville Housing] 
 add SaleDateConverted Date;

 Update [Nashville Housing]
Set SaleDateConverted = Convert(Date,SaleDate)

-- Populate Propety address Data

Select *
From [Data Analysis].dbo.[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID ,a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From [Data Analysis].dbo.[Nashville Housing] a
join [Data Analysis].dbo.[Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Data Analysis].dbo.[Nashville Housing] a
join [Data Analysis].dbo.[Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null




--- Breaking out Address into individual Coulmns (address, city , state)
Select PropertyAddress
From [Data Analysis].dbo.[Nashville Housing]

Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as address
,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as address

From [Data Analysis].dbo.[Nashville Housing]

Alter Table  [Nashville Housing] 
 add PropertySplitAddress Nvarchar(255) ;

Update [Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

Alter Table  [Nashville Housing] 
 add PropertySplitCity Nvarchar(255) ;


Update [Nashville Housing]
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


Select *
From [Data Analysis].dbo.[Nashville Housing]



Select OwnerAddress
From [Data Analysis].dbo.[Nashville Housing]

--- Note Parsename does task in the backward direction so we write 3, 2 ,1---

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

--Splitting Address---

Alter Table  [Nashville Housing] 
 add OwnerSplitAddress Nvarchar(255) ;

Update [Nashville Housing]
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

--Splitting city---

Alter Table  [Nashville Housing] 
 add OwnerSplitCity Nvarchar(255) ;

Update [Nashville Housing]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


--Splitting State---
Alter Table  [Nashville Housing] 
 add OwnerSplitState Nvarchar(255) 

Update [Nashville Housing]
set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)



---- Change Y and N to Yes and NO in Sold as Vacant field 


Select Distinct (SoldASVacant), count (SoldAsVacant)
From [Data Analysis].dbo.[Nashville Housing]
group by SoldAsVacant
 order by 2 

 Select SoldASVacant
 ,Case When SoldASVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   Else SoldASVacant
	   END
From [Data Analysis].dbo.[Nashville Housing]


Update [Nashville Housing] 
Set SoldAsVacant = Case When SoldASVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   Else SoldASVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

 From [Data Analysis].dbo.[Nashville Housing]
--order by ParcelID
)
Select * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



--- Delete Unused Columns 

select*
From [Data Analysis].dbo.[Nashville Housing]

ALter Table [Data Analysis].dbo.[Nashville Housing]
Drop Column OwnerAddress, TaxDistrict ,PropertyAddress, SaleDate