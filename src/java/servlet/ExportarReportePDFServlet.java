package servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import dao.RegistrarOrdenDAO;
import dao.RepuestoDAO;
import dao.ProveedorDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import modelo.OrdenTrabajo;
import modelo.Repuesto;
import modelo.Proveedor;


@WebServlet("/ExportarReportePDFServlet")
public class ExportarReportePDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String tipoReporte = request.getParameter("tipo");
        
        try {
            // Configurar respuesta para PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=reporte_" + tipoReporte + "_" + 
                             new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf");
            
            // Crear documento PDF
            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            OutputStream out = response.getOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, out);
            
            document.open();
            
            // Generar reporte según el tipo
            switch (tipoReporte) {
                case "mantenimientos":
                    generarReporteMantenimientos(document);
                    break;
                case "vencimientos":
                    generarReporteVencimientos(document);
                    break;
                case "valorizado":
                    generarReporteValorizado(document);
                    break;
                case "stock":
                    generarReporteStock(document);
                    break;
                case "proveedores":
                    generarReporteProveedores(document);
                    break;
                default:
                    generarReporteMantenimientos(document);
            }
            
            document.close();
            out.flush();
            out.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error al generar PDF: " + e.getMessage());
        }
    }
    
    private void generarReporteMantenimientos(Document document) throws DocumentException {
        // Título
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE DE MANTENIMIENTOS POR FECHAS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(10);
        document.add(title);
        
        // Información del reporte
        Font infoFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.GRAY);
        Paragraph info = new Paragraph("Fecha de generación: " + 
                                      new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()), infoFont);
        info.setAlignment(Element.ALIGN_CENTER);
        info.setSpacingAfter(20);
        document.add(info);
        
        // Obtener datos
        RegistrarOrdenDAO dao = new RegistrarOrdenDAO();
        List<OrdenTrabajo> ordenes = dao.listarOrdenes();
        
        // Crear tabla
        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        
        // Encabezados
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
        PdfPCell header;
        
        String[] headers = {"Fecha", "Vehículo", "Técnico", "Tipo", "Estado", "Km", "Costo"};
        for (String h : headers) {
            header = new PdfPCell(new Phrase(h, headerFont));
            header.setBackgroundColor(new BaseColor(0, 102, 204));
            header.setHorizontalAlignment(Element.ALIGN_CENTER);
            header.setPadding(8);
            table.addCell(header);
        }
        
        // Datos
        Font cellFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        double costoTotal = 0;
        
        for (OrdenTrabajo ot : ordenes) {
            table.addCell(new Phrase(ot.getFechaEmision() != null ? sdf.format(ot.getFechaEmision()) : "-", cellFont));
            table.addCell(new Phrase(ot.getPlaca() != null ? ot.getPlaca() : "N/A", cellFont));
            table.addCell(new Phrase(ot.getNombreTecnico() != null ? ot.getNombreTecnico() : "Sin asignar", cellFont));
            table.addCell(new Phrase(ot.getTipo() != null ? ot.getTipo() : "N/A", cellFont));
            table.addCell(new Phrase(ot.getEstado() != null ? ot.getEstado() : "N/A", cellFont));
            table.addCell(new Phrase(String.format("%,d km", ot.getKilometraje()), cellFont));
            table.addCell(new Phrase("S/ 0.00", cellFont)); // Placeholder para costo
        }
        
        document.add(table);
        
        // Total
        Paragraph total = new Paragraph("\nTotal de órdenes: " + ordenes.size(), 
                                       new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        total.setSpacingBefore(15);
        document.add(total);
    }
    
    private void generarReporteVencimientos(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE DE VENCIMIENTOS DE PREVENTIVOS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        Paragraph info = new Paragraph("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), 
                                      new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.GRAY));
        info.setAlignment(Element.ALIGN_CENTER);
        info.setSpacingAfter(20);
        document.add(info);
        
        // Placeholder - aquí conectarías con tu DAO de planes de mantenimiento
        Paragraph placeholder = new Paragraph("Reporte de vencimientos en desarrollo", 
                                             new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC));
        placeholder.setAlignment(Element.ALIGN_CENTER);
        document.add(placeholder);
    }
    
    private void generarReporteValorizado(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE VALORIZADO DE MANTENIMIENTOS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        Paragraph info = new Paragraph("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), 
                                      new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.GRAY));
        info.setAlignment(Element.ALIGN_CENTER);
        info.setSpacingAfter(20);
        document.add(info);
        
        Paragraph placeholder = new Paragraph("Reporte valorizado en desarrollo", 
                                             new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC));
        placeholder.setAlignment(Element.ALIGN_CENTER);
        document.add(placeholder);
    }
    
    private void generarReporteStock(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE DE STOCK Y MOVIMIENTOS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        Paragraph info = new Paragraph("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), 
                                      new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.GRAY));
        info.setAlignment(Element.ALIGN_CENTER);
        info.setSpacingAfter(20);
        document.add(info);
        
        // Obtener datos de repuestos
        RepuestoDAO dao = new RepuestoDAO();
        List<Repuesto> repuestos = dao.listarTodos();
        
        // Crear tabla
        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        
        // Encabezados
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, BaseColor.WHITE);
        String[] headers = {"Código", "Descripción", "Stock Actual", "Stock Mínimo", "Categoría", "Estado"};
        
        for (String h : headers) {
            PdfPCell header = new PdfPCell(new Phrase(h, headerFont));
            header.setBackgroundColor(new BaseColor(0, 102, 204));
            header.setHorizontalAlignment(Element.ALIGN_CENTER);
            header.setPadding(8);
            table.addCell(header);
        }
        
        // Datos
        Font cellFont = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL);
        for (Repuesto rep : repuestos) {
            table.addCell(new Phrase(rep.getCodigo(), cellFont));
            table.addCell(new Phrase(rep.getDescripcion(), cellFont));
            table.addCell(new Phrase(String.valueOf(rep.getCantidadActual()), cellFont));
            table.addCell(new Phrase(String.valueOf(rep.getStockMinimo()), cellFont));
            table.addCell(new Phrase(rep.getCategoria(), cellFont));
            
            String estado = rep.stockBajo() ? "BAJO STOCK" : "Normal";
            PdfPCell estadoCell = new PdfPCell(new Phrase(estado, cellFont));
            if (rep.stockBajo()) {
                estadoCell.setBackgroundColor(new BaseColor(255, 200, 200));
            }
            table.addCell(estadoCell);
        }
        
        document.add(table);
        
        Paragraph total = new Paragraph("\nTotal de productos: " + repuestos.size(), 
                                       new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        total.setSpacingBefore(15);
        document.add(total);
    }
    
    private void generarReporteProveedores(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE DE PROVEEDORES", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        Paragraph info = new Paragraph("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), 
                                      new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.GRAY));
        info.setAlignment(Element.ALIGN_CENTER);
        info.setSpacingAfter(20);
        document.add(info);
        
        // Obtener datos de proveedores
        ProveedorDAO dao = new ProveedorDAO();
        List<Proveedor> proveedores = dao.listarProveedores();
        
        // Crear tabla
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        
        // Encabezados
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
        String[] headers = {"Razón Social", "Contacto", "Teléfono", "Email", "Calificación"};
        
        for (String h : headers) {
            PdfPCell header = new PdfPCell(new Phrase(h, headerFont));
            header.setBackgroundColor(new BaseColor(0, 102, 204));
            header.setHorizontalAlignment(Element.ALIGN_CENTER);
            header.setPadding(8);
            table.addCell(header);
        }
        
        // Datos
        Font cellFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL);
        for (Proveedor prov : proveedores) {
            table.addCell(new Phrase(prov.getRazonSocial(), cellFont));
            table.addCell(new Phrase(prov.getContacto() != null ? prov.getContacto() : "-", cellFont));
            table.addCell(new Phrase(prov.getTelefono() != null ? prov.getTelefono() : "-", cellFont));
            table.addCell(new Phrase(prov.getEmail() != null ? prov.getEmail() : "-", cellFont));
            
            String estrellas = "★".repeat(prov.getCalificacion()) + "☆".repeat(5 - prov.getCalificacion());
            table.addCell(new Phrase(estrellas, cellFont));
        }
        
        document.add(table);
        
        Paragraph total = new Paragraph("\nTotal de proveedores: " + proveedores.size(), 
                                       new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        total.setSpacingBefore(15);
        document.add(total);
    }
}