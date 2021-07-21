#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:3.1 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["FileJtlToSql/FileJtlToSql.csproj", "FileJtlToSql/"]
COPY ["JtlToSql/JtlToSql.csproj", "JtlToSql/"]
RUN dotnet restore "FileJtlToSql/FileJtlToSql.csproj"
COPY . .
WORKDIR "/src/FileJtlToSql"
RUN dotnet build "FileJtlToSql.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FileJtlToSql.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FileJtlToSql.dll"]