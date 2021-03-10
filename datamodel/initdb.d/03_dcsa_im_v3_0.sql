\set ON_ERROR_STOP true
\connect dcsa_openapi

BEGIN;

/* Create Tables */



/* Shipment related Entities */


/* Transport Document related Entities */


/* Address Entity */


DROP TABLE IF EXISTS dcsa_ebl_v1_0.address CASCADE;
CREATE TABLE dcsa_ebl_v1_0.address (
	id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
	name varchar(100) NULL,
	street varchar(100) NULL,
	street_number varchar(50) NULL,
	floor varchar(50) NULL,
	postal_code varchar(10) NULL,
	city varchar(65) NULL,
	state_region varchar(65) NULL,
	country varchar(75) NULL
);


/* Party related Entities */


DROP TABLE IF EXISTS dcsa_ebl_v1_0.party CASCADE;
CREATE TABLE dcsa_ebl_v1_0.party (
	id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
	party_name varchar(100) NULL,
	tax_reference_1 varchar(20) NULL,
	tax_reference_2 varchar(20) NULL,
	public_key varchar(500) NULL,
    address_id uuid NULL REFERENCES dcsa_ebl_v1_0.address (id),
	nmfta_code varchar(4) NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.party_function CASCADE;
CREATE TABLE dcsa_ebl_v1_0.party_function (
    party_function_code varchar(3) PRIMARY KEY,
    party_function_name varchar(100) NOT NULL,
    party_function_description varchar(250) NOT NULL
);


-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.displayed_address CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.displayed_address (
--     -- Same key as document_party
--     party_id uuid NOT NULL REFERENCES dcsa_ebl_v1_0.party (id),
--     shipment_id uuid NULL REFERENCES dcsa_ebl_v1_0.shipment (id),
--     shipping_instruction_id uuid NULL REFERENCES dcsa_ebl_v1_0.shipping_instruction (id),
--     party_function varchar(3) NOT NULL REFERENCES dcsa_ebl_v1_0.party_function (party_function_code),

--     address_line varchar(250) NOT NULL,
--     address_line_number int NOT NULL
-- );
-- CREATE INDEX ON dcsa_ebl_v1_0.displayed_address (party_id, party_function);
-- CREATE INDEX ON dcsa_ebl_v1_0.displayed_address (shipment_id);
-- CREATE INDEX ON dcsa_ebl_v1_0.displayed_address (shipping_instruction_id);


DROP TABLE IF EXISTS dcsa_ebl_v1_0.carrier CASCADE;
CREATE TABLE dcsa_ebl_v1_0.carrier (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    carrier_name varchar(100),
    smdg_code varchar(3) NULL,
    nmfta_code varchar(4) NULL
);


/* Charges related Entities */


/* Equipment related Entities */


/* Stuffing related Entities */


/* Location related Entities */

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.shipment_location_type CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.shipment_location_type (
-- 	location_type_code varchar(3) PRIMARY KEY,
-- 	location_type_description varchar(50) NOT NULL
-- );

DROP TABLE IF EXISTS dcsa_ebl_v1_0.country CASCADE;
CREATE TABLE dcsa_ebl_v1_0.country (
	country_code varchar(2) PRIMARY KEY,
	country_name varchar(75) NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.un_location CASCADE;
CREATE TABLE dcsa_ebl_v1_0.un_location (
	un_location_code char(5) PRIMARY KEY,
	un_location_name varchar(100) NULL,
	location_code char(3) NULL,
	country_code char(2) NULL REFERENCES dcsa_ebl_v1_0.country (country_code)
);
-- Supporting FK constraints
CREATE INDEX ON dcsa_ebl_v1_0.un_location (country_code);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.location CASCADE;
CREATE TABLE dcsa_ebl_v1_0.location (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    location_name varchar(100) NULL,
    address_id uuid NULL REFERENCES dcsa_ebl_v1_0.address (id),
	latitude varchar(10) NULL,
	longitude varchar(11) NULL,
	un_location_code char(5) NULL REFERENCES dcsa_ebl_v1_0.un_location (un_location_code)
);
-- Supporting FK constraints
CREATE INDEX ON dcsa_ebl_v1_0.location (un_location_code);

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.shipment_location CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.shipment_location (
-- 	shipment_id uuid NOT NULL REFERENCES dcsa_ebl_v1_0.shipment (id),
-- 	location_id uuid NOT NULL REFERENCES dcsa_ebl_v1_0.location (id),
-- 	location_type varchar(3) NOT NULL REFERENCES dcsa_ebl_v1_0.shipment_location_type (location_type_code),
-- 	displayed_name varchar(250),
-- 	UNIQUE (location_id, location_type, shipment_id)
-- );

-- -- Supporting FK constraints
-- -- Note the omission of INDEX for "location_id" is deliberate; we rely on the implicit INDEX from the
-- -- UNIQUE constraint for that.
-- CREATE INDEX ON dcsa_ebl_v1_0.shipment_location (location_type);
-- CREATE INDEX ON dcsa_ebl_v1_0.shipment_location (shipment_id);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.facility CASCADE;
CREATE TABLE dcsa_ebl_v1_0.facility (
    facility_code varchar(11) PRIMARY KEY,
    facility_name varchar(100) NULL,
    code_list_provider_code varchar(6) NULL,
    code_list_provider varchar(8) NULL,
    un_location_code varchar(5) NULL,
    latitude varchar(10) NULL,
    longitude varchar(11) NULL,
    address varchar(250) NULL,
    facility_type_code varchar(4) NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.facility_type CASCADE;
CREATE TABLE dcsa_ebl_v1_0.facility_type (
    facility_type_code varchar(4) PRIMARY KEY,
    facility_type_name varchar(100) NULL,
    facility_type_description varchar(250) NULL
);


/* Transport related Entities */


DROP TABLE IF EXISTS dcsa_ebl_v1_0.mode_of_transport CASCADE;
CREATE TABLE dcsa_ebl_v1_0.mode_of_transport (
	mode_of_transport_code varchar(3) PRIMARY KEY,
	mode_of_transport_name varchar(100) NULL,
	mode_of_transport_description varchar(250) NULL,
	dcsa_transport_type varchar(50) NULL UNIQUE
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.transport CASCADE;
CREATE TABLE dcsa_ebl_v1_0.transport (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
	transport_reference varchar(50) NULL,
	transport_name varchar(100) NULL,
	mode_of_transport varchar(3) NULL,
	load_transport_call_id uuid NOT NULL,
	discharge_transport_call_id uuid NOT NULL,
	vessel varchar(7) NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.vessel CASCADE;
CREATE TABLE dcsa_ebl_v1_0.vessel (
	vessel_imo_number varchar(7) PRIMARY KEY,
	vessel_name varchar(35) NULL,
	vessel_flag char(2) NULL,
	vessel_call_sign_number varchar(10) NULL,
	vessel_operator_carrier_id uuid NULL
);

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.shipment_transport CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.shipment_transport (
-- 	shipment_id uuid NOT NULL,
-- 	transport_id uuid NOT NULL,
-- 	sequence_number integer NOT NULL,
-- 	commercial_voyage_id uuid,
-- 	isUnderShippersResponsibility boolean NOT NULL
-- );


/* Events related Entities */

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.event CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.event (
--     event_id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
--     event_type text NOT NULL,
--     event_classifier_code varchar(3) NOT NULL,
--     event_date_time timestamp with time zone NOT NULL,
--     event_type_code varchar(4) NOT NULL
-- );

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.equipment_event CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.equipment_event (
--     equipment_reference varchar(15),
--     empty_indicator_code text NOT NULL,
--     transport_call_id uuid NOT NULL
-- ) INHERITS (dcsa_ebl_v1_0.event);

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.shipment_event CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.shipment_event (
--     shipment_id uuid NOT NULL,
--     shipment_information_type_code varchar(3) NOT NULL
-- ) INHERITS (dcsa_ebl_v1_0.event);

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.transport_event CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.transport_event (
--     delay_reason_code varchar(3),
--     vessel_schedule_change_remark varchar(250),
--     transport_call_id uuid NOT NULL
-- ) INHERITS (dcsa_ebl_v1_0.event);

-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.event_subscription CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.event_subscription (
--     id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
--     callback_url text NOT NULL,
--     event_type text, --This field must be able to contain multiple event types. Currently it does not.
--     booking_reference varchar(35),
--     transport_document_id varchar(20),
--     transport_document_type text,
--     equipment_reference varchar(15),
--     schedule_id uuid NULL,
--     transport_call_id uuid NULL
--     );

-- --Helper table in order to filter Events on schedule_id
-- DROP TABLE IF EXISTS dcsa_ebl_v1_0.schedule CASCADE;
-- CREATE TABLE dcsa_ebl_v1_0.schedule (
--     id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
--     vessel_operator_carrier_code varchar(10) NOT NULL,
--     vessel_operator_carrier_code_list_provider text NOT NULL,
--     vessel_partner_carrier_code varchar(10) NOT NULL,
--     vessel_partner_carrier_code_list_provider text,
--     start_date date,
--     date_range text
-- );


/* Vessel Sharing Agreement related Entities */




/* Service related Entities */




/* Transport Journey related Entities */


DROP TABLE IF EXISTS dcsa_ebl_v1_0.transport_call CASCADE;
CREATE TABLE dcsa_ebl_v1_0.transport_call (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
	transport_call_sequence_number integer,
	facility_code varchar(11) NULL,
	facility_type_code char(4) NULL,
	other_facility varchar(50) NULL,
	customer_address varchar(250) NULL,
	location_id uuid NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.voyage CASCADE;
CREATE TABLE dcsa_ebl_v1_0.voyage (
	id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
	carrier_voyage_number varchar(50) NULL,
	service_id uuid NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.transport_call_voyage CASCADE;
CREATE TABLE dcsa_ebl_v1_0.transport_call_voyage (
	voyage_id uuid NOT NULL,
	transport_call_id uuid NOT NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.commercial_voyage CASCADE;
CREATE TABLE dcsa_ebl_v1_0.commercial_voyage (
	commercial_voyage_id uuid PRIMARY KEY,
	commercial_voyage_name text NOT NULL
);

DROP TABLE IF EXISTS dcsa_ebl_v1_0.commercial_voyage_transport_call CASCADE;
CREATE TABLE dcsa_ebl_v1_0.commercial_voyage_transport_call (
	transport_call_id uuid NOT NULL,
	commercial_voyage_id uuid NOT NULL
);


/* Create Foreign Key Constraints (Not implemented yet) */


COMMIT;
