ARG DOTNET_OS_VERSION="-alpine"
ARG DOTNET_SDK_VERSION=8.0

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION}${DOTNET_OS_VERSION} AS build
WORKDIR /src

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_SDK_VERSION}${DOTNET_OS_VERSION} AS final
RUN apk add --no-cache icu-libs
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 8080
WORKDIR /app
COPY --from=build /app .

# Create a writable data directory for SQLite, owned by the app user
RUN mkdir -p /app/data && chown -R $APP_UID:$APP_UID /app

USER $APP_UID
ENTRYPOINT [ "dotnet", "MeowNet.API.dll" ]