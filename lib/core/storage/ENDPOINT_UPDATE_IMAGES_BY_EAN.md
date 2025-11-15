# Endpoint: updateImagesByEAN

## Overview
Updates product images by EAN code. This endpoint downloads images from provided URLs, uploads them to Digital Ocean Spaces, updates the database, and synchronizes with Solr search engine.

## Endpoint Details
- **Method**: `updateImagesByEAN`
- **Path**: `/product/updateImagesByEAN`
- **Authentication**: Required (Token-based)
- **Permissions**: `EnumPermission.editProduct`

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `token` | String | Yes | Authentication token |
| `codeEAN` | String | Yes | Product EAN code (must be valid) |
| `confirmedImageUrls` | List<String> | Yes | List of image URLs to download and set as product images |

## Validations

### Input Validations
1. **EAN Code Validation**: Must be a valid EAN format
2. **Image URLs Validation**: 
   - List cannot be empty
   - URLs must be valid HTTP/HTTPS URLs
   - URLs must point to accessible image files
3. **Product Existence**: Product with the specified EAN must exist in database
4. **Permission Check**: User must have `editProduct` permission

### Business Logic Validations
1. **Image Download Validation**: All images must be successfully downloaded (any failure stops the entire process)
2. **Image Format Validation**: Downloaded files must be valid images
3. **File Size Validation**: Images must be within acceptable size limits

## Request Example

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "codeEAN": "1234567890123",
  "confirmedImageUrls": [
    "https://example.com/image1.jpg",
    "https://example.com/image2.png",
    "https://example.com/image3.webp"
  ]
}
```

## Response Structure

### Success Response
```json
{
  "product": {
    "id": 123,
    "codeEAN": "1234567890123",
    "name": "Product Name",
    "imagesPathList": [
      "https://icnortecdn.nyc3.cdn.digitaloceanspaces.com/development/store/products/1234567890123-01.jpg",
      "https://icnortecdn.nyc3.cdn.digitaloceanspaces.com/development/store/products/1234567890123-02.png",
      "https://icnortecdn.nyc3.cdn.digitaloceanspaces.com/development/store/products/1234567890123-03.webp"
    ]
  },
  "failedImages": [],
  "totalRequested": 3,
  "totalSuccessful": 3,
  "totalFailed": 0
}
```

### Partial Success Response
```json
{
  "product": {
    "id": 123,
    "codeEAN": "1234567890123",
    "name": "Product Name",
    "imagesPathList": [
      "https://icnortecdn.nyc3.cdn.digitaloceanspaces.com/development/store/products/1234567890123-01.jpg",
      "https://icnortecdn.nyc3.cdn.digitaloceanspaces.com/development/store/products/1234567890123-02.png"
    ]
  },
  "failedImages": [
    "https://example.com/image3.webp"
  ],
  "totalRequested": 3,
  "totalSuccessful": 2,
  "totalFailed": 1
}
```

### Error Response
```json
{
  "success": false,
  "message": "Product with EAN 1234567890123 not found",
  "error": "NOT_FOUND"
}
```

## Process Flow

### 1. Authentication & Authorization
- Validates authentication token
- Checks user has `editProduct` permission

### 2. Input Validation
- Validates EAN code format
- Validates image URLs list is not empty
- Validates each URL is accessible

### 3. Product Retrieval
- Fetches product from database by EAN code
- Throws `NotFoundException` if product doesn't exist

### 4. Image Download Process
- Downloads all images from provided URLs
- Validates downloaded files are valid images
- **Critical**: Any download failure stops the entire process

### 5. Image Upload Process
- Uploads downloaded images to Digital Ocean Spaces
- Renames files using pattern: `{EAN}-{position}.{extension}`
- Tracks successful and failed uploads

### 6. Database Update & Solr Sync
- Updates product's `imagesPathList` with successful uploads
- Synchronizes with Solr using atomic updates
- Updates all ProductStore records for the product

### 7. Cleanup Process
- Deletes old images that are no longer needed
- Only deletes after confirming successful database update

### 8. Response Generation
- Returns updated product with new image paths
- Includes statistics about successful and failed uploads

## Services Involved

### Core Services
1. **ProductUpdateService.imagesByEAN()**
   - Main orchestrator service
   - Coordinates all operations

2. **ProductImageDownloadService.getAll()**
   - Downloads images from URLs
   - Validates image files

3. **ProductImageUploadService.pushAll()**
   - Uploads images to Digital Ocean Spaces
   - Handles file renaming

4. **SyncService.updateProductImages()**
   - Updates database with new image paths
   - Synchronizes with Solr using atomic updates

### Supporting Services
1. **DigitalOceanSpaceService**
   - Handles file uploads to CDN
   - Manages file deletions

2. **SolrService**
   - Manages search index updates
   - Creates atomic updates for ProductStore records

## Error Handling

### Critical Errors (Process Stops)
- Invalid EAN code
- Product not found
- Authentication/permission failures
- Any image download failure
- Invalid image URLs

### Non-Critical Errors (Process Continues)
- Individual image upload failures
- Old image deletion failures
- Solr synchronization issues (logged but doesn't stop process)

### Error Types
- `BadRequestException`: Invalid input parameters
- `NotFoundException`: Product not found
- `UnauthorizedException`: Authentication/permission issues
- `InternalServerErrorException`: Database or service errors

## Performance Considerations

### Optimizations
- Parallel image downloads and uploads
- Atomic Solr updates (no full document reindexing)
- Batch file operations for cleanup

### Limitations
- Download failures stop entire process
- Network-dependent operations
- CDN upload timeouts

## Security Considerations

### Input Validation
- URL validation to prevent SSRF attacks
- File type validation
- File size limits
- EAN code format validation

### Access Control
- Token-based authentication
- Permission-based authorization

### Data Protection
- Secure file uploads to CDN
- Database transaction safety

## Monitoring & Logging

### Key Metrics
- Total images processed
- Success/failure rates
- Processing time
- CDN operation statistics
- Solr synchronization status

## Testing Scenarios

### Unit Tests
- Input validation tests
- Service method tests
- Error handling tests

### Integration Tests
- Complete flow testing
- CDN integration testing
- Solr synchronization testing

### Edge Cases
- Empty image list
- Invalid URLs
- Network timeouts
- CDN failures
- Solr unavailability
- Large image files 