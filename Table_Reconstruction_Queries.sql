Select
e.type,
e.sqft,
e.sqm,
e.price,
e.payment_method,
e.governorate,
e.city,
e.Area,
e.down_payment,
e.bedroomscc,
e.bathroomscc,
e.available_from,
e.location,
e.description
From egypt_real_estate_dim as e;

----------------------------------------------------------------------------------------------

--Change type
ALTER TABLE egypt_real_estate_dim
ALTER COLUMN type TYPE VARCHAR(50);

----------------------------------------------------------------------------------------------

--Add Column
ALTER TABLE egypt_real_estate_dim
Add COLUMN sqft  decimal,
Add COLUMN sqm  decimal;

----------------------------------------------------------------------------------------------

--Update new columns
    Update egypt_real_estate_dim
SET sqft = regexp_replace(split_part(size,'/',1),'[^0-9.]','','g') :: decimal,
    sqm = regexp_replace(split_part(size,'/',2),'[^0-9.]','','g') :: decimal;

----------------------------------------------------------------------------------------------

--Drop Old Coulmn
ALTER TABLE egypt_real_estate_dim
Drop Column size;

----------------------------------------------------------------------------------------------

--Update Column
Update egypt_real_estate_dim
Set price = replace(replace(price,',',''),' ','');

----------------------------------------------------------------------------------------------


--Change Type 
ALTER TABLE egypt_real_estate_dim
ALTER COLUMN price TYPE int
USING trim(price)::int;


----------------------------------------------------------------------------------------------

--Change Type
ALTER TABLE egypt_real_estate_dim
Alter Column payment_method type VARCHAR(60);

----------------------------------------------------------------------------------------------

--Add Coulmn
ALTER TABLE egypt_real_estate_dim
add COLUMN governorate VARCHAR(50)

----------------------------------------------------------------------------------------------

--Put in Cloumn Govermnate
update egypt_real_estate_dim
set governorate = trim(split_part(location,',',array_length(regexp_split_to_array(location, ','), 1)))

----------------------------------------------------------------------------------------------

--Add Coulmn
Alter TABLE egypt_real_estate_dim
ADD Column city VARCHAR(100) 

----------------------------------------------------------------------------------------------

--Put in Coulmn City
Update egypt_real_estate_dim
Set city = trim(split_part(location,',',array_length(regexp_split_to_array(location,','),1)-1))

----------------------------------------------------------------------------------------------

--Add Column 
Alter TABLE egypt_real_estate_dim
ADD COLUMN Area VARCHAR(100)

----------------------------------------------------------------------------------------------

--Put in Column Area
UPDATE egypt_real_estate_dim
SET area = TRIM(
    CASE 
        WHEN array_length(regexp_split_to_array(location, ','), 1) = 3 
            THEN split_part(location, ',', 1)
        WHEN array_length(regexp_split_to_array(location, ','), 1) = 4 
            THEN split_part(location, ',', 2)
    END
);

----------------------------------------------------------------------------------------------

--Edit Coulmn
UPDATE egypt_real_estate_dim
SET  down_payment = replace(down_payment,'EGP','');

----------------------------------------------------------------------------------------------

--Alter Type 
ALTER TABLE egypt_real_estate_dim
Alter Column down_payment type  int
USING trim(down_payment)::int;

----------------------------------------------------------------------------------------------

--drop table bedrooms because i made alternative cloumn bedroomscc
ALTER TABLE egypt_real_estate_dim
Drop column bedrooms;

----------------------------------------------------------------------------------------------

--drop table bathrooms because i made alternative cloumn bathroomscc
ALTER TABLE egypt_real_estate_dim
Drop column bathrooms;

----------------------------------------------------------------------------------------------

--Rename Column
Alter TABLE egypt_real_estate_dim 
rename column available_from to Posted_Date

----------------------------------------------------------------------------------------------

--Delete Row that all its cells = null
DELETE FROM egypt_real_estate_dim
WHERE location IS NULL
  AND governorate IS NULL
  AND price IS NULL
  AND sqft IS NULL
  AND sqm IS NULL;
