# Pearl Assignment - Document Management API

A Rails API-only application for managing documents within vaults, featuring file upload capabilities, metadata tracking, and secure API key authentication.

## Overview

As requested, this application provides a RESTful API for managing documents within user-owned vaults. Users can create vaults, upload documents with metadata tracking, and manage their files through a secure API key authentication system.

## Features

### Core Functionality
- **User Management**: Create, read, update, and delete users
- **Vault Management**: Organize documents into user-owned vaults
- **Document Management**: Upload, update, and delete documents with file storage
- **File Upload**: Support for file uploads with metadata extraction
- **API Key Authentication**: Secure access with private and shareable API keys

### File Management Features
- **Local File Storage**: Files stored in organized directory structure
- **Metadata Extraction**: Automatic extraction of file size, content type, upload details
- **Storage Organization**: Files organized by vault ID in storage directory

### API Features
- **RESTful Design**: Standard HTTP methods and status codes
- **JSON Serialization**: Consistent JSON responses using ActiveModel serializers
- **Error Handling**: Error responses with appropriate HTTP status codes
- **Parameter Validation**: Strong parameters for security

## Database Schema

### Users Table
```sql
users:
  - id (bigint, primary key)
  - name (string, not null)
  - email (string, not null, unique)
  - created_at (datetime)
  - updated_at (datetime)
```

### API Keys Table
```sql
api_keys:
  - id (bigint, primary key)
  - user_id (bigint, foreign key)
  - secret (string, not null, unique)
  - shareable (boolean, default: true)
  - created_at (datetime)
  - updated_at (datetime)
```

### Vaults Table
```sql
vaults:
  - id (bigint, primary key)
  - user_id (bigint, foreign key)
  - name (string)
  - created_at (datetime)
  - updated_at (datetime)
```

### Documents Table
```sql
documents:
  - id (bigint, primary key)
  - vault_id (bigint, foreign key)
  - name (string, not null)
  - file_url (string, not null, default: "")
  - metadata (jsonb, not null, default: {})
  - created_at (datetime)
  - updated_at (datetime)
```

## Authentication

The API uses a custom API key authentication system with two types of keys:

### API Key Types
- **Private Key**: Full access to all operations
- **Shareable Key**: Read-only access to public endpoints

### Authentication Headers
```http
x-api-key: your_api_key_here
```

### Key Generation
- Automatically generated when a user is created
- 64-character hexadecimal string
- One private key and one shareable key per user

## File Management

### File Storage Structure
```
storage/
└── documents/
    └── {vault_id}/
        └── {filename}
```

### Metadata Tracking
Each uploaded file includes the following metadata information:
```json
{
  "file_size": 1024,
  "content_type": "application/pdf",
  "original_filename": "document.pdf",
  "uploaded_at": "2023-10-23T10:30:00Z",
  "file_extension": ".pdf",
  "user_agent": "Mozilla/5.0...",
  "ip_address": "192.168.1.1"
}
```

## Development notes

- I started by designing up all the models, serializers, and controllers without touching the code. I did forget initially that the files were supposed to be saved locally, so in the beginning I designed it just saving the file_url.
- I decided to create 2 api_keys per user, one private and one shareable. It's a common practice, and I thought it served well for this project. 
- After designing the models and controllers, I started coding them. During coding, I realized some validations I had forgotten, so I added them during this moment.
- After that, I was pretty satisfied with what I had done. I would prefer to separate the model code in concerns, but since this is a small project, I think it's unnecessary. In a bigger project I would definitely do it.
- Then it was time to code the tests. I didn't go overboard with it, just a small number of unit tests.
- It was while coding the tests that I realized that I had forgotten about the file upload to the local storage. It was then that I added active_storage and started working on refactoring what needed to be refactored in the models, serializers and controllers.
- I decided to go with active_storage because it is the most "rails way" to do it and the one I'm most familiar with.
- I think I added enough metadata, but I'm sure I forgot something. I would probably add more metadata information in different circumstances
- After that, I refactored and added to the test suit to make sure the file upload was covered and working properly.
- After that everything was working fine, I added the documentation and pushed it to the repository.
- For next steps, I would move the file upload to a background job and move from the local storage to a cloud storage, like S3.
- I would also add cache to the API endpoints. For now every request is going to the database, but a simple result-caching solution with Redis would be really useful.
- Another point of improvement would be to add better error handling and monitoring. Amazon cloudwatch and Sentry would be great tools for that.
- Some useful gems are also missing, like bullet and annotate for example. I would add them to the project.

## Execution Instructions

### Prerequisites
- Ruby 3.x
- PostgreSQL
- Rails 8.0
- Git

### Setup and Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pearl-assignment
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   # Create database
   rails db:create
   
   # Run migrations
   rails db:migrate
   ```

4. **Start the server**
   ```bash
   rails server
   ```
   The API will be available at `http://localhost:3000`

### Environment Configuration

1. **Database Configuration**
   - Update `config/database.yml` if needed
   - Ensure PostgreSQL is running
   - Default database names: `pearl_assignment_development`, `pearl_assignment_test`

2. **Storage Configuration**
   - Files are stored in `storage/` directory
   - Ensure the application has write permissions to the storage directory

### Running the Application

1. **Start the Rails server**
   ```bash
   rails server
   # or
   rails s
   ```

2. **Access the API**
   - Base URL: `http://localhost:3000`
   - Health check: `http://localhost:3000/up`

3. **Stop the server**
   - Press `Ctrl+C` in the terminal

## Testing Instructions

### Running Tests

1. **Run all tests**
   ```bash
   rails test
   ```

2. **Run specific test files**
   ```bash
   # Controller tests
   rails test test/controllers/documents_controller_test.rb
   rails test test/controllers/vaults_controller_test.rb
   rails test test/controllers/users_controller_test.rb
   
   # Model tests
   rails test test/models/document_test.rb
   rails test test/models/vault_test.rb
   rails test test/models/user_test.rb
   rails test test/models/api_key_test.rb
   ```

### Test Database Setup

1. **Prepare test database**
   ```bash
   rails db:test:prepare
   ```

2. **Reset test database**
   ```bash
   rails db:test:reset
   ```

### Test Coverage

The test suite covers:

- **Authentication Tests**
  - API key validation
  - Private vs shareable key permissions
  - Unauthorized access handling

- **User Management Tests**
  - User creation, update, deletion
  - Email validation
  - API key generation

- **Vault Management Tests**
  - Vault CRUD operations
  - User association
  - Authorization checks

- **Document Management Tests**
  - File upload functionality
  - Metadata extraction
  - File update and deletion
  - File storage verification

- **Model Tests**
  - Data validation
  - Association testing
  - Method functionality

### Test Files Structure

```
test/
├── controllers/
│   ├── documents_controller_test.rb
│   ├── vaults_controller_test.rb
│   └── users_controller_test.rb
├── models/
│   ├── document_test.rb
│   ├── vault_test.rb
│   ├── user_test.rb
│   └── api_key_test.rb
├── fixtures/
│   ├── users.yml
│   ├── vaults.yml
│   ├── documents.yml
│   └── api_keys.yml
└── test_helper.rb
```

### Test Debugging

1. **Verbose output**
   ```bash
   rails test -v
   ```

2. **Debug specific test**
   ```bash
   rails test test/controllers/documents_controller_test.rb -n test_document_can_be_created --verbose
   ```

3. **Check test database**
   ```bash
   rails dbconsole -e test
   ```

### Test Data Cleanup

The test suite automatically:
- Cleans up uploaded files after tests
- Resets database state between tests
- Removes temporary files
- Cleans up storage directories