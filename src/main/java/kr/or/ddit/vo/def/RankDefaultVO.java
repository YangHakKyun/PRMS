package kr.or.ddit.vo.def;

import java.io.Serializable;
import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import lombok.Data;

@Data
public class RankDefaultVO implements Serializable {
    private String memNo;

    private String rankSe;

    @DateTimeFormat(iso=ISO.DATE)
    private LocalDate rankDe;

    private static final long serialVersionUID = 1L;
}