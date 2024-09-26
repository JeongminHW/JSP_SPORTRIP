package DB;

import javax.servlet.http.HttpServletRequest;

public class MUtil {
    // 매개변수가 숫자이면 true, 숫자가 아니면 false
    public static boolean isNumeric(String s) {
        try {
            Integer.parseInt(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // HttpServletRequest에서 name에 해당하는 파라미터를 int로 변환
    public static int parseInt(HttpServletRequest request, String name) {
        return parseInt(request, name, 0);  // 기본값 0을 제공
    }

    // 기본값을 제공하는 parseInt 메소드
    public static int parseInt(HttpServletRequest request, String name, int defaultValue) {
        try {
            String param = request.getParameter(name);
            if (param != null && isNumeric(param)) {
                return Integer.parseInt(param);
            }
        } catch (NumberFormatException e) {
            // 예외 발생 시 기본값 반환
        }
        return defaultValue;  // 파라미터가 없거나 숫자가 아닐 경우 기본값 반환
    }
}
