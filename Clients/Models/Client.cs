namespace Clients.Models
{
    public class Client
    {
        public int Id { get; set; } // Identificador único (PK)

        public string Name { get; set; } = string.Empty; // Nombre o razón social

        public string Email { get; set; } = string.Empty; // Correo electrónico

        public string Identification { get; set; } = string.Empty; // NIT, cédula, etc.

        public string Address { get; set; } = string.Empty; // Dirección física

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow; // Fecha de creación

        public DateTime? UpdatedAt { get; set; } // Fecha de última actualización
    }
}