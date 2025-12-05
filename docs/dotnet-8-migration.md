# .NET 8.0 LTS Migration Guide

## Overview
This document describes the migration from .NET 6.0 to .NET 8.0 LTS for the ZavaStorefront application.

## Migration Date
December 5, 2025

## Version Details
- **Previous Version**: .NET 6.0 (End of Life)
- **New Version**: .NET 8.0 (Long Term Support)
- **LTS Support Period**: .NET 8.0 is supported until November 10, 2026

## Changes Made

### 1. Project File Updates
- **File**: `src/ZavaStorefront.csproj`
- **Change**: Updated `<TargetFramework>` from `net6.0` to `net8.0`

### 2. Docker Configuration
- **File**: `src/Dockerfile` (newly created)
- **Change**: Created a multi-stage Dockerfile using .NET 8.0 SDK and runtime images
- **Base Images**:
  - Build stage: `mcr.microsoft.com/dotnet/sdk:8.0`
  - Runtime stage: `mcr.microsoft.com/dotnet/aspnet:8.0`
- **Port Configuration**: Configured to expose port 8080 as required by Azure App Service

## Testing Results

### Build Status
✅ **PASSED** - Project builds successfully with .NET 8.0
- No compilation errors
- Same nullable reference warnings as .NET 6.0 (no new issues introduced)

### Docker Build Status
✅ **PASSED** - Docker image builds successfully
- Multi-stage build completes without errors
- Application correctly packaged for deployment

### Application Start
✅ **PASSED** - Application starts and initializes correctly
- All services registered properly
- Configuration loaded successfully

## Breaking Changes
**None identified** - The migration from .NET 6.0 to .NET 8.0 had no breaking changes for this application.

## Known Issues
No new issues were introduced during the migration. Pre-existing nullable reference warnings remain:
- `ProductService.cs`: Line 98 - Possible null reference return
- `CartService.cs`: Lines 20, 92, 110 - Dereference of possibly null reference
- `Product.cs`: Lines 6, 7, 9 - Non-nullable properties without initialization
- `CartItem.cs`: Line 5 - Non-nullable property without initialization

These warnings existed in .NET 6.0 and are unrelated to the framework upgrade.

## Deployment Considerations

### Azure Container Apps
The application is configured for deployment to Azure Container Apps via:
- GitHub Actions workflow (`.github/workflows/deploy.yml`)
- Azure Container Registry for image storage
- Dockerfile in `src/` directory

### Environment Variables
The following environment variables are configured in the Dockerfile and Azure:
- `ASPNETCORE_URLS=http://+:8080` - Required for Azure App Service
- `WEBSITES_PORT=8080` - Azure App Service port configuration

## Rollback Plan
If rollback is needed:
1. Revert `src/ZavaStorefront.csproj` to target `net6.0`
2. Remove or update `src/Dockerfile` to use .NET 6.0 base images
3. Run `dotnet restore` and `dotnet build`

Note: .NET 6.0 has reached End of Life and is no longer receiving security updates. Rollback is not recommended.

## Recommendations
1. ✅ Immediate: Upgrade complete - application running on .NET 8.0 LTS
2. Monitor application logs post-deployment for any runtime issues
3. Address pre-existing nullable reference warnings in a future update
4. Plan for .NET 9.0 evaluation (when it reaches LTS status in November 2025)

## References
- [.NET 8.0 Release Notes](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-8)
- [.NET Support Policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core)
- [ASP.NET Core 8.0 Migration Guide](https://learn.microsoft.com/en-us/aspnet/core/migration/70-to-80)
