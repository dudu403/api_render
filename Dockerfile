# Usar a imagem base do SDK .NET para compilar o projeto
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar os arquivos do projeto para o contêiner
COPY . ./

# Restaurar dependências
RUN dotnet restore "api_render/api_render.csproj"

# Compilar o projeto
RUN dotnet publish "api_render/api_render.csproj" -c Release -o /out

# Usar a imagem base do runtime para o contêiner final
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final

# Definir o diretório de trabalho no contêiner final
WORKDIR /app

# Copiar os arquivos compilados do contêiner de build
COPY --from=build /out .

# Expor a porta na qual a aplicação irá rodar
EXPOSE 80

# Definir o comando que vai rodar a aplicação
ENTRYPOINT ["dotnet", "api_render.dll"]
