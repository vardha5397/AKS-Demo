#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS publish
WORKDIR /src
COPY ["DockAcr.csproj", "."]
RUN dotnet restore "./DockAcr.csproj"
COPY . .
RUN dotnet build "DockAcr.csproj" -c Release -o /app/build
RUN dotnet publish "DockAcr.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443	
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockAcr.dll"]