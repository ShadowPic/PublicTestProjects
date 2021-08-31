#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:3.1 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["Csv2RedisScript/Csv2RedisScript.csproj", "Csv2RedisScript/"]
RUN dotnet restore "Csv2RedisScript/Csv2RedisScript.csproj"
COPY . .
WORKDIR "/src/Csv2RedisScript"
RUN dotnet build "Csv2RedisScript.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Csv2RedisScript.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Csv2RedisScript.dll"]