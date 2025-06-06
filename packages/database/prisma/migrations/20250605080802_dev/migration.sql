BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Appointment] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Appointment_ID] DEFAULT newid(),
    [type] VARCHAR(50) NOT NULL,
    [title] VARCHAR(255),
    [is_all_day] BIT NOT NULL CONSTRAINT [DF_Appointment_IsAllDay] DEFAULT 0,
    [start_date] DATETIME2 NOT NULL,
    [end_date] DATETIME2 NOT NULL,
    [location_id] UNIQUEIDENTIFIER,
    [created_by] UNIQUEIDENTIFIER NOT NULL,
    [status] VARCHAR(100) NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER,
    [appointment_fee] DECIMAL(32,16),
    [service_id] UNIQUEIDENTIFIER,
    [is_recurring] BIT NOT NULL CONSTRAINT [DF_Appointment_IsRecurring] DEFAULT 0,
    [recurring_rule] TEXT,
    [cancel_appointments] BIT,
    [notify_cancellation] BIT,
    [recurring_appointment_id] UNIQUEIDENTIFIER,
    [client_group_id] UNIQUEIDENTIFIER,
    [adjustable_amount] DECIMAL(32,16),
    [superbill_id] UNIQUEIDENTIFIER,
    [write_off] DECIMAL(32,16),
    CONSTRAINT [Appointment_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[AppointmentTag] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_AppointmentTag_ID] DEFAULT newid(),
    [appointment_id] UNIQUEIDENTIFIER NOT NULL,
    [tag_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_AppointmentTag_ID] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [UQ_AppointmentTag_Appointment_Tag] UNIQUE NONCLUSTERED ([appointment_id],[tag_id])
);

-- CreateTable
CREATE TABLE [dbo].[Audit] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Audit_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER,
    [user_id] UNIQUEIDENTIFIER,
    [datetime] DATETIME NOT NULL CONSTRAINT [DF__Audit__datetime__17ED6F58] DEFAULT CURRENT_TIMESTAMP,
    [event_type] NCHAR(10),
    [event_text] NVARCHAR(255) NOT NULL,
    [is_hipaa] BIT NOT NULL CONSTRAINT [DF_Audit_IsHipaa] DEFAULT 0,
    CONSTRAINT [PK_Audit_ID] PRIMARY KEY CLUSTERED ([Id])
);

-- CreateTable
CREATE TABLE [dbo].[Availability] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Availability_ID] DEFAULT newid(),
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [created_at] DATETIME2 NOT NULL CONSTRAINT [DF_Availability_CreatedAt] DEFAULT CURRENT_TIMESTAMP,
    [updated_at] DATETIME2 NOT NULL,
    [is_recurring] BIT NOT NULL CONSTRAINT [DF_Availability_IsRecurring] DEFAULT 0,
    [recurring_rule] TEXT,
    [end_time] DATETIME2 NOT NULL CONSTRAINT [DF_Availability_EndTime] DEFAULT CURRENT_TIMESTAMP,
    [start_time] DATETIME2 NOT NULL CONSTRAINT [DF_Availability_StartTime] DEFAULT CURRENT_TIMESTAMP,
    [end_date] DATETIME2 NOT NULL CONSTRAINT [DF_Availability_EndDate] DEFAULT CURRENT_TIMESTAMP,
    [start_date] DATETIME2 NOT NULL CONSTRAINT [DF_Availability_StartDate] DEFAULT CURRENT_TIMESTAMP,
    [title] TEXT NOT NULL,
    [allow_online_requests] BIT NOT NULL CONSTRAINT [DF_Availability_AllowOnlineRequests] DEFAULT 0,
    [location_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [Availability_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Client] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Client_ID] DEFAULT newid(),
    [legal_first_name] VARCHAR(100) NOT NULL,
    [legal_last_name] VARCHAR(100) NOT NULL,
    [is_waitlist] BIT NOT NULL CONSTRAINT [DF_Client_IsWaitlist] DEFAULT 0,
    [primary_clinician_id] UNIQUEIDENTIFIER,
    [primary_location_id] UNIQUEIDENTIFIER,
    [created_at] DATETIME2 NOT NULL CONSTRAINT [DF__Client__created___2FFA0313] DEFAULT CURRENT_TIMESTAMP,
    [is_active] BIT NOT NULL CONSTRAINT [DF_Client_IsActive] DEFAULT 1,
    [preferred_name] VARCHAR(100),
    [date_of_birth] DATE,
    [allow_online_appointment] BIT NOT NULL CONSTRAINT [DF_Client_allow_online_appointment] DEFAULT 0,
    [access_billing_documents] BIT NOT NULL CONSTRAINT [DF_Client_access_billing_documents] DEFAULT 0,
    [use_secure_messaging] BIT NOT NULL CONSTRAINT [DF_Client_use_secure_messaging] DEFAULT 0,
    [referred_by] VARCHAR(200),
    CONSTRAINT [Client_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientProfile] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_ClientProfile_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [middle_name] VARCHAR(50),
    [gender] VARCHAR(50),
    [gender_identity] VARCHAR(50),
    [relationship_status] VARCHAR(50),
    [employment_status] VARCHAR(50),
    [race_ethnicity] TEXT,
    [race_ethnicity_details] VARCHAR(50),
    [preferred_language] VARCHAR(50),
    [notes] TEXT,
    CONSTRAINT [ClientProfile_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [ClientProfile_client_id_key] UNIQUE NONCLUSTERED ([client_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientAdress] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_ClientAddress_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [address_line1] VARCHAR(255) NOT NULL,
    [address_line2] VARCHAR(255) NOT NULL,
    [zip_code] VARCHAR(50) NOT NULL,
    [city] VARCHAR(50) NOT NULL,
    [state] VARCHAR(50) NOT NULL,
    [country] VARCHAR(50) NOT NULL,
    [is_primary] BIT NOT NULL CONSTRAINT [DF_ClientAddress_IsPrimary] DEFAULT 0,
    CONSTRAINT [ClientAdress_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientContact] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_ClientContact_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [is_primary] BIT NOT NULL CONSTRAINT [DF_ClientContact_IsPrimary] DEFAULT 0,
    [permission] VARCHAR(50) NOT NULL,
    [contact_type] VARCHAR(50) NOT NULL,
    [type] VARCHAR(50) NOT NULL,
    [value] VARCHAR(255) NOT NULL,
    CONSTRAINT [ClientContact_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientGroup] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [type] VARCHAR(150) NOT NULL,
    [name] VARCHAR(250) NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER,
    [is_active] BIT NOT NULL CONSTRAINT [DF_ClientGroup_IsActive] DEFAULT 1,
    [available_credit] DECIMAL(32,16) NOT NULL CONSTRAINT [ClientGroup_available_credit_df] DEFAULT 0,
    [created_at] DATETIME2 CONSTRAINT [ClientGroup_created_at] DEFAULT CURRENT_TIMESTAMP,
    [auto_monthly_statement_enabled] BIT CONSTRAINT [DF_ClientGroup_auto_monthly_statement_enabled] DEFAULT 0,
    [auto_monthly_superbill_enabled] BIT CONSTRAINT [DF_ClientGroup_auto_monthly_superbill_enabled] DEFAULT 0,
    [first_seen_at] DATETIME2 CONSTRAINT [ClientGroup_first_seen_at] DEFAULT CURRENT_TIMESTAMP,
    [notes] TEXT,
    CONSTRAINT [PK_ClientGroup_ID] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientGroupMembership] (
    [client_group_id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_ClientGroupMembership_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [role] VARCHAR(50),
    [created_at] DATETIME2 NOT NULL CONSTRAINT [DF__GroupClie__creat__6EEB59C5] DEFAULT CURRENT_TIMESTAMP,
    [is_contact_only] BIT NOT NULL CONSTRAINT [DF_ClientGroupMembership_IsContactOnly] DEFAULT 0,
    [is_responsible_for_billing] BIT,
    [is_emergency_contact] BIT CONSTRAINT [DF_ClientGroupMembership_IsEmergencyContactOnly] DEFAULT 0,
    CONSTRAINT [PK_ClientGroupMembership_ID] PRIMARY KEY CLUSTERED ([client_group_id],[client_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientReminderPreference] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_ClientReminderPreference_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [reminder_type] VARCHAR(100) NOT NULL,
    [is_enabled] BIT NOT NULL CONSTRAINT [DF_ClientReminderPreference_IsEnabled] DEFAULT 1,
    [channel] NVARCHAR(1000) NOT NULL,
    [contact_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [ClientReminderPreference_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [ClientReminderPreference_client_id_reminder_type_channel_key] UNIQUE NONCLUSTERED ([client_id],[reminder_type],[channel])
);

-- CreateTable
CREATE TABLE [dbo].[BillingAddress] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_BillingAddress_ID] DEFAULT newid(),
    [street] VARCHAR(255) NOT NULL,
    [city] VARCHAR(100) NOT NULL,
    [state] VARCHAR(50) NOT NULL,
    [zip] VARCHAR(20) NOT NULL,
    [type] VARCHAR(50) NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [BillingAddress_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [UQ_BillingAddress_Clinician_Type] UNIQUE NONCLUSTERED ([clinician_id],[type])
);

-- CreateTable
CREATE TABLE [dbo].[Clinician] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Clinician_ID] DEFAULT newid(),
    [user_id] UNIQUEIDENTIFIER NOT NULL,
    [address] TEXT NOT NULL,
    [percentage_split] FLOAT(53) NOT NULL,
    [is_active] BIT NOT NULL CONSTRAINT [DF_Clinician_IsActive] DEFAULT 1,
    [first_name] VARCHAR(100) NOT NULL,
    [last_name] VARCHAR(100) NOT NULL,
    [speciality] VARCHAR(250),
    [NPI_number] VARCHAR(250),
    [taxonomy_code] VARCHAR(250),
    CONSTRAINT [Clinician_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Clinician_user_id_key] UNIQUE NONCLUSTERED ([user_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClinicianClient] (
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [is_primary] BIT NOT NULL CONSTRAINT [DF_ClinicianClient_IsPrimary] DEFAULT 0,
    [assigned_date] DATETIME2 NOT NULL CONSTRAINT [DF__Clinician__assig__430CD787] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [PK_ClinicianClient_ID] PRIMARY KEY CLUSTERED ([client_id],[clinician_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClinicianLocation] (
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [location_id] UNIQUEIDENTIFIER NOT NULL,
    [is_primary] BIT NOT NULL CONSTRAINT [DF_ClinicianLocation_IsPrimary] DEFAULT 0,
    CONSTRAINT [PK_ClinicianLocation_ID] PRIMARY KEY CLUSTERED ([clinician_id],[location_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClinicianServices] (
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [service_id] UNIQUEIDENTIFIER NOT NULL,
    [custom_rate] DECIMAL(32,16),
    [is_active] BIT NOT NULL CONSTRAINT [DF_ClinicianServices_IsActive] DEFAULT 1,
    CONSTRAINT [PK_ClinicianServices_ID] PRIMARY KEY CLUSTERED ([clinician_id],[service_id])
);

-- CreateTable
CREATE TABLE [dbo].[CreditCard] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_CreditCard_ID] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [card_type] VARCHAR(50) NOT NULL,
    [last_four] VARCHAR(4) NOT NULL,
    [expiry_month] INT NOT NULL,
    [expiry_year] INT NOT NULL,
    [cardholder_name] VARCHAR(100) NOT NULL,
    [is_default] BIT NOT NULL CONSTRAINT [DF_CreditCard_IsDefault] DEFAULT 0,
    [billing_address] TEXT,
    [token] VARCHAR(255),
    [created_at] DATETIME2 NOT NULL CONSTRAINT [DF__CreditCar__creat__01FE2E39] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [CreditCard_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Invoice] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Invoice_ID] DEFAULT newid(),
    [invoice_number] VARCHAR(50) NOT NULL,
    [client_group_id] UNIQUEIDENTIFIER,
    [appointment_id] UNIQUEIDENTIFIER,
    [clinician_id] UNIQUEIDENTIFIER,
    [issued_date] DATETIME2 NOT NULL CONSTRAINT [DF__Invoice__issued___7D39791C] DEFAULT CURRENT_TIMESTAMP,
    [due_date] DATETIME2 NOT NULL,
    [amount] DECIMAL(10,2) NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [type] VARCHAR(50) NOT NULL,
    [client_info] TEXT,
    [notes] TEXT,
    [provider_info] TEXT,
    [service_description] TEXT,
    [is_exported] BIT NOT NULL CONSTRAINT [DF_Invoice_is_exported] DEFAULT 0,
    CONSTRAINT [Invoice_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Location] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Location_ID] DEFAULT newid(),
    [name] VARCHAR(255) NOT NULL,
    [address] TEXT NOT NULL,
    [is_active] BIT NOT NULL CONSTRAINT [DF_Location_IsActive] DEFAULT 1,
    [city] VARCHAR(100),
    [color] VARCHAR(50),
    [state] VARCHAR(100),
    [street] VARCHAR(255),
    [zip] VARCHAR(20),
    CONSTRAINT [Location_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Payment] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Payment_ID] DEFAULT newid(),
    [invoice_id] UNIQUEIDENTIFIER NOT NULL,
    [payment_date] DATETIME2 NOT NULL CONSTRAINT [DF__Payment__payment__05CEBF1D] DEFAULT CURRENT_TIMESTAMP,
    [amount] DECIMAL(10,2) NOT NULL,
    [credit_card_id] UNIQUEIDENTIFIER,
    [transaction_id] VARCHAR(100),
    [status] VARCHAR(50) NOT NULL,
    [response] TEXT,
    [credit_applied] DECIMAL(10,2),
    CONSTRAINT [Payment_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[PracticeService] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_PracticeService_ID] DEFAULT newid(),
    [type] VARCHAR(255) NOT NULL,
    [rate] DECIMAL(10,2) NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [description] TEXT,
    [duration] INT NOT NULL,
    [color] VARCHAR(7),
    [allow_new_clients] BIT NOT NULL CONSTRAINT [PracticeService_allow_new_clients_df] DEFAULT 0,
    [available_online] BIT NOT NULL CONSTRAINT [PracticeService_available_online_df] DEFAULT 0,
    [bill_in_units] BIT NOT NULL CONSTRAINT [PracticeService_bill_in_units_df] DEFAULT 0,
    [block_after] INT NOT NULL CONSTRAINT [PracticeService_block_after_df] DEFAULT 0,
    [block_before] INT NOT NULL CONSTRAINT [PracticeService_block_before_df] DEFAULT 0,
    [is_default] BIT NOT NULL CONSTRAINT [PracticeService_is_default_df] DEFAULT 0,
    [require_call] BIT NOT NULL CONSTRAINT [PracticeService_require_call_df] DEFAULT 0,
    CONSTRAINT [PracticeService_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Role] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_Role_ID] DEFAULT newid(),
    [name] VARCHAR(255) NOT NULL,
    [description] TEXT,
    CONSTRAINT [Role_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Role_name_key] UNIQUE NONCLUSTERED ([name])
);

-- CreateTable
CREATE TABLE [dbo].[SurveyAnswers] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_SurveyAnswers_ID] DEFAULT newid(),
    [template_id] UNIQUEIDENTIFIER NOT NULL,
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [content] TEXT,
    [frequency] NCHAR(10),
    [completed_at] DATETIME2,
    [assigned_at] DATETIME2 NOT NULL CONSTRAINT [DF__ClientDoc__assig__4D8A65FA] DEFAULT CURRENT_TIMESTAMP,
    [expiry_date] DATETIME2,
    [is_intake] BIT NOT NULL CONSTRAINT [DF_SurveyAnswers_is_intake] DEFAULT 0,
    [status] VARCHAR(100) NOT NULL,
    [appointment_id] UNIQUEIDENTIFIER,
    [is_signed] BIT,
    [is_locked] BIT,
    CONSTRAINT [PK_SurveyAnswers_ID] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[SurveyTemplate] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_SurveyTemplate_ID] DEFAULT newid(),
    [name] VARCHAR(255) NOT NULL,
    [content] TEXT NOT NULL,
    [frequency_options] NCHAR(10),
    [is_active] BIT NOT NULL CONSTRAINT [DF_SurveyTemplate_IsActive] DEFAULT 1,
    [created_at] DATETIME2 NOT NULL CONSTRAINT [DF__DocumentT__creat__35B2DC69] DEFAULT CURRENT_TIMESTAMP,
    [description] TEXT,
    [updated_at] DATETIME2 NOT NULL,
    [type] VARCHAR(100) NOT NULL,
    [is_default] BIT NOT NULL CONSTRAINT [DF_SurveyTemplate_is_default] DEFAULT 0,
    [requires_signature] BIT NOT NULL CONSTRAINT [DF_SurveyTemplate_RequiresSignature] DEFAULT 0,
    [is_shareable] BIT NOT NULL CONSTRAINT [DF_SurveyTemplate_is_shareable] DEFAULT 0,
    CONSTRAINT [PK_SurveyTemplate_ID] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[sysdiagrams] (
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT NOT NULL IDENTITY(1,1),
    [version] INT,
    [definition] VARBINARY(max),
    CONSTRAINT [PK_sysdiagrams_ID] PRIMARY KEY CLUSTERED ([diagram_id]),
    CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED ([principal_id],[name])
);

-- CreateTable
CREATE TABLE [dbo].[Tag] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Tag_ID] DEFAULT newid(),
    [name] NVARCHAR(100) NOT NULL,
    [color] NVARCHAR(50),
    CONSTRAINT [PK_Tag_ID] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[User] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [User_id_df] DEFAULT newid(),
    [email] VARCHAR(255) NOT NULL,
    [password_hash] VARCHAR(255) NOT NULL,
    [last_login] DATETIME2,
    [date_of_birth] DATE,
    [phone] VARCHAR(20),
    [profile_photo] VARCHAR(500),
    CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [User_email_key] UNIQUE NONCLUSTERED ([email])
);

-- CreateTable
CREATE TABLE [dbo].[UserRole] (
    [user_id] UNIQUEIDENTIFIER NOT NULL,
    [role_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserRole_ID] PRIMARY KEY CLUSTERED ([user_id],[role_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClinicalInfo] (
    [id] INT NOT NULL IDENTITY(1,1),
    [speciality] NVARCHAR(1000) NOT NULL,
    [NPI_number] FLOAT(53) NOT NULL,
    [taxonomy_code] NVARCHAR(1000) NOT NULL,
    [user_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [ClinicalInfo_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[License] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_License_id] DEFAULT newid(),
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [license_type] NVARCHAR(1000) NOT NULL,
    [license_number] NVARCHAR(1000) NOT NULL,
    [expiration_date] DATETIME2 NOT NULL,
    [state] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [PK_License] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[PracticeInformation] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PracticeInformation_id_df] DEFAULT newid(),
    [clinician_id] UNIQUEIDENTIFIER,
    [practice_name] NVARCHAR(1000) NOT NULL,
    [practice_email] NVARCHAR(1000) NOT NULL,
    [time_zone] NVARCHAR(1000) NOT NULL,
    [practice_logo] NVARCHAR(1000) NOT NULL,
    [phone_numbers] NVARCHAR(1000) NOT NULL,
    [tele_health] BIT NOT NULL,
    CONSTRAINT [PracticeInformation_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[AppointmentLimit] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [AppointmentLimit_id_df] DEFAULT newid(),
    [date] DATE NOT NULL,
    [max_limit] INT NOT NULL CONSTRAINT [AppointmentLimit_max_limit_df] DEFAULT 10,
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [AppointmentLimit_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [AppointmentLimit_date_clinician_id_key] UNIQUE NONCLUSTERED ([date],[clinician_id])
);

-- CreateTable
CREATE TABLE [dbo].[EmailTemplate] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [EmailTemplate_id_df] DEFAULT newid(),
    [name] VARCHAR(255) NOT NULL,
    [subject] VARCHAR(255) NOT NULL,
    [content] TEXT NOT NULL,
    [type] VARCHAR(50) NOT NULL,
    [email_type] VARCHAR(250),
    [created_at] DATETIME2 NOT NULL CONSTRAINT [EmailTemplate_created_at_df] DEFAULT CURRENT_TIMESTAMP,
    [updated_at] DATETIME2 NOT NULL,
    [created_by] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [EmailTemplate_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Product] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [Product_id_df] DEFAULT newid(),
    [name] VARCHAR(255) NOT NULL,
    [price] DECIMAL(10,2) NOT NULL,
    CONSTRAINT [Product_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Permission] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [Permission_id_df] DEFAULT newid(),
    [name] VARCHAR(255) NOT NULL,
    [slug] VARCHAR(100) NOT NULL,
    CONSTRAINT [Permission_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Permission_slug_key] UNIQUE NONCLUSTERED ([slug])
);

-- CreateTable
CREATE TABLE [dbo].[RolePermission] (
    [role_id] UNIQUEIDENTIFIER NOT NULL,
    [permission_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RolePermission_ID] PRIMARY KEY CLUSTERED ([role_id],[permission_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientGroupFile] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [ClientGroupFile_id_df] DEFAULT newid(),
    [survey_template_id] UNIQUEIDENTIFIER,
    [title] VARCHAR(255) NOT NULL,
    [type] VARCHAR(50) NOT NULL CONSTRAINT [ClientGroupFile_type_df] DEFAULT 'PRACTICE_UPLOAD',
    [url] TEXT,
    [client_group_id] UNIQUEIDENTIFIER NOT NULL,
    [uploaded_by_id] UNIQUEIDENTIFIER,
    [created_at] DATETIME2 NOT NULL CONSTRAINT [ClientGroupFile_created_at_df] DEFAULT CURRENT_TIMESTAMP,
    [updated_at] DATETIME2 NOT NULL,
    CONSTRAINT [ClientGroupFile_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Statement] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [Statement_id_df] DEFAULT newid(),
    [statement_number] INT NOT NULL CONSTRAINT [Statement_statement_number_df] DEFAULT 0,
    [client_group_id] UNIQUEIDENTIFIER NOT NULL,
    [start_date] DATETIME2,
    [end_date] DATETIME2,
    [issued_date] DATETIME2,
    [beginning_balance] DECIMAL(10,2) NOT NULL,
    [invoices_total] DECIMAL(10,2) NOT NULL,
    [payments_total] DECIMAL(10,2) NOT NULL,
    [ending_balance] DECIMAL(10,2) NOT NULL,
    [provider_name] VARCHAR(255),
    [provider_email] VARCHAR(255),
    [provider_phone] VARCHAR(255),
    [client_group_name] VARCHAR(255) NOT NULL,
    [client_name] VARCHAR(255) NOT NULL,
    [client_email] VARCHAR(255),
    [created_at] DATETIME2 NOT NULL CONSTRAINT [Statement_created_at_df] DEFAULT CURRENT_TIMESTAMP,
    [created_by] UNIQUEIDENTIFIER,
    [is_exported] BIT NOT NULL CONSTRAINT [DF_Statement_is_exported] DEFAULT 0,
    CONSTRAINT [Statement_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Superbill] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [Superbill_id_df] DEFAULT newid(),
    [superbill_number] INT NOT NULL CONSTRAINT [Superbill_superbill_number_df] DEFAULT 0,
    [client_group_id] UNIQUEIDENTIFIER NOT NULL,
    [issued_date] DATETIME2 NOT NULL CONSTRAINT [Superbill_issued_date_df] DEFAULT CURRENT_TIMESTAMP,
    [provider_name] VARCHAR(255),
    [provider_email] VARCHAR(255),
    [provider_license] VARCHAR(100),
    [client_name] VARCHAR(255) NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [created_at] DATETIME2 NOT NULL CONSTRAINT [Superbill_created_at_df] DEFAULT CURRENT_TIMESTAMP,
    [created_by] UNIQUEIDENTIFIER,
    [is_exported] BIT NOT NULL CONSTRAINT [DF_Superbill_is_exported] DEFAULT 0,
    CONSTRAINT [Superbill_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[BillingSettings] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [BillingSettings_id_df] DEFAULT newid(),
    [clinician_id] UNIQUEIDENTIFIER,
    [autoInvoiceCreation] VARCHAR(50),
    [pastDueDays] INT,
    [emailClientPastDue] BIT,
    [invoiceIncludePracticeLogo] BIT,
    [invoiceFooterInfo] VARCHAR(120),
    [superbillDayOfMonth] INT,
    [superbillIncludePracticeLogo] BIT,
    [superbillIncludeSignatureLine] BIT,
    [superbillIncludeDiagnosisDescription] BIT,
    [superbillFooterInfo] VARCHAR(120),
    [billingDocEmailDelayMinutes] INT,
    [createMonthlyStatementsForNewClients] BIT,
    [createMonthlySuperbillsForNewClients] BIT,
    [defaultNotificationMethod] VARCHAR(50),
    [created_at] DATETIME2 NOT NULL CONSTRAINT [BillingSettings_created_at_df] DEFAULT CURRENT_TIMESTAMP,
    [updated_at] DATETIME2 NOT NULL,
    CONSTRAINT [BillingSettings_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [BillingSettings_clinician_id_key] UNIQUE NONCLUSTERED ([clinician_id])
);

-- CreateTable
CREATE TABLE [dbo].[AppointmentNotes] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [appointment_id] UNIQUEIDENTIFIER NOT NULL,
    [type] VARCHAR(50) NOT NULL,
    [survey_answer_id] UNIQUEIDENTIFIER NOT NULL,
    [created_by] UNIQUEIDENTIFIER,
    [is_signed] BIT NOT NULL CONSTRAINT [DF_AppointmentNotes_is_signed] DEFAULT 0,
    [unlocked_by] UNIQUEIDENTIFIER,
    [unlocked_time] DATETIME2,
    [signed_name] VARCHAR(250),
    [signed_credentials] VARCHAR(250),
    [signed_time] DATETIME2,
    [signed_ipaddress] VARCHAR(50),
    CONSTRAINT [PK_AppointmentNotes] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientBillingPreferences] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [client_group_id] UNIQUEIDENTIFIER NOT NULL,
    [email_generated_invoices] BIT NOT NULL CONSTRAINT [DF_ClientBillingPreferences_email_generated_invoices] DEFAULT 0,
    [email_generated_statements] BIT NOT NULL CONSTRAINT [DF_ClientBillingPreferences_email_generated_statements] DEFAULT 0,
    [email_generated_superbills] BIT NOT NULL CONSTRAINT [DF_ClientBillingPreferences_email_generated_superbills] DEFAULT 0,
    [notify_new_invoices] BIT NOT NULL CONSTRAINT [DF_ClientBillingPreferences_notify_new_invoices] DEFAULT 0,
    [notify_new_statements] BIT NOT NULL CONSTRAINT [DF_ClientBillingPreferences_notify_new_statements] DEFAULT 0,
    [notify_new_superbills] BIT NOT NULL CONSTRAINT [DF_ClientBillingPreferences_notify_new_superbills] DEFAULT 0,
    CONSTRAINT [PK_ClientBillingPreferences] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientFiles] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [client_group_file_id] UNIQUEIDENTIFIER NOT NULL,
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [survey_answers_id] UNIQUEIDENTIFIER,
    CONSTRAINT [PK_ClientFiles] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientGroupServices] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [client_group_id] UNIQUEIDENTIFIER NOT NULL,
    [service_id] UNIQUEIDENTIFIER NOT NULL,
    [custom_rate] DECIMAL(32,16) NOT NULL,
    CONSTRAINT [PK_ClientGroupServices] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Diagnosis] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF__Diagnosis__id__4F688CCB] DEFAULT newid(),
    [code] VARCHAR(50) NOT NULL,
    [description] VARCHAR(255) NOT NULL,
    CONSTRAINT [PK__Diagnosi__3213E83FF84A10BA] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[DiagnosisTreatmentPlan] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF__DiagnosisTre__id__5244F976] DEFAULT newid(),
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [created_at] DATETIME NOT NULL CONSTRAINT [DF__Diagnosis__creat__53391DAF] DEFAULT CURRENT_TIMESTAMP,
    [updated_at] DATETIME,
    [is_signed] NCHAR(10) CONSTRAINT [DF_DiagnosisTreatmentPlan_is_signed] DEFAULT '0',
    [title] VARCHAR(255) NOT NULL,
    [survey_answers_id] UNIQUEIDENTIFIER,
    CONSTRAINT [PK__Diagnosi__3213E83FDFE52E56] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[DiagnosisTreatmentPlanItem] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF__DiagnosisTre__id__58F1F705] DEFAULT newid(),
    [treatment_plan_id] UNIQUEIDENTIFIER NOT NULL,
    [diagnosis_id] UNIQUEIDENTIFIER NOT NULL,
    [custom_description] VARCHAR(255),
    CONSTRAINT [PK__Diagnosi__3213E83F425BBD2A] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[GoodFaithEstimate] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [client_id] UNIQUEIDENTIFIER NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [client_name] VARCHAR(100),
    [client_dob] DATE,
    [client_address] VARCHAR(250),
    [client_city] VARCHAR(100),
    [client_state] VARCHAR(100),
    [client_zip_code] INT,
    [client_phone] VARCHAR(50),
    [client_email] VARCHAR(100),
    [clinician_npi] VARCHAR(100),
    [clinician_tin] VARCHAR(100),
    [clinician_location_id] UNIQUEIDENTIFIER NOT NULL,
    [contact_person_id] UNIQUEIDENTIFIER,
    [clinician_phone] VARCHAR(50),
    [clinician_email] VARCHAR(50),
    [provided_date] DATETIME,
    [expiration_date] DATETIME,
    [service_start_date] DATE,
    [service_end_date] DATE,
    [total_cost] INT NOT NULL,
    CONSTRAINT [PK_GoodFaithEstimate] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[GoodFaithServices] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [good_faith_id] UNIQUEIDENTIFIER NOT NULL,
    [service_id] UNIQUEIDENTIFIER NOT NULL,
    [diagnosis_id] UNIQUEIDENTIFIER NOT NULL,
    [location_id] UNIQUEIDENTIFIER NOT NULL,
    [quantity] INT NOT NULL,
    [fee] INT NOT NULL,
    CONSTRAINT [PK_GoodFaithServices] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[StatementItem] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [statement_id] UNIQUEIDENTIFIER NOT NULL,
    [date] DATETIME2 NOT NULL,
    [description] VARCHAR(255) NOT NULL,
    [charges] INT NOT NULL,
    [payments] INT NOT NULL,
    [balance] INT NOT NULL,
    CONSTRAINT [PK_StatementItem] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[AppointmentRequests] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [client_id] UNIQUEIDENTIFIER,
    [service_id] UNIQUEIDENTIFIER NOT NULL,
    [appointment_for] VARCHAR(50),
    [reasons_for_seeking_care] TEXT,
    [mental_health_history] TEXT,
    [additional_notes] TEXT,
    [start_time] DATETIME NOT NULL,
    [end_time] DATETIME NOT NULL,
    [status] VARCHAR(250) NOT NULL,
    [received_date] DATETIME NOT NULL,
    [updated_at] DATETIME,
    CONSTRAINT [PK_AppointmentRequests] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[AvailabilityServices] (
    [availability_id] UNIQUEIDENTIFIER NOT NULL,
    [service_id] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_AvailabilityServices] PRIMARY KEY CLUSTERED ([availability_id],[service_id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientPortalSettings] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [clinician_id] UNIQUEIDENTIFIER NOT NULL,
    [is_enabled] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_is_client_portal_enabled] DEFAULT 0,
    [domain_url] VARCHAR(250),
    [is_appointment_requests_enabled] BIT,
    [appointment_start_times] VARCHAR(250),
    [request_minimum_notice] VARCHAR(250),
    [maximum_request_notice] VARCHAR(250),
    [allow_new_clients_request] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_allow_new_clients_request] DEFAULT 0,
    [requests_from_new_individuals] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_requests_from_new_individuals] DEFAULT 0,
    [requests_from_new_couples] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_requests_from_new_couples] DEFAULT 0,
    [requests_from_new_contacts] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_requests_from_new_contacts] DEFAULT 0,
    [is_prescreen_new_clinets] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_is_prescreen_new_clinets] DEFAULT 0,
    [card_for_appointment_request] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_card_for_appointment_request] DEFAULT 0,
    [is_upload_documents_allowed] BIT NOT NULL CONSTRAINT [DF_ClientPortalSettings_is_upload_documents_allowed] DEFAULT 0,
    [welcome_message] NVARCHAR(max),
    CONSTRAINT [PK_ClientPortalSettings] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[PracticeSettings] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [key] VARCHAR(250) NOT NULL,
    [value] NVARCHAR(max) NOT NULL,
    CONSTRAINT [PK_PracticeSettings] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ReminderTextTemplates] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [type] VARCHAR(250) NOT NULL,
    [content] TEXT NOT NULL,
    CONSTRAINT [PK_ReminderTextTemplates] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[RequestContactItems] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [appointment_request_id] UNIQUEIDENTIFIER NOT NULL,
    [type] VARCHAR(250) NOT NULL,
    [first_name] VARCHAR(250) NOT NULL,
    [last_name] VARCHAR(250) NOT NULL,
    [preferred_name] VARCHAR(250),
    [date_of_birth] DATE,
    [email] VARCHAR(250) NOT NULL,
    [phone] VARCHAR(250) NOT NULL,
    [payment_method] VARCHAR(250),
    [is_client_minor] BIT,
    CONSTRAINT [PK_RequestContactItems] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ClientPortalPermission] (
    [id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [PK_ClientPortalPermission_ID] DEFAULT newid(),
    [startTime] VARCHAR(5) NOT NULL,
    [endTime] VARCHAR(5) NOT NULL,
    [weeklyDisplay] VARCHAR(50) NOT NULL,
    [cancellationHours] INT,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DF_ClientPortalPermission_CreatedAt] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [ClientPortalPermission_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Widget] (
    [id] NVARCHAR(1000) NOT NULL,
    [type] NVARCHAR(1000) NOT NULL,
    [code] NVARCHAR(1000) NOT NULL,
    [created_at] DATETIME2 NOT NULL CONSTRAINT [Widget_created_at_df] DEFAULT CURRENT_TIMESTAMP,
    [updated_at] DATETIME2 NOT NULL,
    CONSTRAINT [Widget_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_AppointmentTag_appointment_id] ON [dbo].[AppointmentTag]([appointment_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_AppointmentTag_tag_id] ON [dbo].[AppointmentTag]([tag_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_Availability_clinician_id] ON [dbo].[Availability]([clinician_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_Availability_time_range] ON [dbo].[Availability]([start_time], [end_time]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_ClientGroupMembership_client_id] ON [dbo].[ClientGroupMembership]([client_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_BillingAddress_clinician_id] ON [dbo].[BillingAddress]([clinician_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_AppointmentLimit_clinician_id] ON [dbo].[AppointmentLimit]([clinician_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_AppointmentLimit_date] ON [dbo].[AppointmentLimit]([date]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [EmailTemplate_type_idx] ON [dbo].[EmailTemplate]([type]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [EmailTemplate_created_by_idx] ON [dbo].[EmailTemplate]([created_by]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_RolePermission_role_id] ON [dbo].[RolePermission]([role_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_RolePermission_permission_id] ON [dbo].[RolePermission]([permission_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_ClientGroupFile_client_group_id] ON [dbo].[ClientGroupFile]([client_group_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_ClientGroupFile_uploaded_by_id] ON [dbo].[ClientGroupFile]([uploaded_by_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_Statement_client_group_id] ON [dbo].[Statement]([client_group_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_Superbill_client_group_id] ON [dbo].[Superbill]([client_group_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [BillingSettings_clinician_id_idx] ON [dbo].[BillingSettings]([clinician_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_Diagnosis_Code] ON [dbo].[Diagnosis]([code]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_DiagnosisTreatmentPlan_ClientId] ON [dbo].[DiagnosisTreatmentPlan]([client_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_DiagnosisTreatmentPlan_SurveyAnswersId] ON [dbo].[DiagnosisTreatmentPlan]([survey_answers_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_DiagnosisTreatmentPlanItem_DiagnosisId] ON [dbo].[DiagnosisTreatmentPlanItem]([diagnosis_id]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [IX_DiagnosisTreatmentPlanItem_TreatmentPlanId] ON [dbo].[DiagnosisTreatmentPlanItem]([treatment_plan_id]);

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_Location] FOREIGN KEY ([location_id]) REFERENCES [dbo].[Location]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_PracticeService] FOREIGN KEY ([service_id]) REFERENCES [dbo].[PracticeService]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_RecurringAppointment] FOREIGN KEY ([recurring_appointment_id]) REFERENCES [dbo].[Appointment]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_Superbill] FOREIGN KEY ([superbill_id]) REFERENCES [dbo].[Superbill]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Appointment] ADD CONSTRAINT [FK_Appointment_User] FOREIGN KEY ([created_by]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[AppointmentTag] ADD CONSTRAINT [FK_AppointmentTag_Appointment] FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[AppointmentTag] ADD CONSTRAINT [FK_AppointmentTag_Tag] FOREIGN KEY ([tag_id]) REFERENCES [dbo].[Tag]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Audit] ADD CONSTRAINT [FK_Audit_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Audit] ADD CONSTRAINT [FK_Audit_User] FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Availability] ADD CONSTRAINT [FK_Availability_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Availability] ADD CONSTRAINT [FK_Availability_Location] FOREIGN KEY ([location_id]) REFERENCES [dbo].[Location]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Client] ADD CONSTRAINT [FK_Client_Clinician] FOREIGN KEY ([primary_clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Client] ADD CONSTRAINT [FK_Client_Location] FOREIGN KEY ([primary_location_id]) REFERENCES [dbo].[Location]([id]) ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientProfile] ADD CONSTRAINT [FK_ClientProfile_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientAdress] ADD CONSTRAINT [FK_ClientAddress_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientContact] ADD CONSTRAINT [FK_ClientContact_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroup] ADD CONSTRAINT [FK_ClientGroup_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroupMembership] ADD CONSTRAINT [FK_ClientGroupMembership_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroupMembership] ADD CONSTRAINT [FK_ClientGroupMembership_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientReminderPreference] ADD CONSTRAINT [FK_ClientReminderPreference_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClientReminderPreference] ADD CONSTRAINT [FK_ClientReminderPreference_ClientContact] FOREIGN KEY ([contact_id]) REFERENCES [dbo].[ClientContact]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[BillingAddress] ADD CONSTRAINT [FK_BillingAddress_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Clinician] ADD CONSTRAINT [FK_Clinician_User] FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicianClient] ADD CONSTRAINT [FK_ClinicianClient_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicianClient] ADD CONSTRAINT [FK_ClinicianClient_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicianLocation] ADD CONSTRAINT [FK_ClinicianLocation_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicianLocation] ADD CONSTRAINT [FK_ClinicianLocation_Location] FOREIGN KEY ([location_id]) REFERENCES [dbo].[Location]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicianServices] ADD CONSTRAINT [FK_ClinicianServices_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicianServices] ADD CONSTRAINT [FK_ClinicianServices_PracticeService] FOREIGN KEY ([service_id]) REFERENCES [dbo].[PracticeService]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[CreditCard] ADD CONSTRAINT [FK_CreditCard_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Appointment] FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Payment] ADD CONSTRAINT [FK_Payment_CreditCard] FOREIGN KEY ([credit_card_id]) REFERENCES [dbo].[CreditCard]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Payment] ADD CONSTRAINT [FK_Payment_Invoice] FOREIGN KEY ([invoice_id]) REFERENCES [dbo].[Invoice]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[SurveyAnswers] ADD CONSTRAINT [FK_SurveyAnswers_Appointment] FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[SurveyAnswers] ADD CONSTRAINT [FK_SurveyAnswers_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[SurveyAnswers] ADD CONSTRAINT [FK_SurveyAnswers_SurveyTemplate] FOREIGN KEY ([template_id]) REFERENCES [dbo].[SurveyTemplate]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [FK_UserRole_Role] FOREIGN KEY ([role_id]) REFERENCES [dbo].[Role]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [FK_UserRole_User] FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClinicalInfo] ADD CONSTRAINT [FK_clinicalInfo_User] FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[License] ADD CONSTRAINT [FK_License_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[PracticeInformation] ADD CONSTRAINT [FK_PracticeInformation_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[AppointmentLimit] ADD CONSTRAINT [AppointmentLimit_clinician_id_fkey] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[RolePermission] ADD CONSTRAINT [FK_RolePermission_Permission] FOREIGN KEY ([permission_id]) REFERENCES [dbo].[Permission]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[RolePermission] ADD CONSTRAINT [FK_RolePermission_Role] FOREIGN KEY ([role_id]) REFERENCES [dbo].[Role]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroupFile] ADD CONSTRAINT [FK_ClientGroupFile_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroupFile] ADD CONSTRAINT [FK_ClientGroupFile_User] FOREIGN KEY ([uploaded_by_id]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Statement] ADD CONSTRAINT [FK_Statement_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Statement] ADD CONSTRAINT [FK_Statement_User] FOREIGN KEY ([created_by]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Superbill] ADD CONSTRAINT [FK_Superbill_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Superbill] ADD CONSTRAINT [FK_Superbill_User] FOREIGN KEY ([created_by]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[BillingSettings] ADD CONSTRAINT [BillingSettings_clinician_id_fkey] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[AppointmentNotes] ADD CONSTRAINT [FK_AppointmentNotes_Appointment] FOREIGN KEY ([appointment_id]) REFERENCES [dbo].[Appointment]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[AppointmentNotes] ADD CONSTRAINT [FK_AppointmentNotes_SurveyAnswers] FOREIGN KEY ([survey_answer_id]) REFERENCES [dbo].[SurveyAnswers]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientBillingPreferences] ADD CONSTRAINT [FK_ClientBillingPreferences_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientFiles] ADD CONSTRAINT [FK_ClientFiles_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientFiles] ADD CONSTRAINT [FK_ClientFiles_ClientGroupFile] FOREIGN KEY ([client_group_file_id]) REFERENCES [dbo].[ClientGroupFile]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientFiles] ADD CONSTRAINT [FK_ClientFiles_SurveyAnswers] FOREIGN KEY ([survey_answers_id]) REFERENCES [dbo].[SurveyAnswers]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroupServices] ADD CONSTRAINT [FK_ClientGroupServices_ClientGroup] FOREIGN KEY ([client_group_id]) REFERENCES [dbo].[ClientGroup]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ClientGroupServices] ADD CONSTRAINT [FK_ClientGroupServices_PracticeService] FOREIGN KEY ([service_id]) REFERENCES [dbo].[PracticeService]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DiagnosisTreatmentPlan] ADD CONSTRAINT [FK_DiagnosisTreatmentPlan_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DiagnosisTreatmentPlan] ADD CONSTRAINT [FK_DiagnosisTreatmentPlan_SurveyAnswers] FOREIGN KEY ([survey_answers_id]) REFERENCES [dbo].[SurveyAnswers]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DiagnosisTreatmentPlanItem] ADD CONSTRAINT [FK_DiagnosisTreatmentPlanItem_Diagnosis] FOREIGN KEY ([diagnosis_id]) REFERENCES [dbo].[Diagnosis]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DiagnosisTreatmentPlanItem] ADD CONSTRAINT [FK_DiagnosisTreatmentPlanItem_DiagnosisTreatmentPlan] FOREIGN KEY ([treatment_plan_id]) REFERENCES [dbo].[DiagnosisTreatmentPlan]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithEstimate] ADD CONSTRAINT [FK_GoodFaithEstimate_Client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Client]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithEstimate] ADD CONSTRAINT [FK_GoodFaithEstimate_Clinician] FOREIGN KEY ([clinician_id]) REFERENCES [dbo].[Clinician]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithEstimate] ADD CONSTRAINT [FK_GoodFaithEstimate_Location] FOREIGN KEY ([clinician_location_id]) REFERENCES [dbo].[Location]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithServices] ADD CONSTRAINT [FK_GoodFaithServices_Diagnosis] FOREIGN KEY ([diagnosis_id]) REFERENCES [dbo].[Diagnosis]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithServices] ADD CONSTRAINT [FK_GoodFaithServices_GoodFaithEstimate] FOREIGN KEY ([good_faith_id]) REFERENCES [dbo].[GoodFaithEstimate]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithServices] ADD CONSTRAINT [FK_GoodFaithServices_Location] FOREIGN KEY ([location_id]) REFERENCES [dbo].[Location]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[GoodFaithServices] ADD CONSTRAINT [FK_GoodFaithServices_PracticeService] FOREIGN KEY ([service_id]) REFERENCES [dbo].[PracticeService]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[StatementItem] ADD CONSTRAINT [FK_StatementItem_Statement] FOREIGN KEY ([statement_id]) REFERENCES [dbo].[Statement]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[AppointmentRequests] ADD CONSTRAINT [FK_AppointmentRequests_PracticeService] FOREIGN KEY ([service_id]) REFERENCES [dbo].[PracticeService]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[AvailabilityServices] ADD CONSTRAINT [FK_AvailabilityServices_Availability] FOREIGN KEY ([availability_id]) REFERENCES [dbo].[Availability]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[RequestContactItems] ADD CONSTRAINT [FK_RequestContactItems_AppointmentRequests] FOREIGN KEY ([appointment_request_id]) REFERENCES [dbo].[AppointmentRequests]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
