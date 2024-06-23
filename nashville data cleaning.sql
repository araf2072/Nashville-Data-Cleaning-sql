Select *
From nashville;



SELECT  saledate,
-- STR_TO_DATE(SaleDate, '%M %e, %Y') AS saleDateConverted,
DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %e, %Y'), '%d-%m-%Y') AS formattedSaleDate
From nashville;


select * from nashville
order by ParcelID;

SELECT a.ParcelID, a.PropertyAddress,
b.ParcelID, b.PropertyAddress,
COALESCE(a.PropertyAddress, b.PropertyAddress) AS MergedPropertyAddress
FROM nashville a
JOIN nashville b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

Select PropertyAddress
From nashville;

SELECT 
SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
SUBSTRING(PropertyAddress, CHAR_LENGTH(SUBSTRING_INDEX(PropertyAddress, ',', 1)) + 3) AS RestOfAddress
FROM nashville;

-- ALTER TABLE nashville
-- Add 'PropertySplitAddress' varchar(255);
ALTER TABLE nashville
ADD  PropertySplitAddress VARCHAR(255) not null ;


-- Rename the existing PropertySplitAddress column
ALTER TABLE Nashville
CHANGE COLUMN PropertySplitAddress OldPropertySplitAddress VARCHAR(255);

-- Add the new PropertySplitAddress column
ALTER TABLE Nashville
ADD COLUMN PropertySplitAddress VARCHAR(255) NOT NULL;

UPDATE Nashville
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);
select * from nashville;

Select OwnerAddress
From nashville;

SELECT 
SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -1) AS ownersplitstate,
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -2), '.', 1) AS ownersplitcity,
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -3), '.', 1) AS ownersplitaddress
FROM nashville;

ALTER TABLE Nashville
CHANGE COLUMN OwnerSplitAddress OldOwnerSplitAddress VARCHAR(255);

ALTER TABLE Nashville
ADD COLUMN ownersplitstate VARCHAR(255) NOT NULL;

UPDATE Nashville
SET ownersplitstate = SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -1);

select * from nashville;

ALTER TABLE nashville
DROP COLUMN OldOwnerSplitAddress,
DROP COLUMN OwnerSplitCity,
DROP COLUMN OwnerSplitAddress;

select * from nashville;



ALTER TABLE Nashville
ADD COLUMN ownersplitcity VARCHAR(255) NOT NULL;

UPDATE Nashville
SET ownersplitcity = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -2), '.', 1);

select * from nashville;

ALTER TABLE Nashville
ADD COLUMN ownersplitaddress VARCHAR(255) NOT NULL;
UPDATE Nashville
SET ownersplitaddress = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -3), '.', 1);

select * from nashville;

select distinct(SoldAsVacant), count(SoldAsVacant)
from nashville
Group by SoldAsVacant
order by 2;

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashville;

Update nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;
       
select SoldAsVacant

from nashville
where SoldAsVacant ='N'  ;      

WITH RowNumCTE AS(
Select *,ROW_NUMBER() OVER (PARTITION BY ParcelID,PropertyAddress,
SalePrice, SaleDate, LegalReference
ORDER BY UniqueID) row_num
From nashville)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

ALTER TABLE nashville
DROP COLUMN OwnerAddress, 
drop column TaxDistrict,
drop column PropertyAddress, 
drop column SaleDate


-- 125

