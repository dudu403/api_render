# Usando uma imagem base do .NET para o ambiente de execução
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Usando a imagem do SDK do .NET para construir a aplicação
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copiar o arquivo de projeto e restaurar dependências
COPY ["./api_render/api_render.csproj", "./api_render/"]
RUN dotnet restore "./api_render/api_render.csproj"

# Copiar o restante do código para dentro do container
COPY . .

# Compilar e publicar a aplicação
WORKDIR "/src/api_render"
RUN dotnet build "api_render.csproj" -c Release -o /app/build
RUN dotnet publish "api_render.csproj" -c Release -o /app/publish

# Criar a imagem final de execução
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "api_render.dll"]
