package servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;

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

@WebServlet("/ExportarReporteExcelServlet")
public class ExportarReporteExcelServlet extends HttpServlet {
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
            // Configurar respuesta para Excel
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=reporte_" + tipoReporte + "_" + 
                             new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".xlsx");
            
            // Crear workbook
            XSSFWorkbook workbook = new XSSFWorkbook();
            
            // Generar reporte según el tipo
            switch (tipoReporte) {
                case "mantenimientos":
                    generarReporteMantenimientos(workbook);
                    break;
                case "vencimientos":
                    generarReporteVencimientos(workbook);
                    break;
                case "valorizado":
                    generarReporteValorizado(workbook);
                    break;
                case "stock":
                    generarReporteStock(workbook);
                    break;
                case "proveedores":
                    generarReporteProveedores(workbook);
                    break;
                default:
                    generarReporteMantenimientos(workbook);
            }
            
            // Escribir y cerrar
            OutputStream out = response.getOutputStream();
            workbook.write(out);
            workbook.close();
            out.flush();
            out.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error al generar Excel: " + e.getMessage());
        }
    }
    
    private void generarReporteMantenimientos(XSSFWorkbook workbook) {
        XSSFSheet sheet = workbook.createSheet("Mantenimientos");
        
        // Estilos
        CellStyle headerStyle = workbook.createCellStyle();
        XSSFFont headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        
        // Título
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("REPORTE DE MANTENIMIENTOS POR FECHAS");
        CellStyle titleStyle = workbook.createCellStyle();
        XSSFFont titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        // Fecha
        Row dateRow = sheet.createRow(1);
        dateRow.createCell(0).setCellValue("Fecha de generación: " + 
                                          new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()));
        
        // Encabezados
        Row headerRow = sheet.createRow(3);
        String[] headers = {"Fecha", "Vehículo", "Técnico", "Tipo", "Estado", "Kilometraje", "Costo"};
        
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Datos
        RegistrarOrdenDAO dao = new RegistrarOrdenDAO();
        List<OrdenTrabajo> ordenes = dao.listarOrdenes();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        
        int rowNum = 4;
        for (OrdenTrabajo ot : ordenes) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(ot.getFechaEmision() != null ? sdf.format(ot.getFechaEmision()) : "-");
            row.createCell(1).setCellValue(ot.getPlaca() != null ? ot.getPlaca() : "N/A");
            row.createCell(2).setCellValue(ot.getNombreTecnico() != null ? ot.getNombreTecnico() : "Sin asignar");
            row.createCell(3).setCellValue(ot.getTipo() != null ? ot.getTipo() : "N/A");
            row.createCell(4).setCellValue(ot.getEstado() != null ? ot.getEstado() : "N/A");
            row.createCell(5).setCellValue(ot.getKilometraje());
            row.createCell(6).setCellValue(0.0); // Placeholder
        }
        
        // Ajustar ancho de columnas
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // Totales
        Row totalRow = sheet.createRow(rowNum + 1);
        Cell totalCell = totalRow.createCell(0);
        totalCell.setCellValue("Total de órdenes: " + ordenes.size());
        CellStyle boldStyle = workbook.createCellStyle();
        XSSFFont boldFont = workbook.createFont();
        boldFont.setBold(true);
        boldStyle.setFont(boldFont);
        totalCell.setCellStyle(boldStyle);
    }
    
    private void generarReporteVencimientos(XSSFWorkbook workbook) {
        XSSFSheet sheet = workbook.createSheet("Vencimientos");
        
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("REPORTE DE VENCIMIENTOS DE PREVENTIVOS");
        
        Row dateRow = sheet.createRow(1);
        dateRow.createCell(0).setCellValue("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
        
        Row placeholderRow = sheet.createRow(3);
        placeholderRow.createCell(0).setCellValue("Reporte en desarrollo");
        
        sheet.autoSizeColumn(0);
    }
    
    private void generarReporteValorizado(XSSFWorkbook workbook) {
        XSSFSheet sheet = workbook.createSheet("Valorizado");
        
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("REPORTE VALORIZADO DE MANTENIMIENTOS");
        
        Row dateRow = sheet.createRow(1);
        dateRow.createCell(0).setCellValue("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
        
        Row placeholderRow = sheet.createRow(3);
        placeholderRow.createCell(0).setCellValue("Reporte en desarrollo");
        
        sheet.autoSizeColumn(0);
    }
    
    private void generarReporteStock(XSSFWorkbook workbook) {
        XSSFSheet sheet = workbook.createSheet("Stock");
        
        // Estilos
        CellStyle headerStyle = workbook.createCellStyle();
        XSSFFont headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        // Título
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("REPORTE DE STOCK Y MOVIMIENTOS");
        
        Row dateRow = sheet.createRow(1);
        dateRow.createCell(0).setCellValue("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
        
        // Encabezados
        Row headerRow = sheet.createRow(3);
        String[] headers = {"Código", "Descripción", "Categoría", "Stock Actual", "Stock Mínimo", "Estado"};
        
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Datos
        RepuestoDAO dao = new RepuestoDAO();
        List<Repuesto> repuestos = dao.listarTodos();
        
        CellStyle alertStyle = workbook.createCellStyle();
        alertStyle.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.getIndex());
        alertStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        int rowNum = 4;
        for (Repuesto rep : repuestos) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rep.getCodigo());
            row.createCell(1).setCellValue(rep.getDescripcion());
            row.createCell(2).setCellValue(rep.getCategoria());
            row.createCell(3).setCellValue(rep.getCantidadActual());
            row.createCell(4).setCellValue(rep.getStockMinimo());
            
            Cell estadoCell = row.createCell(5);
            if (rep.stockBajo()) {
                estadoCell.setCellValue("BAJO STOCK");
                estadoCell.setCellStyle(alertStyle);
            } else {
                estadoCell.setCellValue("Normal");
            }
        }
        
        // Ajustar columnas
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        Row totalRow = sheet.createRow(rowNum + 1);
        totalRow.createCell(0).setCellValue("Total de productos: " + repuestos.size());
    }
    
    private void generarReporteProveedores(XSSFWorkbook workbook) {
        XSSFSheet sheet = workbook.createSheet("Proveedores");
        
        // Estilos
        CellStyle headerStyle = workbook.createCellStyle();
        XSSFFont headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        // Título
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("REPORTE DE PROVEEDORES");
        
        Row dateRow = sheet.createRow(1);
        dateRow.createCell(0).setCellValue("Fecha: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
        
        // Encabezados
        Row headerRow = sheet.createRow(3);
        String[] headers = {"Razón Social", "Contacto", "Teléfono", "Email", "Calificación"};
        
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Datos
        ProveedorDAO dao = new ProveedorDAO();
        List<Proveedor> proveedores = dao.listarProveedores();
        
        int rowNum = 4;
        for (Proveedor prov : proveedores) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(prov.getRazonSocial());
            row.createCell(1).setCellValue(prov.getContacto() != null ? prov.getContacto() : "-");
            row.createCell(2).setCellValue(prov.getTelefono() != null ? prov.getTelefono() : "-");
            row.createCell(3).setCellValue(prov.getEmail() != null ? prov.getEmail() : "-");
            row.createCell(4).setCellValue(prov.getCalificacion());
        }
        
        // Ajustar columnas
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        Row totalRow = sheet.createRow(rowNum + 1);
        totalRow.createCell(0).setCellValue("Total de proveedores: " + proveedores.size());
    }
}