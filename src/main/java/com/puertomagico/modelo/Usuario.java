package com.puertomagico.modelo;

import java.time.LocalDateTime;

public class Usuario {
    
    private Integer id;
    private String nombre;
    private String apellido;
    private String email;
    private String passwordHash;
    private String telefono;
    private String rol;
    private LocalDateTime createdAt;

    public Usuario() {
    }
    
    public Usuario(Integer id, String nombre, String apellido, String email,
                   String passwordHash, String telefono, String rol,
                   LocalDateTime createdAt) {
        this.id = id;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.passwordHash = passwordHash;
        this.telefono = telefono;
        this.rol = rol;
        this.createdAt = createdAt;
    }

   
    public boolean isAdmin() {
        return "ADMIN".equals(this.rol);
    }

    public String getNombreCompleto() {
        return this.nombre + " " + this.apellido;
    }

    
    // GETTERS Y SETTERS 

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Usuario{" +
               "id=" + id +
               ", nombre='" + getNombreCompleto() + '\'' +
               ", email='" + email + '\'' +
               ", rol='" + rol + '\'' +
               '}';
    }
}