/*

Cleaning Data in SQL Queries

*/

SELECT * 
FROM HousingData

-- Standardize Dtae Format

SELECT SaleDate
FROM HousingData

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM HousingData

ALTER TABLE HousingData
ADD SaleDateConverted DATE

UPDATE HousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM HousingData


--Populate Propert Address Data

SELECT PropertyAddress
FROM HousingData
WHERE PropertyAddress IS NULL

SELECT *
FROM HousingData
WHERE PropertyAddress IS NULL

SELECT *
FROM HousingData
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM HousingData A
JOIN HousingData B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM HousingData A
JOIN HousingData B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

SELECT *
FROM HousingData
WHERE PropertyAddress IS NULL

-- Breaking out Address  into Individual Culumns (Address, City, State)

SELECT PropertyAddress
FROM HousingData

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS PropertyAdressLine1
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS PropertyAdressLine2
FROM HousingData

ALTER TABLE HousingData
ADD PropertyAdressLine1 VARCHAR(255)

UPDATE HousingData
SET PropertyAdressLine1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE HousingData
ADD PropertyAdressLine2 VARCHAR(255)

UPDATE HousingData
SET PropertyAdressLine2 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT PropertyAdressLine1, PropertyAdressLine2
FROM HousingData


SELECT OwnerAddress
FROM HousingData

SELECT 
PARSENAME (REPLACE (OwnerAddress,',','.'),3)
, PARSENAME (REPLACE (OwnerAddress,',','.'),2)
, PARSENAME (REPLACE (OwnerAddress,',','.'),1)
FROM HousingData


ALTER TABLE HousingData
ADD OwnersSplitAddress VARCHAR(255)

UPDATE HousingData
SET OwnersSplitAddress = PARSENAME (REPLACE (OwnerAddress,',','.'),3)

ALTER TABLE HousingData
ADD OwnersSplitCity VARCHAR(255)

UPDATE HousingData
SET OwnersSplitCity = PARSENAME (REPLACE (OwnerAddress,',','.'),2)

ALTER TABLE HousingData
ADD OwnersSplitState VARCHAR(255)

UPDATE HousingData
SET OwnersSplitState = PARSENAME (REPLACE (OwnerAddress,',','.'),1)


SELECT OwnersSplitAddress, OwnersSplitCity, OwnersSplitState
FROM HousingData


--Change Y and N to Yes and No in "SoldAsVacant" field


SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant


SELECT SoldAsVacant
,CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM HousingData


UPDATE HousingData
SET SoldAsVacant=(CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END)
		

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant


-- Remove Duplicates



WITH  RowNameCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY 
		UniqueID
		) row_num

FROM HousingData
)
SELECT *
FROM RowNameCTE
WHERE row_num>1




WITH  RowNameCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY 
		UniqueID
		) row_num

FROM HousingData
)
DELETE
FROM RowNameCTE
WHERE row_num>1


-- Delete Unused Column



SELECT *
FROM HousingData

ALTER TABLE HousingData
DROP COLUMN OwnerAddress, SaleDate, PropertyAddress, TaxDistrict
