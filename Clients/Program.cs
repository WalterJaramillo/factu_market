using Clients.Data;
using Clients.Models;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Configuración de DbContext con Oracle
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseOracle(builder.Configuration.GetConnectionString("OracleDb")));

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

/// <summary>
/// Endpoint raíz para verificar el estado de la API.
/// </summary>
app.MapGet("/", () => "🚀 API Oracle conectada correctamente!");

/// <summary>
/// Obtiene todos los clientes.
/// </summary>
/// <returns>Lista de clientes.</returns>
app.MapGet("/clients", async (AppDbContext db) =>
{
    var clients = await db.Clients.ToListAsync();
    return Results.Ok(clients);
});

/// <summary>
/// Obtiene un cliente por su ID.
/// </summary>
/// <param name="id">ID del cliente.</param>
/// <returns>Cliente encontrado o 404 si no existe.</returns>
app.MapGet("/clients/{id}", async (AppDbContext db, int id) =>
{
    var client = await db.Clients.FindAsync(id);
    return client is not null ? Results.Ok(client) : Results.NotFound();
});

/// <summary>
/// Crea un nuevo cliente.
/// </summary>
/// <param name="client">Datos del cliente.</param>
/// <returns>Cliente creado con código 201.</returns>
app.MapPost("/clients", async (AppDbContext db, Client client) =>
{
    client.CreatedAt = DateTime.UtcNow;
    db.Clients.Add(client);
    await db.SaveChangesAsync();
    return Results.Created($"/clients/{client.Id}", client);
});

/// <summary>
/// Actualiza un cliente existente.
/// </summary>
/// <param name="id">ID del cliente a actualizar.</param>
/// <param name="updatedClient">Datos actualizados del cliente.</param>
/// <returns>Cliente actualizado o 404 si no existe.</returns>
app.MapPut("/clients/{id}", async (AppDbContext db, int id, Client updatedClient) =>
{
    var client = await db.Clients.FindAsync(id);
    if (client is null) return Results.NotFound();

    client.Name = updatedClient.Name;
    client.Email = updatedClient.Email;
    client.Identification = updatedClient.Identification;
    client.Address = updatedClient.Address;
    client.UpdatedAt = DateTime.UtcNow;

    await db.SaveChangesAsync();
    return Results.Ok(client);
});

/// <summary>
/// Elimina un cliente por su ID.
/// </summary>
/// <param name="id">ID del cliente a eliminar.</param>
/// <returns>204 si se elimina correctamente o 404 si no existe.</returns>
app.MapDelete("/clients/{id}", async (AppDbContext db, int id) =>
{
    var client = await db.Clients.FindAsync(id);
    if (client is null) return Results.NotFound();

    db.Clients.Remove(client);
    await db.SaveChangesAsync();
    return Results.NoContent();
});

app.Run();