echo "Scaffolding db context ..."

dotnet ef dbcontext scaffold "Name=ConnectionStrings:Default" Npgsql.EntityFrameworkCore.PostgreSQL \
  --project "./geo-back.csproj" \
  --output-dir "./Model/Generated" \
  --namespace "geo_back.Model" \
  --context "GeoBackContext" \
  --context-namespace "geo_back" \
  --no-pluralize \
  --no-build \
  --force


echo "Scaffolding db context finished."

echo "Нажмите любую клавишу для завершения..."
read -n 1 -s -r
